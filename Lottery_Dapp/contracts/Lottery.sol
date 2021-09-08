// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Lottery {
    
    struct BetInfo {
        uint256 answerBlockNumber;
        // 맞춘 사람에게 돈을 보내줘야 한다
        address payable better;
        bytes32 challenges;
    }

    address public owner;

    // 도메인 정의??
    uint256 private _tail;
    uint256 private _head;
    mapping (uint => BetInfo) private _bets;

    // 블록 개수 제한 = 256개
    uint256 constant internal BLOCK_LIMIT = 256;

    // Block 간격은 3개이다
    uint256 constant internal BET_BLOCK_INTERVAL = 3;

    // 0.005 ETH = 5 * 10 ** 15 WEI, 5 ETH = 5 * 10 ** 18 WEI
    uint256 constant internal BET_AMOUNT = 5 * 10 ** 15;

    // 팟머니 모아둘 공간 필요
    uint256 private _pot;
    
    // 가장 처음 배포가 되는 함수
    constructor() public {
        owner = msg.sender;
    }

    function getSomeValue() public pure returns (uint256 value) {
        return 5;
    }

    function getPot() public view returns (uint256 pot) {
        // _pot에 있는 돈을 better의 address에 전송
        // smart contract의 변수를 줘야 하는 수식어는 view가 들어가야 한다
        return _pot;
    }
}

// Dapp 설계 방법
// 1. 지갑 관리 - Hot Wallet & Cold Wallet
// 2. 아키텍쳐 a. smart contract - front (Data를 모두 s.c에 넣으면 유연하게 대처 X)
//           b. smart contract - server - front (중요도에 따라 DB를 나눠서 저장할 수 있다)
// 3. Code a. 코드 실행하는 데 돈이 든다 (디도스 공격 막을 수 있다)
//         b. 권한 관리
//         c. 비즈니스 로직 업데이트 (s.c의 단점 중 하나: 업데이트)
//         d. Data Migration
// 4. 운영 a. public - test.net -> main.net
//        b. private

