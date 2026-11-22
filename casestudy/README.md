# GreenGrid Solar Platform — Case Study

**Client:** GreenGrid Solar Solutions, Erattupetta, Kottayam, Kerala  
**Prepared by:** Parthiv Binish  
**Research snapshot:** 22 November 2026  
**Status:** Feasibility and solution-design baseline.

## Documents
1. [Business workflows](./01-business-workflows.md)
2. [Regulatory and compliance study](./02-regulatory-and-compliance.md)
3. [Device monitoring and IoT](./03-device-monitoring.md)
4. [Platform architecture and access control](./04-platform-architecture.md)
5. [Roadmap, costs and client questions](./05-roadmap-costs-and-open-questions.md)

## Recommendation
Proceed with a modular-monolith MVP: React + TypeScript, FastAPI, PostgreSQL, Redis and ARQ workers; React Native for customer/technician mobile workflows. Use group-based RBAC with scope-aware ABAC. Treat KSEB, MNRE and manufacturer clouds as external systems. Begin with authorised manual utility-status tracking and add device integrations only after GreenGrid supplies its actual equipment inventory.

> This is not legal, tax or electrical engineering advice. Revalidate regulations, effective dates, API access, pricing and technical requirements against official sources before production decisions. Items requiring confirmation must not be hardcoded until signed off.

## Maintenance
Keep source links, research date, rule effective dates and verification owner updated. Distinguish client-confirmed facts from assumptions.