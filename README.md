# On-Chain Escrow Service

This repository provides a secure way to conduct peer-to-peer transactions without requiring immediate trust between the buyer and the seller. The contract acts as a neutral third party that holds funds in safety.

### Workflow
1. **Deposit:** The buyer sends funds to the contract, locking them for a specific seller.
2. **Delivery:** The seller provides the service or product.
3. **Release:** The buyer confirms receipt and releases the funds to the seller.
4. **Dispute:** If a conflict arises, a designated arbitrator can decide whether to refund the buyer or pay the seller.

### Key Security Features
* **State Management:** Strict transitions between `AWAITING_PAYMENT`, `AWAITING_DELIVERY`, and `COMPLETE`.
* **Arbitration:** A built-in mechanism to resolve deadlocks through a trusted third party.
* **Pull-Pattern:** Funds are pushed to the contract and pulled by the recipient to prevent security vulnerabilities.
