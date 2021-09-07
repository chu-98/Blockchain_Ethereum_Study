// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Lottery {

    address public owner;

    // 가장 처음 배포가 되는 함수
    constructor() public {
        owner = msg.sender;
    }

    function getSomeValue() public pure returns (uint256 value) {
        return 5;
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