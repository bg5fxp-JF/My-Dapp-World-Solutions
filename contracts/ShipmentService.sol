// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

error NotOwner();
error NotCustomer();
error NotAccessible();
error OrderAlreadyPlaced();
error InvalidPin();

contract ShipmentService {

    // Type Declerations
    enum OrderStatus {
        NOT_PLACED,
        SHIPPED,
        DILIVERED
    }

    struct Order {
        OrderStatus status;
        uint OTP;
    }

    // State Variables
    address public owner;
    mapping (address => bool) private customerHasPlacedOrder;
    mapping (address => Order) private customerToOrder;
    mapping (address => uint256) private completedDeliveries;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if(msg.sender != owner) revert NotOwner();
        _;
    }

    
    //This function inititates the shipment
    function shipWithPin(address customerAddress, uint pin) public onlyOwner {
       if (customerAddress == owner) revert NotCustomer();
       if(customerHasPlacedOrder[customerAddress]) revert OrderAlreadyPlaced();
       if(!(pin > 999 && pin <= 9999)) revert InvalidPin(); 

        customerHasPlacedOrder[customerAddress] = true;

        Order memory newOrder = Order({status: OrderStatus.SHIPPED, OTP: pin});
        customerToOrder[customerAddress] = newOrder;
    }

    //This function acknowlegdes the acceptance of the delivery
    function acceptOrder(uint pin) public {
        if(msg.sender == owner || !customerHasPlacedOrder[msg.sender]) revert NotCustomer();   
        if(customerToOrder[msg.sender].OTP != pin) revert InvalidPin();

        customerToOrder[msg.sender].status = OrderStatus.DILIVERED;
        completedDeliveries[msg.sender]++;
        delete customerHasPlacedOrder[msg.sender];
    }

    //This function outputs the status of the delivery
    function checkStatus(address customerAddress) public view returns (string memory){
        if(!(msg.sender == owner || msg.sender == customerAddress)) revert NotAccessible();
        if (customerToOrder[customerAddress].status == OrderStatus.SHIPPED) { 
            return "shipped";
        } else if (customerToOrder[customerAddress].status == OrderStatus.DILIVERED) {
            return "delivered";
        } else {

            return "no orders placed";
        }

        
    }

    //This function outputs the total number of successful deliveries
    function totalCompletedDeliveries(address customerAddress) public view returns (uint) {
        if(!(msg.sender == owner || msg.sender == customerAddress)) revert NotAccessible();
        return completedDeliveries[customerAddress];
    }

    function getOrder(address customerAddress) public view returns (Order memory) {
        return customerToOrder[customerAddress];
    }
}