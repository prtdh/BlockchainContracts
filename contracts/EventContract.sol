// SPDX-License-Identifier: MIT

pragma solidity >= 0.5.0 <0.9.0;

contract EventContract{

struct Event{
    address organizer;
    string name;
    uint price;
    uint date;
    uint ticketCount;
    uint remainingTicket;
}
mapping (uint=>Event) public events;
mapping (address=> mapping(uint=>uint)) public tickets;
uint public nextId;
function createEvent(string memory name,uint date,uint price,uint ticketCount) external{
    require(date>block.timestamp,"Please schedule event for a valid time");
    require(ticketCount>0,"cannot create an event with zero tickets");
    events[nextId]=Event(msg.sender,name,price,date,ticketCount,ticketCount);
    nextId++;

}

function buyTickets(uint id,uint quantity) external payable{
    require(events[id].date!=0,"Event does not exists");
    require(events[id].date>block.timestamp,"Event has already occured");
    Event storage _event=events[id];
    require(msg.value== ((quantity*_event.price)),"not enough ethers");
    require(_event.remainingTicket>=quantity,"Not enough tickets remaining");
    _event.remainingTicket-=quantity;
    tickets[msg.sender][id]+=quantity;

}
function transferTicket(uint id,uint quantity,address to) external{
    require(events[id].date!=0,"Event does not exists");
    require(events[id].date>block.timestamp,"Event has already occured");
    require(tickets[msg.sender][id]>=quantity,"You does not have enough tickets");
    tickets[msg.sender][id]-=quantity;
    tickets[to][id]+=quantity;

}
}