// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Escrow
 * @dev Securely holds funds between a buyer and seller with an arbitrator.
 */
contract Escrow {
    enum State { AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE, DISPUTED }

    address public buyer;
    address payable public seller;
    address public arbitrator;
    State public currState;
    uint256 public amount;

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can call this");
        _;
    }

    modifier onlyArbitrator() {
        require(msg.sender == arbitrator, "Only arbitrator can call this");
        _;
    }

    constructor(address _buyer, address payable _seller, address _arbitrator) {
        buyer = _buyer;
        seller = _seller;
        arbitrator = _arbitrator;
        currState = State.AWAITING_PAYMENT;
    }

    /**
     * @dev Buyer deposits funds into the escrow.
     */
    function deposit() external payable onlyBuyer {
        require(currState == State.AWAITING_PAYMENT, "Already paid");
        require(msg.value > 0, "Must send ETH");
        amount = msg.value;
        currState = State.AWAITING_DELIVERY;
    }

    /**
     * @dev Buyer confirms delivery and releases funds to the seller.
     */
    function confirmDelivery() external onlyBuyer {
        require(currState == State.AWAITING_DELIVERY, "Cannot confirm now");
        currState = State.COMPLETE;
        seller.transfer(address(this).balance);
    }

    /**
     * @dev Either party can flag a dispute if conditions aren't met.
     */
    function initiateDispute() external {
        require(msg.sender == buyer || msg.sender == seller, "Not authorized");
        require(currState == State.AWAITING_DELIVERY, "No active transaction");
        currState = State.DISPUTED;
    }

    /**
     * @dev Arbitrator resolves the dispute.
     * @param _paySeller If true, funds go to seller. If false, refunded to buyer.
     */
    function resolveDispute(bool _paySeller) external onlyArbitrator {
        require(currState == State.DISPUTED, "Not in dispute");
        currState = State.COMPLETE;
        if (_paySeller) {
            seller.transfer(address(this).balance);
        } else {
            payable(buyer).transfer(address(this).balance);
        }
    }
}
