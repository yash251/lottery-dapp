//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{

    address public manager;
    address payable[] public players;
    
    constructor(){
        manager = msg.sender;
    }

    receive () payable external{           // receive() is a special type of function which can used only once and is always declared external
        require(msg.value == 0.1 ether);
        players.push(payable(msg.sender));  // used to register the players
    }

    function getBalance() public view returns(uint){  // can be used only by the manager to check the contract balance
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() internal view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }


    function pickWinner() public{

        require(msg.sender == manager);
        require (players.length >= 3);

        uint r = random();
        address payable winner;


        uint index = r % players.length;

        winner = players[index];

        winner.transfer(getBalance());


        players = new address payable[](0);  // resetting the array once a round is completed
    }

}