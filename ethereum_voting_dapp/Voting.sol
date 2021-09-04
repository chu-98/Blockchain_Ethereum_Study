// 어떤 컴파일 버전을 이 컨트랜트에 쓸까?
pragma solidity ^0.8.7;

// class가 아닌 contract를 쓴다는 점이 다릅니다
contract Voting {
    // constructor to initialize candidates

      // 후보자에 쓸 자료형이 bytes32라는 자료형입니다
      // bytes32를 쓰는 이유는 솔리디티가 아직 배열이나 string을 지원하지 않기 때문
      // public 이라고 적으면 외부에서 접근 가능
      // 컨트랙트가 한번 배포되고 나면 수정도 덮어쓰기도 안 되고 그냥 빼박.
    bytes32[] public candidateList;

      // 각 후보자에 대한 득표수를 저장할 방법 필요
      // 연관 배열, 해시 -> 솔리디티에서는 mapping(매핑) 이라고 한다
      // candidateList에 있는 후보자들의 득표수를 계속 추적하기 위한 작업
    mapping (bytes32 => uint8) public votesReceived;
    
    constructor(bytes32[] candidateNames) public {
        candidateList = candidateNames;
    }

    // vote for candidates

      // 투표 할 때마다 증가하는 함수 만들기
    function voteForCandidate(bytes32 candidate) public {
      votesReceived[candidate] += 1;
    }

      // 후보자가 받은 총 득표수 확인 함수
      // return은 후보자가 받은 득표수를 반환하는 것입니다
      // view 라는 modifier(지정자) 하나를 추가하면 읽기 전용 함수라고 표시할 수 있습니다
    function totalVotesFor(bytes32 candidate) view public returns(uint8) {
      return votesReceived[candidate];
    }


    // get count of votes for each candidates
}