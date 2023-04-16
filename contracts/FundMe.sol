// SPDX-License-Identifier: MIT
// 1. Pragma
pragma solidity ^0.8.7;
// 2. Imports
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";


error NotOwner();

contract FundMe{
      using PriceConverter for uint256;  //we're using it as a libirary on top of uint256 type 
    uint256 public constant MINIMUM_USD =50 * 1e18;

    address[] public funders;
    mapping (address =>uint256) addressToAmountFunded;
    address public immutable i_owner;
    AggregatorV3Interface public priceFeed;

    constructor(address priceFeedAddress){
      i_owner = msg.sender;
      priceFeed= AggregatorV3Interface(priceFeedAddress) ;
    }

    function fund() public payable{
      //How do we send ETH to this contract?
      require(msg.value.getConversionRate(priceFeed) >= MINIMUM_USD, "Didn't send enough!");
      //18 decimal

      funders.push(msg.sender);
      addressToAmountFunded[msg.sender] += msg.value;
      
    }

    function withDraw() public onlyOwner{
      for(uint256 funderIndex=0 ; funderIndex< funders.length ; funderIndex=funderIndex+1 ){
           address funder = funders[funderIndex];
           addressToAmountFunded[funder] =0;
      }

      //reset an array
      funders = new address[](0);

      // actually withdraw the funds through 3 waaays
      // trasfer
      //payable(msg.sender).trasfer(address(this).balance);
      //send 
      //bool sendSuccess = payable(msg.sender).send(address(this).balance);
     // require(sendSuccess, "Didn't send success!")
      //call
       (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
      require(callSuccess, "Didn't call success!");
    }

    modifier onlyOwner{
      //require(msg.sender == i_owner, "Sender is not owner!");
      if(msg.sender!= i_owner){
        revert NotOwner();
      }
      _;
      //underscore represent the rest of the code will call after this line
    }

    receive() external payable{
      fund();
    }
    
     fallback() external payable{
      fund();
    }

}