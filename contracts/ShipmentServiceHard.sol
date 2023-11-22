// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

error NotOwner();
error NotCustomer();
error NotAccessible();
error OrderAlreadyPlaced();
error InvalidPin();

contract ShipmentService {

  
    // State Variables
    address public owner;
    mapping (address =>  mapping (uint256 => uint256)) private customerToOrder;
    mapping (address => uint256) private ordersPlaced;
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
       if(!(pin > 999 && pin <= 9999)) revert InvalidPin(); 
        customerToOrder[customerAddress][pin]++;
        ordersPlaced[customerAddress]++;
    }

    //This function acknowlegdes the acceptance of the delivery
    function acceptOrder(uint pin) public {
        if(msg.sender == owner || ordersPlaced[msg.sender] == 0) revert NotCustomer();   
        if(customerToOrder[msg.sender][pin] == 0) revert InvalidPin();

        customerToOrder[msg.sender][pin]--;
        ordersPlaced[msg.sender]--;
        completedDeliveries[msg.sender]++;
    }

    //This function outputs the status of the delivery
    function checkStatus(address customerAddress) public view returns (uint){
        if(!(msg.sender == owner || msg.sender == customerAddress)) revert NotAccessible();
        return ordersPlaced[customerAddress];
        
    }

    //This function outputs the total number of successful deliveries
    function totalCompletedDeliveries(address customerAddress) public view returns (uint) {
        if(!(msg.sender == owner || msg.sender == customerAddress)) revert NotAccessible();
        return completedDeliveries[customerAddress];
    }

}