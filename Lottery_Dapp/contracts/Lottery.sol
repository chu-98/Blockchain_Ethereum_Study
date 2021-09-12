// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Lottery {
    
    struct BetInfo {
        uint256 answerBlockNumber;
        // 맞춘 사람에게 돈을 보내줘야 한다
        address payable bettor;
        bytes32 challenges;
    }

    address public owner;

    // 도메인 설계!!
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

    enum BlockStatus{checkable, NotRevealed, BlockLimitPassed}
    enum BettingResult{Fail, Win, Draw}

    event BET(uint256 index, address bettor, uint256 amount, bytes32 challenges, uint256 answerBlockNumber);

    // 가장 처음 배포가 되는 함수
    constructor() public {
        owner = msg.sender;
    }

    function getPot() public view returns (uint256 pot) {
        // _pot에 있는 돈을 bettor의 address에 전송
        // smart contract의 변수를 줘야 하는 수식어는 view가 들어가야 한다
        return _pot;
    }

    // Bet

      // queue에서 bet 정보를 확인하고 돈이 제대로 들어왔는지도 확인
      // Save the bet to queue

    function bet(bytes32 challenges) internal returns (bool result) {
        // Check the proper ether is sent
        require(msg.value == BET_AMOUNT, "Not enough ETH");

        // Push bet to the queue
        require(pushBet(challenges), "Fail to add a new Bet Info");

        // Emit event
        emit BET(_tail - 1, msg.sender, msg.value, challenges, block.number + BET_BLOCK_INTERVAL);

        return true;
    }

    // Distribute
    function distribute() public {
        // head 3 4 5 6 7 8 9 10 11 12 tail - queue
        uint256 cur;
        BetInfo memory b;
        BlockStatus currentBlockStatus;

        for(cur=_head;cur<_tail;cur++) {
            b = _bets[cur];
            currentBlockStatus = getBlockStatus(b.answerBlockNumber);

            // 1. Checkable : block.number > answerBlockNumber && block.number < BLOCK_LIMIT + answerBlockNumber
            if(currentBlockStatus == BlockStatus.checkable) {
                // if win, bettor gets pot

                // if fail, bettor's money goes pot

                // if draw, refund bettor's money

            }

            // 2. Not Revealed : block.number <= answerBlockNumber
            if(currentBlockStatus == BlockStatus.NotRevealed) {
                break;
            }
            // 3. Block Limit Passed : block.number >= answerBlockNumber + BLOCK_LIMIT
            if(currentBlockStatus == BlockStatus.BlockLimitPassed) {
                // refund
                // emit refund
            }
            
            popBet(cur);
        }
    }

    /**
    * @dev 베팅글자와 정답을 확인한다
    * @param challenges 베팅 글자
    * @param answer 블럭 해쉬
    * @return 정답결과
     */
    function isMatch(bytes32 challenges, bytes32 answer) public pure returns (BettingResult) {
        // challenges 0xab
        // answer 0xab... ff 32 bytes

        bytes32 c1 = challenges;
        bytes32 c2 = challenges;

        bytes32 a1 = answer[0];
        bytes32 a2 = answer[0];

        // Get First Number
        c1 = c1 >> 4;
        c1 = c1 << 4;

        a1 = a1 >> 4;
        a1 = a1 << 4;

        // Get Second Number
        c2 = c2 >> 4;
        c2 = c2 << 4;

        a2 = a2 >> 4;
        a2 = a2 << 4;

        if(a1 == c1 && a2 == c2) {
            return BettingResult.Win;
        }

        if(a1 == c1 || a2 == c2) {
            return BettingResult.Draw;
        }

        return BettingResult.Fail;
    }

    function getBlockStatus(uint256 answerBlockNumber) internal view returns (BlockStatus) {
        if(block.number > answerBlockNumber && block.number < BLOCK_LIMIT + answerBlockNumber) {
            return BlockStatus.checkable;
        }

        if(block.number <= answerBlockNumber) {
            return BlockStatus.NotRevealed;
        }

        if(block.number >= answerBlockNumber + BLOCK_LIMIT) {
            return BlockStatus.BlockLimitPassed;
        }

        return BlockStatus.BlockLimitPassed;
    }
      // Check the answer
      // 맞으면 돈 다 주고 틀리면 돈 가져가는 판단 필요

    function getBetInfo(uint256 index) public view returns (uint256 answerBlockNumber, address bettor, bytes32 challenges) {
        BetInfo memory b = _bets[index];
        answerBlockNumber = b.answerBlockNumber;
        bettor = b.bettor;
        challenges = b.challenges;
    }

    function pushBet(bytes32 challenges) internal returns (bool) {
        BetInfo memory b;
        b.bettor = msg.sender;
        b.answerBlockNumber = block.number + BET_BLOCK_INTERVAL;
        b.challenges = challenges;

        _bets[_tail] = b;
        _tail++;

        return true;
    }

    function popBet(uint256 index) internal returns (bool) {
        // delete: 값을 초기화해서 Gas를 돌려받는다 = 데이터를 더이상 저장하지 않는다
        delete _bets[index];

        return true;
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

