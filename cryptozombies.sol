// SPDX-License-Identifier: UNLICENSED
// 1. 여기에 솔리디티 버전 적기
// 솔리디티 버전을 선언하고 이후에 새로운 컴파일러 버전이 나와도 기존 코드가 깨지지 않도록 예방
pragma solidity ^0.8.6;

// 2. 여기에 컨트랙트 생성
contract ZombieFactory {

    // 13. 이벤트
    event NewZombie(uint zombieId, string name, uint dna);

    // 3. 상태 변수 : 컨트랙트 저장소에 영구적으로 저장된다. 
    // 즉, 이더리움 블록체인에 기록된다는 것. 데이터베이스에 데이터를 쓰는 것과 동일.
    // uint : 부호 없는 정수, 즉 값이 음수가 아니어야 한다는 의미. / int : 부호 있는 정수
    // uint = uint256, 즉 256비트 부호 없는 정수의 다른 표현
    uint dnaDigits = 16;

    // 4. 수학 연산) +, -, *, /, %(모듈), **(지수)
    uint dnaModulus = 10 ** dnaDigits;

    // 5. 구조체) struct를 통해 여러 특성을 가진, 보다 복잡한 자료형을 생성할 수 있다 / 끝에 ; 안 붙이네?
    // string : 임의의 길이를 가진 UTF-8 데이터를 위해 활용된다 ex) string greeting = "Hello world!"
    struct Zombie {
        string name;
        uint dna;
    }

    // 6. 배열) 어떤 것의 모음집이 필요할 때 + _정적_ & _동적_ 배열이라는 두 종류
    // 정적 배열 : 2개의 원소를 담을 수 있는 고정 길이의 배열: uint[2] fixedArray; / 또다른 고정 배열로 5개의 스트링을 담을 수 있다: string[5] stringArray;
    // 동적 배열 : 고정된 크기가 없으며 계속 크기가 커질 수 있다: uint[] dynamicArray;
    // public으로 배열을 선언할 수 있는데 이를 위해 getter 메소드를 자동적으로 생성한다
    // public을 쓰게 되면 다른 컨트랙트들이 이 배열을 읽을 수 있게 된다(쓸 수는 없다) -> 공개 데이터를 저장할 때 유용
    // Zombie 구조체의 public 배열을 생성하고 이름을 zombies로 한다
    Zombie[] public zombies;

    // 7. 함수 선언) 함수 인자명을 언더바(_)로 시작해서 전역 변수와 구별하는 것이 관례
    // 끝에 ; 안 붙이네?
    function _createZombie(string _name, uint _dna) private {
        // 8. 구조체와 배열 활용하기
        // array.push() 구조는 무언가를 배열의 끝에 추가해서 모든 원소가 순서를 유지하도록 한다
        zombies.push(Zombie(_name, _dna));
        uint zombieId = zombies.push().length - 1;
        NewZombie(zombieId, name, dna)

        // 9. Private / Public 함수
        // 솔리디티에서 함수는 기본적으로 public으로 선언
        // 우리 컨트랙트를 공격에 취약하게 만들 수 있으므로 함수를 기본적으로 private으로 선언하고, 공개할 함수만 public으로 선언
        // private는 컨트랙트 내의 다른 함수들만이 이 함수를 호출하여 어떤 기능을 할 수 있다는 것을 의미
        // 관례상 private 함수명도 함수 인자명과 마찬가지로 언더바(_)로 시작한다
    }

    // 10. 함수 더 알아보기) return: 반환값, view: 데이터를 보기만 하고 변경하지 않는다, pure: 어떤 데이터도 접근하지 않는 것
    function _generateRandomDna(string _str) private view returns (uint) {

        // 11. Keccak256과 형 변환
        // 이더리움은 SHA3의 한 버전인 keccak256를 내장 해시 함수로 가지고 있다
        // 해시 함수는 기본적으로 입력 스트링을 랜덤 256비트 16진수로 mapping
        // 형 변환 - uint8 c = a * b 일 때, a와 b 모두 uint8이어야 한다
        uint rand = uint(keccak256(_str));
        // 위의 함수에서 returns (uint)라고 적어놨기에 return 뒤에 오는 부분이 uint인 것을 알 수 있다
        return rand % dnaModulus;
    }

    // 12. 종합하기
    function createRandomZombie(string _name) public {
        // _generateRandomDna 라는 함수의 반환값이 uint randDna로 전달!
        uint randDna = _generateRandomDna(_name);

        _createZombie(_name, randDna);
    }

}