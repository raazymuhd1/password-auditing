### [S-#] Storing password on-chain (root cause) makes it visible to anyone (impact), and no longer safe/private 
 

**Description:** All data stored on-chain is visible to anyone, and can be read directly on the blockchain. The `PasswordStore::s_password` is intented to be private variable and intended to be accessible through the `PasswordStore::getPassword` function. which is intended tobe called only by the owner of the contract.

**Impact:** Anyone can read the password on-chain, severely breaking the functionlity of the protocol.

<!-- here is where u prove to judges/protocol that ur findong is legit/real -->
**Proof of Concept:**
The below test case shows how anyone could read the password directly from the
blockchain. We use foundry’s cast tool to read directly from the storage of the contract, without being
the owner.

1. Create a locally running chain
```shell
  make anvil
```

2. Deploy the contract to the chain
```shell
  make deploy
```

3. Run the storage tool
```shell
  cast storage <ADDRESS_HERE> 1 --rpc-url http://127.0.0.1:8545 
```

You’ll get an output that looks like this:
`0x6d7950617373776f726400000000000000000000000000000000000000000014`

You can then parse that hex to a string with:
```shell
 cast parse-bytes32-string 0
x6d7950617373776f726400000000000000000000000000000000000000000014
```

And get an output of:
```shell
 myPassword
```

**Recommended Mitigation:** : Due to this, the overall architecture of the contract should be rethought.
One could encrypt the password off-chain, and then store the encrypted password on-chain. This
would require the user to remember another password on-chain to decrypt the password. However,
you’d also likely want to remove the view function as you wouldn’t want the user to accidentally send
a transaction with the password that decrypts your password.


### [S-#] `PasswordStore::setPassword` function has no access control, meaning anyone could change the password anytime.

**Description:** `PasswordStore::setPassword` function is set tobe an external function, however, the natspec of this function and overall purpose of smart contract is that `only allows owner to set a new password`
```solidity
   function setPassword(string memory newPassword) external {
    // @> @audit there are no access control here
        s_password = newPassword;
        emit SetNetPassword();
    }
```

**Impact:** Anyone can set a new password, severely breaking the contract intended functionality

**Proof of Concept:** Add the following on the `PasswordStore.t.sol` file.

```solidity
  function test_anyone_can_store_password(address randomAddress) public {
        vm.assume(randomAddress != owner);
        vm.prank(randomAddress);
        passwordStore.setPassword("newPass");

        vm.prank(owner);
        string memory actualPass = passwordStore.getPassword();

        console.log(actualPass);

        assertEq(actualPass, "newPass");
    }
```

**Recommended Mitigation:** Add an access control to `setPassword` function.

```solidity
  if(msg.sender != s_owner) revert PasswordStore_NotOwner;

```