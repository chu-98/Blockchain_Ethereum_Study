// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

contract Vote {
    
    // structure
    struct candidator {
        string name;
        uint upVote;
    }
    
    // variable
    candidator[] public candidatorList;

    // mapping
    
    // event
    event AddCandidator(string name);
    
    // modifier
    
    // constructor
    
    // candidator
    // memory나 calldata를 넣어줘야만 하나???
    function addCandidator(string memory _name) public {
        candidatorList.push(candidator(_name, 0));

        // emit event
        emit AddCandidator(_name);
    }
    
    // voting
    function Voting() public {
        
    }
    
    // finish Vote
    function finishVote() public {
        
    }
}