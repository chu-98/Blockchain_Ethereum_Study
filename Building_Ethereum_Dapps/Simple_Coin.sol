pragma solidity ^0.8.7;

contract SimpleCoin {
    // 상태 변수를 주소와 정수 사이의 '매핑'으로 정의
    // address = 20바이트
    mapping (address => uint256) public coinBalance;

    // 새 컨트랙트가 생성될 때 10,000 SimpleCoin 토큰을 코인 계정 주소에 할당
    constructor() public {
        coinBalance[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = 10000;
    }

    function transfer(address _to, uint256 _amount) public {
        coinBalance[msg.sender] = _amount;
        coinBalance[_to] += _amount;
    }

}
