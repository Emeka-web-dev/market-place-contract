// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MarketPlace.sol";

contract MarketPlaceTest is Test {
    MarketPlace public marketplace;

    address public alice = address(0x1);
    address public bob = address(0x2);

    function setUp() public {
        marketplace = new MarketPlace();
    }

    function testListCar() public {
        vm.startPrank(alice);
        marketplace.listCar("Tesla Model S", 1 ether);
        MarketPlace.Car memory car = marketplace.showCar(1);

        assertEq(car.id, 1);
        assertEq(car.name, "Tesla Model S");
        assertEq(car.price, 1 ether);
        assertEq(car.owner, alice);
        assertEq(car.isForSale, true);

        // Verify NFT minted
        assertEq(marketplace.ownerOf(1), alice);
        vm.stopPrank();
    }

    function testBuyCar() public {
        vm.startPrank(alice);
        marketplace.listCar("Tesla Model S", 1 ether);
        vm.stopPrank();

        vm.startPrank(bob);
        vm.deal(bob, 2 ether); // Fund Bob with 2 ether
        marketplace.buyCar{value: 1 ether}(1);
        MarketPlace.Car memory car = marketplace.showCar(1);

        // Verify car ownership is transferred
        assertEq(car.owner, bob);
        assertEq(car.isForSale, false);

        // Verify NFT is transferred to Bob
        assertEq(marketplace.ownerOf(1), bob);

        // Verify Alice received the payment
        assertEq(alice.balance, 1 ether);
        vm.stopPrank();
    } 

    function testShowCars() public {
        // List multiple cars
        vm.startPrank(alice);
        marketplace.listCar("Tesla Model S", 1 ether);
        marketplace.listCar("Ford Mustang", 2 ether);
        marketplace.listCar("BMW X5", 3 ether);
        vm.stopPrank();

        // Fetch all cars
        MarketPlace.Car[] memory allCars = marketplace.showCars();

        // Verify the cars
        assertEq(allCars.length, 3);

        assertEq(allCars[0].id, 1);
        assertEq(allCars[0].name, "Tesla Model S");
        assertEq(allCars[0].price, 1 ether);
        assertEq(allCars[0].owner, alice);
        assertEq(allCars[0].isForSale, true);

        assertEq(allCars[1].id, 2);
        assertEq(allCars[1].name, "Ford Mustang");
        assertEq(allCars[1].price, 2 ether);
        assertEq(allCars[1].owner, alice);
        assertEq(allCars[1].isForSale, true);

        assertEq(allCars[2].id, 3);
        assertEq(allCars[2].name, "BMW X5");
        assertEq(allCars[2].price, 3 ether);
        assertEq(allCars[2].owner, alice);
        assertEq(allCars[2].isForSale, true);

    }
}