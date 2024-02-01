//SPDX-License-Identifier: MIT

pragma solidity >=0.8.17;

library Login {

    struct SignerLogin{
        address signer;
        bytes signature;
    }

    struct OrgLogin{
        address admin;
        string orgReg;
        bytes signature;
    }

    struct InsLogin{
        address admin;
        string insReg;
        bytes signature;
    }
}