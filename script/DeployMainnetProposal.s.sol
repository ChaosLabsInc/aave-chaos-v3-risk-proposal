// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@forge-std/console.sol";
import {Script} from "@forge-std/Script.sol";
import {AaveGovernanceV2, IExecutorWithTimelock} from "@aave-address-book/AaveGovernanceV2.sol";

library DeployMainnetProposal {
    function _deployMainnetProposal(address payload, bytes32 ipfsHash) internal returns (uint256 proposalId) {
        require(payload != address(0), "ERROR: PAYLOAD can't be address(0)");
        require(ipfsHash != bytes32(0), "ERROR: IPFS_HASH can't be bytes32(0)");
        address[] memory targets = new address[](1);
        targets[0] = payload;
        uint256[] memory values = new uint256[](1);
        values[0] = 0;
        string[] memory signatures = new string[](1);
        signatures[0] = "execute()";
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = "";
        bool[] memory withDelegatecalls = new bool[](1);
        withDelegatecalls[0] = true;

        return
            AaveGovernanceV2.GOV.create(
                IExecutorWithTimelock(AaveGovernanceV2.SHORT_EXECUTOR),
                targets,
                values,
                signatures,
                calldatas,
                withDelegatecalls,
                ipfsHash
            );
    }
}

contract DeployProposal is Script {
    function run() external {
        vm.startBroadcast();
        DeployMainnetProposal._deployMainnetProposal(
            address(0x691B41805f7Ef2D7De6165bC42295b035a31600D), // TODO: replace with mainnet payload address
            bytes32(0x5d0543d0e66abc240eceeae5ada6240d4d6402c2ccfe5ad521824dc36be71c45) // TODO: replace with actual ipfshash
        );
        vm.stopBroadcast();
    }
}
