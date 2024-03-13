### [S-#] Storing password on-chain (root cause) makes it visible to anyone (impact), and no longer safe/private 
 

**Description:** All data stored on-chain is visible to anyone, and can be read directly on the blockchain. The `PasswordStore::s_password` is intented to be private variable and intended to be accessible through the `PasswordStore::getPassword` function. which is intended tobe called only by the owner of the contract.

**Impact:** Anyone can ready the password on-chain, severely breaking the functionlity of the protocol.

<!-- here is where u prove to judges/protocol that ur findong is legit/real -->
**Proof of Concept:**

**Recommended Mitigation:** 