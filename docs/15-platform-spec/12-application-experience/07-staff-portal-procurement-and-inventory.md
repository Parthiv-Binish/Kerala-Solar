# Staff Portal — Suppliers, Procurement, Purchase Orders & Inventory

**Document ID:** UX-STAFF-007 · **Status:** Proposed

## 1. Purpose
Manage supplier relationships, purchase requests, approvals, orders, receipts, stock locations, reservations, issues, returns and traceability. A BOM is a design estimate; it is not a purchase order or stock movement.

## 2. Navigation
Supply → Suppliers, Supplier Offers, Purchase Requests, Approval Queue, Purchase Orders, Goods Receipts, Inventory, Stock Movements, Reservations, Returns, Reorder/Shortage Report and Catalogue.

## 3. Supplier directory
Supplier record: legal/trading name, contacts, addresses, tax identifiers (restricted), categories, payment terms, bank/payment details (highly restricted), verification status, documents, active state and review date. Supplier offers link a catalogue product to supplier SKU, quoted price, currency, validity, lead time, minimum order and source document. Price history is immutable.

## 4. Purchase request
Created from approved project BOM, reorder need or authorised manual request. Fields: request reference, project, requested by, required-by date, delivery location, line items, quantities, preferred supplier (optional), justification, attachments and priority. Validation checks active product, positive quantity, unit, project need and duplicate open request.

## 5. Approval and purchase order
Approval policy uses amount, category, project and role thresholds. Requester self-approval is controlled by policy. Purchase order captures supplier, bill-to/ship-to, item snapshots, quantities, unit price, tax treatment, delivery terms, expected date, payment terms and approved document. Issued PO is versioned; changes require amendment and supplier communication record.

## 6. Goods receipt
Receive against PO. Capture received quantity, accepted/rejected quantity, batch/lot, serials where applicable, condition, photos/documents, receiver, date and discrepancy. Partial receipts are supported. Receipt does not automatically imply supplier invoice approval or payment.

## 7. Inventory model
Track product, stock location, quantity on hand, reserved, allocated, available, damaged/quarantined and in-transit. Every movement is a ledger event: receipt, transfer, reservation, release, issue, return, adjustment or write-off. Never directly edit balances without a traceable movement and reason.

## 8. Reservation and issue
Project reservation is a commitment, not physical issue. Issue records recipient, project/job, quantity, serial/batch and acknowledgement. Prevent negative available stock unless an explicit authorised exception exists. Serialized equipment must retain serial-to-project/plant traceability.

## 9. Returns and adjustments
Return reasons: unused, damaged, warranty return, wrong item or supplier return. Quarantine damaged/unknown goods. Stock adjustment requires reason, evidence and elevated permission. Corrections use compensating movements; do not delete history.

## 10. Data movement
Reads: product catalogue, BOM, project, supplier offers, stock ledger, locations, approval policy. Writes: supplier, offers, purchase requests, approvals, PO versions, receipts, inventory movements, reservations, issues, returns and audit. Financial liabilities are handled by finance workflow after matching evidence.

## 11. Permissions
supplier.view/manage; purchase_request.create/approve; purchase_order.create/approve/issue/amend; goods_receipt.record; inventory.view/transfer/adjust; stock.reserve/issue/return; cost.view; supplier_bank.view. Separate commercial and bank-detail access.

## 12. Exceptions and notifications
Handle supplier inactive, expired offer, price change, partial delivery, damaged goods, PO mismatch, duplicate receipt, serial conflict, stock discrepancy and cancellation after receipt. Notify approvers, buyers, project owner and storekeeper on relevant state changes.

## 13. Acceptance tests
- [ ] BOM cannot silently become an issued PO.
- [ ] PO issue requires approval.
- [ ] Partial receipt updates received balance accurately.
- [ ] Serial numbers cannot be assigned twice where uniqueness is required.
- [ ] Stock balance derives from movements.
- [ ] Reservations and issues are distinct.
- [ ] Damaged stock is unavailable for normal allocation.
- [ ] Historical supplier prices and PO versions remain unchanged.

## 14. Decisions
Confirm store locations, approval thresholds, stock costing method, unit conventions, supplier verification, serialised categories, receiving process and stock adjustment authority.
