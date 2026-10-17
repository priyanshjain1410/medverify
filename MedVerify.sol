// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MedVerify - fake-medicine batch verification
/// @notice Regulator authorises manufacturers; manufacturers register/recall batches; anyone verifies.
contract MedVerify {
    address public regulator;
    uint256 public totalBatches;

    struct Batch {
        string drugName;
        address manufacturer;
        uint256 expiry;   // unix timestamp
        bool recalled;
        bool exists;
    }

    mapping(address => bool) public isManufacturer;
    mapping(string => Batch) private batches;

    event ManufacturerAuthorised(address indexed manufacturer);
    event BatchRegistered(string batchId, string drugName, address indexed manufacturer, uint256 expiry);
    event BatchRecalled(string batchId, address indexed by);

    modifier onlyRegulator() {
        require(msg.sender == regulator, "Only regulator");
        _;
    }

    modifier onlyManufacturer() {
        require(isManufacturer[msg.sender], "Not an authorised manufacturer");
        _;
    }

    constructor() {
        regulator = msg.sender;
    }

    function authoriseManufacturer(address m) external onlyRegulator {
        require(m != address(0), "Zero address");
        require(!isManufacturer[m], "Already authorised");
        isManufacturer[m] = true;
        emit ManufacturerAuthorised(m);
    }

    function registerBatch(string calldata batchId, string calldata drugName, uint256 expiry)
        external onlyManufacturer
    {
        require(bytes(batchId).length > 0 && bytes(drugName).length > 0, "Empty input");
        require(!batches[batchId].exists, "Batch ID already exists");
        require(expiry > block.timestamp, "Expiry must be in the future");
        batches[batchId] = Batch(drugName, msg.sender, expiry, false, true);
        totalBatches++;
        emit BatchRegistered(batchId, drugName, msg.sender, expiry);
    }

    function recallBatch(string calldata batchId) external {
        Batch storage b = batches[batchId];
        require(b.exists, "Batch not found");
        require(msg.sender == b.manufacturer || msg.sender == regulator, "Not allowed to recall");
        require(!b.recalled, "Already recalled");
        b.recalled = true;
        emit BatchRecalled(batchId, msg.sender);
    }

    /// @return status 0 = not found (possible counterfeit), 1 = genuine, 2 = expired, 3 = recalled
    function verifyBatch(string calldata batchId)
        external view
        returns (uint8 status, string memory drugName, address manufacturer, uint256 expiry)
    {
        Batch storage b = batches[batchId];
        if (!b.exists) return (0, "", address(0), 0);
        uint8 s = b.recalled ? 3 : (block.timestamp > b.expiry ? 2 : 1);
        return (s, b.drugName, b.manufacturer, b.expiry);
    }
}
