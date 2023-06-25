// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

struct OG {
    address addr;
    uint256 claimed;
    uint256 registeredAt;
}

contract POG is ERC20 {
    mapping(address => OG) private ogs;
    uint256 private multipler = 1_000_000_000_000_000;
    uint256 public initialSupply = 1_000_000 ether;
    address private admin;

    constructor() ERC20("Proof of OG", "POG") {
        // initial supply
        _mint(msg.sender, initialSupply);
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    function register() public {
        require(ogs[msg.sender].registeredAt == 0, "Already registered");
        ogs[msg.sender].addr = msg.sender;
        ogs[msg.sender].registeredAt = block.timestamp;
        _mint(msg.sender, 1 ether);
    }

    function registerAdmin(address registrant) public {
        require(ogs[registrant].registeredAt == 0, "Already registered");
        ogs[registrant].addr = registrant;
        ogs[registrant].registeredAt = block.timestamp;
        _mint(registrant, 1 ether);
    }

    function claim() public {
        console.log("block.timestamp", block.timestamp);
        require(ogs[msg.sender].registeredAt > 0, "Not registered");
        uint256 claimed = ogs[msg.sender].claimed;
        uint256 claims = (block.timestamp -
            ogs[msg.sender].registeredAt -
            claimed);
        _mint(msg.sender, claims * multipler);
        ogs[msg.sender].claimed += claims;
    }
}
