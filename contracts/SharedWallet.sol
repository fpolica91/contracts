
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

// node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol

// /Users/fabriciopolicarpo/Desktop/Udemy/Blockchain/sharedWallet/node_modules/@openzeppelin/contracts/access/Ownable.sol







contract SharedWallet is Ownable{
  using SafeMath for uint;

  struct Balance{
    uint totalBalance;
  }
   event AllowanceChanged(address indexed _to, address indexed _from, uint _oldAmount, uint _newAmount);

  
  mapping(address => Balance) public userDepositedBalance;
  
  mapping(address => Balance) public userAllowance;
  
  function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }

  function depositFunds() public payable {
      require(msg.value > 0, "You cannot deposit 0 balance");
      userDepositedBalance[msg.sender].totalBalance = userDepositedBalance[msg.sender].totalBalance.add(msg.value);
  }
  
  function userWithdraws(address payable _to, uint _amount) public payable ownerOrAllowed(_amount){
      userDepositedBalance[msg.sender].totalBalance = userDepositedBalance[msg.sender].totalBalance.sub(_amount);
      _to.transfer(_amount);
        
  } 
  
  function addAllowance(address payable _to) public payable onlyOwner{
      require(msg.value > 0, "value must greater than 0");
      userAllowance[_to].totalBalance = userAllowance[_to].totalBalance.add(msg.value);
      emit AllowanceChanged(_to, msg.sender, userAllowance[_to].totalBalance, userAllowance[_to].totalBalance + msg.value);
  }
 

  
  modifier ownerOrAllowed(uint _amount){
      require(isOwner() || userAllowance[msg.sender].totalBalance >= _amount, "Funds not available");
      _;
  }
  
  
  function withdrawAllowance(address payable _to, uint _amount) public payable ownerOrAllowed(_amount){
      userAllowance[_to].totalBalance = userAllowance[_to].totalBalance.sub(_amount);
      _to.transfer(_amount);
      emit AllowanceChanged(_to, msg.sender, userAllowance[_to].totalBalance, userAllowance[_to].totalBalance - msg.value);
  }
  
  
 
  
  
  
  

}