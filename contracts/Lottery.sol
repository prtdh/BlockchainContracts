//SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

contract Lotter{
    address public manager;
    address payable[] public participants;
         uint count=1;

    constructor(){
        manager=msg.sender;
     }
     receive() external payable{
         require(msg.value==1 ether);
         participants.push(payable(msg.sender));
     }

     function getBalance() public view returns(uint){
         require(msg.sender==manager);
         return (address(this).balance);


     }
     function random() private  returns(uint){
         count++;
                 return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));

     }

     function selectWinner() public {
            require(msg.sender==manager);
            require(participants.length>2);
            uint r=random();
            uint index= r%participants.length;
            address payable winner;
            winner=participants[index];
            winner.transfer(getBalance());
            participants=new address payable[](0);

     }
}
