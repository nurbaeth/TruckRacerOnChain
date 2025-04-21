// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract TruckRacerOnChain {
    struct Player {
        uint256 distance;
        uint256 fuel;
        uint256 cargo;
        bool isDriving;
    }

    mapping(address => Player) public players;

    uint256 public constant MAX_FUEL = 100;
    uint256 public constant FUEL_CONSUMPTION_PER_KM = 1;
    uint256 public constant MAX_CARGO = 50;
    uint256 public constant DELIVERY_DISTANCE = 100;

    event StartedDriving(address indexed player);
    event Drove(address indexed player, uint256 km, uint256 distanceLeft);
    event Refueled(address indexed player, uint256 amount);
    event Delivered(address indexed player);

    function startDriving() external {
        Player storage p = players[msg.sender];
        require(!p.isDriving, "Already driving");
        p.isDriving = true;
        p.fuel = MAX_FUEL;
        p.cargo = MAX_CARGO;
        p.distance = 0;
        emit StartedDriving(msg.sender);
    }

    function drive(uint256 km) external {
        Player storage p = players[msg.sender];
        require(p.isDriving, "Start driving first");
        require(p.fuel >= km * FUEL_CONSUMPTION_PER_KM, "Not enough fuel");

        p.fuel -= km * FUEL_CONSUMPTION_PER_KM;
        p.distance += km;

        if (p.distance >= DELIVERY_DISTANCE) {
            p.isDriving = false;
            emit Delivered(msg.sender);
        } else {
            emit Drove(msg.sender, km, DELIVERY_DISTANCE - p.distance);
        }
    }

    function refuel(uint256 amount) external {
        Player storage p = players[msg.sender];
        require(p.isDriving, "Start driving first");

        p.fuel += amount;
        if (p.fuel > MAX_FUEL) {
            p.fuel = MAX_FUEL;
        }

        emit Refueled(msg.sender, amount);
    }
}
