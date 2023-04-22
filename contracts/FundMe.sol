// SPDX-License-Identifier: MIT
// 1. Pragma
pragma solidity ^0.8.7;
// 2. Imports
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";


error FundMe__NotOwner();

/**
 *@title A contract for crowd funding
 *@author Salma Ahmed Ali
 *@notice This contract is to demo a sample funding contract
 *@dev This implements a price feeds as our library
 */
contract FundMe{
  //Const & immutable
  //constant variables are actually part of the contract's byte code itself
  //Not in storage ..it's just a pointer to its value and doesn't take up storage slot.

  //variables in functions don't get added to storage, get added in thier own memory data strucure and gets deleted after the function has finished running
  //Arrays & Mapping can take up a lot more space.

  //Gas is calculated by this opcodes
  //To see how much it costs for each one

      
    using PriceConverter for uint256;  //we're using it as a libirary on top of uint256 type 

    address[] private s_funders;
    mapping (address =>uint256) private s_addressToAmountFunded;  //getAddressToAmountFunded
    address private immutable i_owner;
    uint256 public constant MINIMUM_USD =50 * 1e18;
    AggregatorV3Interface private s_priceFeed;

    modifier onlyOwner{
      //require(msg.sender == i_owner, "Sender is not owner!");
      if(msg.sender!= i_owner){
        revert FundMe__NotOwner();
      }
      _;
      //underscore represent the rest of the code will call after this line
    }

    constructor(address priceFeedAddress){
      i_owner = msg.sender;
      s_priceFeed= AggregatorV3Interface(priceFeedAddress) ;
    }

    receive() external payable{
      fund();
    }
    
     fallback() external payable{
      fund();
    }

    
/**
 *@notice This function fund this contract
 *@dev This implements a price feeds as our library
 */

    function fund() public payable{
      //How do we send ETH to this contract?
      require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "Didn't send enough!");
      //18 decimal
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
      
      
    }

    function withDraw() public onlyOwner{
      for(uint256 funderIndex=0 ; funderIndex< s_funders.length ; funderIndex=funderIndex+1 ){
           address funder = s_funders[funderIndex];
           s_addressToAmountFunded [funder] =0;
      }

      //reset an array
      s_funders = new address[](0);

      // actually withdraw the funds through 3 waaays
      // trasfer
      //payable(msg.sender).trasfer(address(this).balance);
      //send 
      //bool sendSuccess = payable(msg.sender).send(address(this).balance);
      // require(sendSuccess, "Didn't send success!")
      //call

      // payable(msg.sender).transfer(address(this).balance);
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    function cheapWithdraw() public payable onlyOwner(){
      address [] memory funders = s_funders; //saved a storage value into a memory value, we can read and write from this memory var, much much cheaper and then update storage when you're done
      //mappings can't be in memory
      for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        // payable(msg.sender).transfer(address(this).balance);
        (bool success, ) = i_owner.call{value: address(this).balance}("");
        require(success);
    }

    function getOwner() public view returns (address){
      return i_owner;
    }

    function getFunder(uint256 index) public view returns(address){
      return s_funders[index];
    }

    function getAddressToAmountFunded(address funder) public view returns(uint256){
      return s_addressToAmountFunded[funder];
    }

    function getPriceFeed() public view returns (AggregatorV3Interface){
      return s_priceFeed;
    }
}