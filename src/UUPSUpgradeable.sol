pragma solidity ^0.8.20;

abstract contract UUPSUpgradeable {
    address private immutable self = address(this);

    function _authorize(address newImplementation) internal virtual;

    function upgradeTo(address newImplementation) internal virtual;

    function _upgradeTo(address newImplementation) private {
        require(newImplementation != address(0), "UUPSUpgradeable: new implementation is zero address");
        require(address(this) == self, "UUPSUpgradeable: must not be called through delegatecall");

        assembly {
            sstore(0x360894A13BA1A3210667C828492DB98DCA3E2076CC3735A920A3CA505D382BBC, newImplementation)
        }
    }
}