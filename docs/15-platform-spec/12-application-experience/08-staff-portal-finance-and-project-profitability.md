# Staff Portal — Finance, Receipts, Payments, Expenses & Project Profitability

**Document ID:** UX-STAFF-008 · **Status:** Proposed; finance/tax review required

## 1. Purpose and scope
Provide operational finance visibility for customers, projects, receipts, supplier payments and expenses. This is not automatically a statutory accounting, GST filing, payroll or tax-return system. Those require separate scope and professional review.

## 2. Navigation
Finance → Overview, Customer Receipts, Payment Allocations, Supplier Bills, Supplier Payments, Project Expenses, Refunds, Reconciliation, Project Financial Summary, Approvals and Reports.

## 3. Customer receipt
Record receipt only after funds are actually confirmed. Fields: receipt reference, customer, project, amount, currency, date/time, payment mode, bank/UPI reference (restricted), received by, evidence and allocation. Staff confirmation is not a payment gateway transaction. A UPI QR display or customer screenshot alone is not proof of settlement; follow the organisation's verification procedure.

## 4. Allocation and balance
A receipt may be allocated across approved invoices/milestones according to policy. Store gross receipt, allocations, unallocated amount and reversal/adjustment history. Do not silently allocate to a different project. Customer balance is derived from posted transactions and approved commercial documents, not manually typed.

## 5. Supplier bills and payments
Capture supplier invoice reference/date, supplier, PO/receipt references, line totals, tax details as provided, due date, attachments, review status and payment records. Match bill to PO and goods receipt where applicable. Differences route to exception review. Payment record includes amount, date, mode, bank reference and approver.

## 6. Expenses
Expense record: project, category, vendor/payee, date, amount, tax metadata if applicable, description, receipt evidence, submitted by, approver and payment status. Require project/category and evidence per policy. Prevent duplicate invoice/reference detection but allow reviewed exceptions.

## 7. Refunds, reversals and corrections
Never delete posted receipts/payments. Use reversal or refund transactions linked to original transaction, reason, authorisation and evidence. Partial refund supported. A refund is not complete until funds are confirmed as returned.

## 8. Project financial summary
Display contract value from accepted quotation version, approved change orders, receipts, outstanding customer amount, supplier commitments, received supplier bills, paid supplier amounts, recorded expenses and estimated margin. Clearly label commitments, actuals and estimates. Do not describe incomplete cost data as final profit.

## 9. Controls and calculations
Money stored as decimal/numeric or integer minor units under one explicit currency policy; never binary floating point. Calculations are server-side. Define rounding, tax treatment, credit notes, refunds and exchange-rate policy before implementation. Every posted transaction is immutable; correction uses linked reversal/adjustment.

## 10. Data movement
Reads: quotation snapshots, projects, customers, supplier/PO/receipt, expense categories, supplier payment records and approval policy. Writes: manual receipts, receipt verification, allocations, supplier bills, supplier payment records, expenses, refunds, reconciliation entries and audit events. Customer receipts are recorded only after funds have actually been received; verification/posted status is separate from a customer claim. No payment gateway is included. Use receipt-oriented API commands; do not expose a generic payment initiation endpoint. Enforce transaction boundaries and idempotency for imports/webhooks.

## 11. Permissions
finance.view; receipt.create/verify/allocate/reverse; supplier_bill.record/approve; supplier_payment.create/approve; expense.submit/approve; refund.create/approve; reconciliation.manage; finance.export; sensitive_reference.view. Separation of duties is policy-controlled.

## 12. Reports
Project collection status, overdue receivables, supplier due list, expense summary, cash movement summary, quotation-to-collection, project cost summary and exception report. Export must respect data scope and mask sensitive references.

## 13. Acceptance tests
- [ ] Unverified funds cannot be marked received.
- [ ] Receipt allocations cannot exceed eligible amount.
- [ ] Posted transaction cannot be edited/deleted in place.
- [ ] Refund links to original receipt/payment.
- [ ] Duplicate references are flagged.
- [ ] Project summary distinguishes actual, committed and estimated values.
- [ ] Tax fields are based on approved configuration, not hardcoded guesses.
- [ ] Access to bank/payment references is restricted and audited.

## 14. Decisions
Confirm finance workflow, payment verification evidence, receipt numbering, allocation rules, expense categories, approval matrix, accounting integrations, tax treatment and whether statutory accounting is in scope.
