// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256){
        //ABI
        (, int256 price,,,) = priceFeed.latestRoundData();
        //ETH in terms of USD
        //3000.00000000
        
        //Casting
        return uint256(price * 1e10); //1**10 = 10000000000
    }

    //to validate
    function getVersion() internal view returns (uint256){
        AggregatorV3Interface priceFeed =AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount,
     AggregatorV3Interface priceFeed) internal view returns (uint256){
        // we get price of ethereum
        uint256 ethPrice = getPrice(priceFeed );
        //
        uint256 ethAmountInUSD = (ethPrice*ethAmount) / 1e18;
        return ethAmountInUSD;

    }
}