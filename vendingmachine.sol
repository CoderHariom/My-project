//SPDX-License-Identifier:UNLINCENCE
pragma solidity >=0.5.0 <0.9.0;

contract vandingmachine
{
    address public owner;
    mapping (address=>uint) public donutBalance;
    
    constructor()
    {
        owner =msg.sender;
        donutBalance[address(this)]=100;
    }

    function getVendingmachineBalance() public view returns(uint)
    {
        return donutBalance[address(this)];
    }

    function restock(uint amount) public{
        require(msg.sender==owner,"only the owner restock this machine");
        donutBalance[address(this)] +=amount;
    }

    function purchase(uint amount) public payable
    {
        require(msg.value >= amount*2 ether,"you must pay at least 2 ether per donut");
        require(donutBalance[address(this)] >=amount ," not enough donut in stock");
        donutBalance[address(this)] -=amount;
        donutBalance[msg.sender] +=amount;
    }
}