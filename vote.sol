// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

abstract contract Vote {
    
    // structure
    struct candidator {
        string name;
        uint upVote;
    }
    
    // variable
    bool live;
    address owner;
    candidator[] public candidatorList;

    // mapping
    mapping(address => bool) Voted;
    
    // event
    event AddCandidator(string name);
    event UpVote(string candidator, uint upVote );
    event FinishVote(bool live);
    event Voting(address owner);
    
    // modifier
    modifier onlyOwner {
        require(msg.sender == owner);
        // 전체 실행??
        _;
    }
    
    // constructor
    // 초기값 설정 느낌??
    constructor() {
        owner = msg.sender;
        live = true;

        emit Voting(owner);
    }
    
    // candidator
    // memory나 calldata를 넣어줘야만 하나???
    function addCandidator(string memory _name) public onlyOwner{
        require(live == true);
        require(candidatorList.length < 5);

        candidatorList.push(candidator(_name, 0));

        // emit event
        emit AddCandidator(_name);
    }
    
    // voting
    function upVote(uint _indexOfCandidator) public {
        require(live == true);
        require(_indexOfCandidator < candidatorList.length);
        require(Voted[msg.sender] == false);
        
        candidatorList[_indexOfCandidator].upVote++;

        Voted[msg.sender] = true;

        emit UpVote(candidatorList[_indexOfCandidator].name, candidatorList[_indexOfCandidator].upVote);
    }
    
    // finish Vote
    // public 이라는 말이 주인 말고도 다른 사람도 조작이 가능하나 라는 의미?
    function finishVote() public onlyOwner{
        live = false;

        emit FinishVote(live);
    }
}

