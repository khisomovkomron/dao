pragma solidity ^0.8.20;

contract Proxy {
    address public implementation;

    constructor(address _implementation) {
        implementation = _implementation;
    }

    function ugradeTo(address newImplementation) public {
        require(msg.sender == admin(), "Proxy: Only admin can upgrade");
        implementation = newImplementation;
    }

    function admin() public view returns (address) {
        bytes32 position = keccak256("proxy.admin");
        address adminAddress;
        assembly {
            adminAddress := sload(position)
        }

        return adminAddress;
    }

    function setAdmin(address newAdmin) public {
        require(msg.sender == admin(),"Proxy: only admin can set new admin");
        bytes32 position = keccak256("proxy.admin");
        assembly {
            sstore(position, newAdmin)
        }
    }

    fallback() external payable {
        address impl = implementation;
        require(impl != address(0), "implementation contract not set");
        
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())

            let result := delegatecall(gas(), impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()

            returndatacopy(ptr, 0, size)

            switch result 
            case 0 {revert(ptr, size)}
            default {return(ptr, size)}
        }
    }

    receive() external payable {}
}