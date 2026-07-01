# Dependency Graph

Visual DAG of critical dependencies across the project. GitHub renders Mermaid natively — this file shows a live diagram when viewed on github.com.

For the full ordering, see [ROADMAP.md](./ROADMAP.md).

## High-level flow between epics

```mermaid
flowchart TD
    E1[E1: Foundation & DevEx<br/>Sprint 0-1]
    E2[E2: Auth & RBAC<br/>Sprint 2]
    E3[E3: Users & Addresses<br/>Sprint 3]
    E4[E4: Vendor Onboarding<br/>Sprint 4]
    E5[E5: Menu & Addons<br/>Sprint 5]
    E6[E6: Delivery Zones<br/>Sprint 6]
    E7[E7: Search & Cart<br/>Sprint 7]
    E8[E8: Orders<br/>Sprint 8]
    E9[E9: Payments & Wallet<br/>Sprint 9]
    E10[E10: Coupons & Reviews<br/>Sprint 10]
    E11[E11: Notifications & Uploads<br/>Sprint 11]
    E12[E12: Reports & Dashboards<br/>Sprint 12]
    E13[E13: Security & Audit<br/>Sprint 13]
    E14[E14: Test Hardening<br/>Sprint 14]
    E15[E15: CI/CD & Deploy<br/>Sprint 15]

    E1 --> E2
    E2 --> E3
    E3 --> E4
    E4 --> E5
    E4 --> E6
    E5 --> E7
    E6 --> E7
    E7 --> E8
    E8 --> E9
    E8 --> E10
    E9 --> E10
    E1 --> E11
    E10 --> E11
    E8 --> E12
    E9 --> E12
    E1 --> E13
    E12 --> E13
    E13 --> E14
    E14 --> E15

    classDef critical fill:#ff6b6b,stroke:#c92a2a,color:#fff
    class E1,E2,E4,E5,E7,E8,E9,E15 critical
```

Red nodes are on the critical path; delays cascade to launch.

---

## Critical path issue chain

The 21-issue chain that gates production launch. Each node is an issue number.

```mermaid
flowchart LR
    I1[#001<br/>repo init] --> I3[#003<br/>pyproject]
    I3 --> I8[#008<br/>fastapi bootstrap]
    I8 --> I9[#009<br/>config]
    I9 --> I15[#015<br/>sqlalchemy]
    I15 --> I17[#017<br/>alembic]
    I17 --> I21[#021<br/>user model]
    I21 --> I27[#027<br/>password hash]
    I27 --> I34[#034<br/>auth endpoints]
    I34 --> I44[#044<br/>address model]
    I44 --> I53[#053<br/>vendor model]
    I53 --> I62[#062<br/>vendor approve]
    I62 --> I69[#069<br/>menu item]
    I69 --> I76[#076<br/>public menu]
    I76 --> I91[#091<br/>cart model]
    I91 --> I103[#103<br/>order model]
    I103 --> I106[#106<br/>place order svc]
    I106 --> I116[#116<br/>payment model]
    I116 --> I118[#118<br/>initiate pay]
    I118 --> I183[#183<br/>deploy target]
    I183 --> I190[#190<br/>go-live]

    classDef critical fill:#ff6b6b,stroke:#c92a2a,color:#fff
    class I1,I3,I8,I9,I15,I17,I21,I27,I34,I44,I53,I62,I69,I76,I91,I103,I106,I116,I118,I183,I190 critical
```

---

## Sprint 0-2 detail (start here on Day 1)

The first sprints have the most parallelism opportunities. Two developers can work simultaneously if they respect dependency direction.

```mermaid
flowchart TD
    I1[#001 repo init]
    I2[#002 folder structure]
    I3[#003 pyproject.toml]
    I4[#004 ruff/black/mypy]
    I5[#005 pre-commit]
    I6[#006 Dockerfile]
    I7[#007 docker-compose]
    I8[#008 FastAPI bootstrap]
    I9[#009 config]
    I10[#010 logging]
    I11[#011 exceptions]
    I12[#012 CI workflow]
    I13[#013 CONTRIBUTING]
    I14[#014 templates]

    I1 --> I2
    I2 --> I3
    I2 --> I8
    I3 --> I4
    I3 --> I8
    I3 --> I6
    I4 --> I5
    I4 --> I12
    I6 --> I7
    I8 --> I9
    I9 --> I10
    I10 --> I11
    I1 --> I13
    I1 --> I14

    classDef krishna fill:#4dabf7,stroke:#1971c2,color:#fff
    classDef piyush fill:#51cf66,stroke:#2f9e44,color:#fff
    class I1,I4,I5,I8,I10,I12,I13 krishna
    class I2,I3,I6,I7,I9,I11,I14 piyush
```

**Blue = Krishna, Green = Piyush.** Notice the parallelism: while Piyush works on #002/#003, Krishna is free to work on #013/#014.

---

## How to read these

1. **Arrows point from prerequisite to dependent.** `A → B` means "B needs A first."
2. **Same-level nodes are parallel-safe.** Two developers can work on them at the same time.
3. **Red = critical path.** If it slips, launch slips.
4. **Colors in Sprint 0-2 diagram** show suggested assignments — swap freely, but don't have both devs blocked on the same node.

## Regenerating

When issues get renumbered or dependencies change, edit this file. Mermaid syntax is simple; there's no build step. Keep it in sync with `ROADMAP.md`.