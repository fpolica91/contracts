// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract Allowance is Ownable{
  using SafeMath for uint;
  mapping(address => uint) public allowance;

 event AllowanceChanged(address indexed _to, address indexed _from, uint _currentAmount, uint _amount);

  function isOwner() internal view returns(bool){ 
     return  owner() == msg.sender;
  }

  modifier ownerOrAllowed(uint _amount) {
    require(isOwner() || allowance[msg.sender] >= _amount, "you are not the owner, or don't have the allowance");
    _;
  }

  function setAllowance(address _to, uint _amount) public onlyOwner {
      uint currentAmount = allowance[_to];
      allowance[_to] = allowance[_to].add(_amount);
      emit AllowanceChanged(_to, msg.sender, currentAmount, _amount);
  }

  function reduceAllowance(address _to, uint _amount) internal ownerOrAllowed(_amount){
    uint currentAmount = allowance[_to];
    allowance[_to] = allowance[_to].sub(_amount);
     emit AllowanceChanged(_to, msg.sender, currentAmount, _amount);
  }

}
// contract.sendTransaction({from: accounts[1], value: web3.utils.toWei("1", 'ether')})