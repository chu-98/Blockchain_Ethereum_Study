import React, { Component } from "react";
import logo from "./logo.svg";
import "./App.css";

import Web3 from "web3";
import { render } from "@testing-library/react";

let contractAddress = "0xBEd9057334e0FbD37Ead3fa6ffF9c6E2286Bd1Ab";
class App extends Component {
  async componentDidMount() {
    await this.initWeb3();
    console.log(this.web3);
    let accounts = await this.web3.eth.getAccounts();
    console.log(accounts);
    let balance = await this.web3.eth.getBalance(accounts[0]);
    console.log(balance);
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
