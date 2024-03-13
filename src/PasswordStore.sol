// SPDX-License-Identifier: MIT
pragma solidity 0.8.18; // q is this a correct compiler ?

/*
 * @author not-so-secure-dev
 * @title PasswordStore
 * @notice This contract allows you to store a private password that others won't be able to see. 
 * You can update your password at any time.
 */
contract PasswordStore {
    error PasswordStore__NotOwner();

    address private s_owner;
    //  @audit s_password is not actually private, anybody can still read this variable on-chain, so its not safe to store password here!
    // all data on-chain is publicly accessible ( even a private state variables )
    string private s_password;

    event SetNetPassword();

    constructor() {
        s_owner = msg.sender;
    }

    /*
     * @notice This function allows only the owner to set a new password.
     * @param newPassword The new password to set.
     */

    // q should non-owner be able to set new password ?
    // @audit-high non-owner is able to set new password
    // the bug here is missing an access controls ( modifiier )
    function setPassword(string memory newPassword) external {
        s_password = newPassword;
        emit SetNetPassword();
    }

    /*
     * @notice This allows only the owner to retrieve the password.
     * @param newPassword The new password to set.
     */
    function getPassword() external view returns (string memory) {
        if (msg.sender != s_owner) {
            revert PasswordStore__NotOwner();
        }
        return s_password;
    }
}
