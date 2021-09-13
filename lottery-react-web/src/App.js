import React, { Component } from "react";
import logo from "./logo.svg";
import "./App.css";

import Web3 from "web3";
import { render } from "@testing-library/react";

let contractAddress = "0xBEd9057334e0FbD37Ead3fa6ffF9c6E2286Bd1Ab";
let contractABI = [
  {
    inputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "index",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address",
        name: "bettor",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "bytes32",
        name: "challenges",
        type: "bytes32",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "answerBlockNumber",
        type: "uint256",
      },
    ],
    name: "BET",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "index",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address",
        name: "bettor",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "bytes32",
        name: "challenges",
        type: "bytes32",
      },
      {
        indexed: false,
        internalType: "bytes32",
        name: "answer",
        type: "bytes32",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "answerBlockNumber",
        type: "uint256",
      },
    ],
    name: "DRAW",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "index",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address",
        name: "bettor",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "bytes32",
        name: "challenges",
        type: "bytes32",
      },
      {
        indexed: false,
        internalType: "bytes32",
        name: "answer",
        type: "bytes32",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "answerBlockNumber",
        type: "uint256",
      },
    ],
    name: "FAIL",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "index",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address",
        name: "bettor",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "bytes32",
        name: "challenges",
        type: "bytes32",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "answerBlockNumber",
        type: "uint256",
      },
    ],
    name: "REFUND",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "index",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address",
        name: "bettor",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "bytes32",
        name: "challenges",
        type: "bytes32",
      },
      {
        indexed: false,
        internalType: "bytes32",
        name: "answer",
        type: "bytes32",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "answerBlockNumber",
        type: "uint256",
      },
    ],
    name: "WIN",
    type: "event",
  },
  {
    constant: true,
    inputs: [],
    name: "answerForTest",
    outputs: [{ internalType: "bytes32", name: "", type: "bytes32" }],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [],
    name: "owner",
    outputs: [{ internalType: "address payable", name: "", type: "address" }],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: true,
    inputs: [],
    name: "getPot",
    outputs: [{ internalType: "uint256", name: "pot", type: "uint256" }],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: false,
    inputs: [],
    name: "distribute",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: false,
    inputs: [{ internalType: "bytes32", name: "answer", type: "bytes32" }],
    name: "setAnswerForTest",
    outputs: [{ internalType: "bool", name: "result", type: "bool" }],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      { internalType: "bytes32", name: "challenges", type: "bytes32" },
      { internalType: "bytes32", name: "answer", type: "bytes32" },
    ],
    name: "isMatch",
    outputs: [
      { internalType: "enum Lottery.BettingResult", name: "", type: "uint8" },
    ],
    payable: false,
    stateMutability: "pure",
    type: "function",
  },
  {
    constant: true,
    inputs: [{ internalType: "uint256", name: "index", type: "uint256" }],
    name: "getBetInfo",
    outputs: [
      { internalType: "uint256", name: "answerBlockNumber", type: "uint256" },
      { internalType: "address", name: "bettor", type: "address" },
      { internalType: "bytes32", name: "challenges", type: "bytes32" },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
];

class App extends Component {
  async componentDidMount() {
    await this.initWeb3();
    await this.getBetEvent();
  }

  initWeb3 = async () => {
    if (window.ethereum) {
      console.log("Recent mode");
      this.web3 = new Web3(window.ethereum);
      try {
        // Request account access if needed
        await window.ethereum.enable();
        // Accounts now exposed
        // this.web3.eth.sendTransaction({/* ... */});
      } catch (error) {
        // User denined account access...
        console.log(`User denined account access error : ${error}`);
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      console.log("legacy mode");
      this.web3 = new Web3(Web3.currentProvider);
      // Accounts always exposed
      // web3.eth.sendTransaction({/* ... */});
    }
    // Non-dapp browsers...
    else {
      console.log(
        "Non-Ethereum browser detected. You should consider trying MetaMask!"
      );
    }

    let accounts = await this.web3.eth.getAccounts();
    this.accounts = accounts[0];

    this.lotteryContract = new this.web3.eth.Contract(
      lotteryABI,
      lotteryAddress
    );

    // call : Smart Contract에서 상태를 변화시키지 않고 값만 불러온다
    // let pot = await this.lotteryContract.methods.getPot().call();
    // console.log(pot);

    // let owner = await this.lotteryContract.methods.owner().call();
    // console.log(owner);

    getBetEvent = async () => {
      const records = [];
      let events = await this.lotteryContract.getPastEvents("BET", {
        fromBlock: 0,
        toBlock: "lastest",
      });
      console.log(events);
    };

    bet = async () => {
      // nonce - 외부의 유저가 마음대로 사용할 수 없게끔
      let nonce = await this.web3.eth.getTransactionCount(this.account);
      this.lotteryContract.methods.betAndDistribute("0xcd").send({
        from: this.accounts,
        value: 5000000000000000,
        gas: 300000,
        nonce: nonce,
      });
    };
  };
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <p>
            Edit <code>src/App.js</code> and save to reload.
          </p>
          <a
            className="App-link"
            href="https://reactjs.org"
            target="_blank"
            rel="noopener noreferrer"
          >
            Learn React
          </a>
        </header>
      </div>
    );
  }
}

export default App;

// Dapp 데이터 관리
// 'Read'
// - Smart Contract 직접 Call (EVM을 왔다갔다 계속 거치기에 느리다) (batch read call - 크게 read?)
// - event log 읽는 방법 (index로 특정할 수 있으며 빠르게 데이터 가져올 수 있다)
//   - http(polling)
//   - websocket
//     1. init와 동시에 past event 가져온다
//     2. websocket으로 geth 또는 infura와 연결
//     3. websocket으로 원하는 이벤트 subscribe (ws 사용하지 않으면, 롱 폴링 - 3초마다 묻기)
//     4. 주의) 돈이 크게 걸려있는 서비스 -> block confirm 확인 (최소 20 컨펌 정도가 안전하고 그때 front)
