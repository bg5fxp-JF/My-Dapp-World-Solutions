// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


error InvalidAmountTickets();
error RepeatedSeats();
error SeatTaken();
error MaxTicketsAlready();

contract TicketBooking {

    uint[] seats = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
    uint[] seats2 = new uint[](20);
    mapping (uint => bool) repititionCheck;
    mapping (address => uint[]) addressToTickets;

    //To book seats
    function bookSeats(uint[] memory seatNumbers) public {
        if(addressToTickets[msg.sender].length == 4) revert MaxTicketsAlready();
        if(seatNumbers.length < 1 || seatNumbers.length > 4) revert InvalidAmountTickets();
        if(checkSeatsRepeated(seatNumbers)) revert RepeatedSeats();
        unchecked {
            for (uint i; i < seatNumbers.length; i++) 
            {
                if(seats2[seatNumbers[i]-1] == 1) revert SeatTaken();
            }
            for (uint i; i < seatNumbers.length; i++) 
            {
                seats2[seatNumbers[i]-1] = 1;
                // for (uint j = seatNumbers[i]-1; j < seatNumbers.length - 1; j++) {
                //     seats[seatNumbers[j]] = seats[j+1];
                // }
                // seats[seatNumbers[i]-1] = seats[seats.length - 1];
                addressToTickets[msg.sender].push(seatNumbers[i]);
                // seats.pop();
            }

            uint y;
            uint size = seats.length - seatNumbers.length;
            seats = new uint[](size);
             for (uint i; i < seats2.length; i++) 
            {   
                if(seats2[i] != 1) {
                    seats[y++] = i+1;
                }

            }

        }
        
         
    }

    function checkSeatsRepeated(uint[] memory seatNumbers) public returns (bool) {
        
        bool ans = false;
        
        unchecked {
            for (uint i; i < seatNumbers.length; i++) {
                if(repititionCheck[seatNumbers[i]]) { ans = true;}
                repititionCheck[seatNumbers[i]] = true;
            }

            for (uint i; i < seatNumbers.length; i++) {
                repititionCheck[seatNumbers[i]] = false;
            }
        }

        return ans;

    }
    
    //To get available seats
    function showAvailableSeats() public view returns (uint[] memory) {
        return seats;
    }
    function showAvailableSeats2() public view returns (uint[] memory) {
        return seats2;
    }
    
    //To check availability of a seat
    function checkAvailability(uint seatNumber) public view returns (bool) {
        return (seats2[seatNumber - 1] == 0);
    }
    
    //To check tickets booked by the user
    function myTickets() public view returns (uint[] memory) {
        return addressToTickets[msg.sender];
    }
}
