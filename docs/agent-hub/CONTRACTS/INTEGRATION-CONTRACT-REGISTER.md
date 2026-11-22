# External Integration Contract Register

| Integration | Owner | Required verification | Current status |
|---|---|---|---|
| WhatsApp via OpenWA candidate | A5 | Terms/policy, account/session lifecycle, QR re-auth, webhook security, hosting, rate limits, reliability and fallback | NOT VERIFIED |
| Official WhatsApp Business Platform alternative | A5 | Business/account eligibility, templates, pricing, webhook and provider requirements | NOT VERIFIED |
| Inverter/manufacturer APIs | A7 | Exact manufacturer/model, owner access, credentials, scopes, rate limits, data fields and terms | NOT VERIFIED |
| Push delivery | A6/A2 | Android project credentials, token lifecycle, permission and provider setup | NOT VERIFIED |
| Email/SMS | A6 | Provider selection, sender identity, delivery callbacks and compliance | NOT VERIFIED |
| Government/DISCOM portals | A3/A7 as applicable | Official source, permission, terms and whether integration is authorised | NOT VERIFIED |
| Postal PIN reference | A3/A4 | Approved dataset/API, licence, freshness and source provenance | NOT VERIFIED |

Do not claim an integration is live until credentials, approvals, sandbox tests and production verification are recorded. Keep external providers behind adapters.
