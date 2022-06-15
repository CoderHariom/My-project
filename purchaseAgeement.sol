// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <=0.9.0;

contract PurchaseAgreement{
uint public value;
address payable public seller;
address payable public buyer;

enum State {Created,Locked,Release,Inactive}
State public state;

constructor() payable{
    seller = payable(msg.sender);
    value = msg.value/2;
}

error invalidState();
error onlyBuyer();
error onlySeller();

modifier inState(State state_){
    if(state!=state_){
    revert invalidState();}
    _;
}

modifier OnlyBuyer(){
    if(msg.sender!=buyer){
     revert onlyBuyer();
    } 
    _;
}

modifier OnlySeller(){
    if(msg.sender!=seller){
     revert onlySeller();
    } 
    _;
}


function confirmPurchase() external inState(State.Created) payable{
    require(msg.value==(2*value),"please send the 2x purchase amount");
    buyer=payable(msg.sender);
    state=State.Locked;
}

function confirmReceived() external OnlyBuyer inState(State.Locked){
    state=State.Release;
    buyer.transfer(value);
}

function paySeller() external OnlySeller inState(State.Release){
    state=State.Inactive;
    seller.transfer(3*value);
}

function abort() external OnlySeller inState(State.Created){
    state=State.Inactive;
    seller.transfer(address(this).balance);
}


}