//SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.7;

// import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";
import "@opengsn/contracts/src/ERC2771Recipient.sol";

contract SwapToken is ERC2771Recipient {

    mapping(address => uint256) internal userAmounts;

    constructor(address _forwarder) {
        
        _setTrustedForwarder(_forwarder);
        
    }

    fallback() external payable {}

    function setTrustedForwarder(address _forwarder) external {
        require(_forwarder != address(0),"ZA");
        _setTrustedForwarder(_forwarder);
    }

    uint meraVariable;

    function setVariable(uint _newValue) public {
          meraVariable = _newValue;
    }

    
}
