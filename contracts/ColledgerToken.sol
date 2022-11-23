//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Colledger is ERC20{

    constructor() ERC20("Colledger","COL"){
        _mint(msg.sender,1000000000*10**18);
    }

    
}