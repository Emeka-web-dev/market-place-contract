// filepath: /marketplace-project/marketplace-project/contracts/MarketPlace.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract MarketPlace is ERC721 {    
    uint256 private _carId;
    struct Car {
        uint256 id;
        string name;
        uint256 price;
        address owner;
        bool isForSale;
    }

    mapping(uint256 => Car) public cars;

    event CarListed(uint256 indexed carId, string name, uint256 price, address indexed owner);
    event CarSold(uint256 indexed carId, address indexed buyer);
    event BidPlaced(uint256 indexed carId, address indexed bidder, uint256 amount);

    constructor() ERC721("CarNFT", "CARNFT") {}

    function listCar(string memory name, uint256 price) public {
        _carId++;
        uint256 carId = _carId;
        
        cars[carId] = Car(carId, name, price, msg.sender, true);
        emit CarListed(carId, name, price, msg.sender);
    }

    function buyCar(uint256 carId) public payable {
        Car storage car = cars[carId];
        require(car.isForSale, "Car is not for sale");
        require(msg.value >= car.price, "Insufficient funds");

        car.owner = msg.sender;
        car.isForSale = false;

        _mint(msg.sender, carId);
        emit CarSold(carId, msg.sender);
    }

    function showCar(uint256 carId) public view returns (Car memory) {
        Car storage car = cars[carId];
        return car;
    }

    function showCars() public view returns (Car[] memory) {
        Car[] memory allCars = new Car[](_carId);
        for (uint256 i = 1; i <= _carId; i++) {
            allCars[i - 1] = cars[i];
        }
        return allCars;
    }    
}