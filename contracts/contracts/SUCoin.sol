// SPDX-License-Identifier: MIT
// Author: @yagizklc
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract SUCoin is ERC20, Ownable, ERC20Burnable {
    constructor() ERC20("SUCoin", "SUC") {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

}
