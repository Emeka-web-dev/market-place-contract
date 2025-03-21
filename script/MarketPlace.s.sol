// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MarketPlace} from "../src/MarketPlace.sol";

contract MarketPlaceScript is Script {

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
         new MarketPlace();
        vm.stopBroadcast();
    }
}
