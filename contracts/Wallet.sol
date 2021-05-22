// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "./Allowance.sol";

contract Wallet is Allowance{
  
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function withdrawFunds(address payable _to, uint _amount) public ownerOrAllowed(_amount){
      require(address(this).balance >= _amount, "Contract has no liquidity");
      if(!isOwner()){
        reduceAllowance(msg.sender, _amount);
      }
      emit MoneySent(_to, _amount);
      _to.transfer(_amount);
    }


    receive() external payable {
       emit MoneyReceived(msg.sender, msg.value);
    }
}