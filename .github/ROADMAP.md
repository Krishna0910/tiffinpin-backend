# TiffinPin API v2 — Roadmap

This document is the authoritative execution order for the backend project. Issues in the GitHub tracker are the source of truth for scope; this file is the source of truth for order and dependencies.

**Team**: 2 developers, ~2h/day each, ~14 effective hours/week.
**Duration**: 16 sprints, 2 weeks each ≈ 7.5 months.
**Target**: Portfolio-ready product by end of Sprint 12; production-deployable by end of Sprint 15.

---

## Milestone timeline

| Milestone | Sprints | Weeks | Target End |
|---|---|---|---|
| M1 - Foundation | 0-1 | 1-4 | Week 4 |
| M2 - Identity & Access | 2-3 | 5-8 | Week 8 |
| M3 - Vendor Platform | 4-6 | 9-14 | Week 14 |
| M4 - Ordering Engine | 7-9 | 15-20 | Week 20 |
| M5 - Growth Features | 10-11 | 21-24 | Week 24 |
| M6 - Insights | 12 | 25-26 | Week 26 |
| M7 - Hardening | 13-14 | 27-30 | Week 30 |
| M8 - Production Launch | 15 | 31-32 | Week 32 |

---

## Critical path

These 21 issues form the blocking chain from repo init to production launch. Any delay on a critical-path issue directly delays go-live. Non-critical-path issues can float within their sprint without impacting the launch date.

```
#001 → #003 → #008 → #009 → #015 → #017 → #021 → #027 → #034
     → #044 → #053 → #062 → #069 → #076 → #091 → #103 → #106
     → #116 → #118 → #183 → #190
```

**Rule**: If a critical-path issue is blocked or slipping, both developers stop other work and pair on unblocking it. Non-critical-path slippage is acceptable within-sprint.

---

## Sprint-by-sprint execution order

Within a sprint, issues are listed roughly in execution order. Issues on the same line have no dependencies between them and can be worked in parallel by different developers.

### Sprint 0 — Foundation (Weeks 1-2)

```
#001 (repo init)                    → foundation for everything
  ├─ #013 (contributing docs)       → parallel, any time
  └─ #014 (issue/PR templates)      → parallel, any time

#002 (folder structure)             ← needs #001
#003 (pyproject.toml)               ← needs #002
  ├─ #004 (ruff/black/mypy config)  ← needs #003
  │    └─ #005 (pre-commit)         ← needs #004
  │         └─ #012 (CI workflow)   ← needs #004
  └─ #006 (Dockerfile)              ← needs #003
       └─ #007 (docker-compose)     ← needs #006

#008 (FastAPI bootstrap)            ← needs #002, #003
  └─ #009 (config)                  ← needs #008
       └─ #010 (logging)            ← needs #009
            └─ #011 (exceptions)    ← needs #010
```

### Sprint 1 — DB Layer (Weeks 3-4)

```
#015 (SQLAlchemy session)           ← needs #009
  ├─ #016 (base mixins)             ← needs #015
  │    ├─ #018 (repository base)    ← needs #016
  │    │    └─ #019 (service layer docs)
  │    ├─ #021 (User model)         ← needs #016, #017, #020
  │    └─ #022 (enums)              ← needs #016
  ├─ #017 (Alembic)                 ← needs #015
  └─ #024 (deep health check)       ← needs #015

#020 (pytest fixtures)              ← needs #017, #011
#023 (common Pydantic schemas)      ← needs #011
#025 (API versioning docs)          ← parallel, needs #008
#026 (CORS)                         ← parallel, needs #009
```

### Sprint 2 — Auth & RBAC (Weeks 5-6)

```
#027 (password hashing)             ← needs #009
  └─ #028 (JWT access)              ← needs #027
       ├─ #029 (JWT refresh)        ← needs #028
       └─ #035 (get_current_user)   ← needs #028
            └─ #036 (RBAC deps)     ← needs #35, #22

#030 (user schemas)                 ← needs #023
#031 (user repository)              ← needs #021, #018

#032 (register service)             ← needs #027, #030, #031
  └─ #033 (login service)           ← needs #032
       └─ #034 (auth endpoints)     ← needs #033, #029

#037 (/auth/me)                     ← needs #035
#038 (forgot password)              ← needs #032
  └─ #039 (reset password)          ← needs #038

#040 (auth integration tests)       ← needs #034, #036, #037, #039
```

### Sprint 3 — Users, Profiles, Addresses (Weeks 7-8)

```
#041 (customer profile model)       ← needs #21
  └─ #042 (auto-create profile)     ← needs #041
       └─ #043 (/users/me)          ← needs #042
            └─ #051 (phone verify)  ← needs #043

#044 (address model)                ← needs #021
  └─ #045 (address schemas/repo)    ← needs #044
       └─ #046 (address service)    ← needs #045
            └─ #047 (address CRUD)  ← needs #046
                 └─ #050 (tests)    ← needs #047

#048 (admin list users)             ← needs #036
  └─ #049 (activate/deactivate)     ← needs #048
       └─ #052 (seed users)         ← needs #049
```

### Sprint 4 — Vendor Onboarding (Weeks 9-10)

```
#053 (vendor model)                 ← needs #021
  ├─ #054 (state machine docs)      ← needs #022, #053
  ├─ #055 (apply endpoint)          ← needs #053, #036
  │    └─ #056 (update)             ← needs #055
  │         └─ #057 (submit)        ← needs #056
  └─ #058 (KYC doc model)           ← needs #053
       └─ #059 (docs endpoints)     ← needs #058

#057 → #060 (admin queue)
  └─ #061 (admin detail)            ← needs #060
       └─ #062 (approve/reject)     ★ critical path
            └─ #063 (suspend)
            └─ #064 (public list)   ← needs #062
                 └─ #065 (detail)
                      └─ #066 (tests)
```

### Sprint 5 — Menu, Categories, Addons (Weeks 11-12)

```
#067 (category model)               ← needs #053
  └─ #068 (category CRUD)           ← needs #067
       └─ #069 (menu item model)    ★ critical path
            └─ #070 (schemas/repo)
                 └─ #071 (item CRUD)
                      └─ #072 (bulk toggle)

#069 → #073 (addon models)
  └─ #074 (addon CRUD)              ← needs #073
       └─ #075 (attach addons)      ← needs #074
            └─ #076 (public menu)   ★ critical path
                 ├─ #077 (tests)
                 └─ #078 (menu summary)
                      └─ #079 (seed menu)
```

### Sprint 6 — Delivery Zones & Availability (Weeks 13-14)

```
#080 (delivery zone model)          ← needs #053
  └─ #081 (zone CRUD)               ← needs #080

#082 (schedule model)               ← needs #053
  └─ #083 (schedule endpoints)      ← needs #082
       └─ #084 (is_open util)       ← needs #083

#081, #084 → #085 (filter by pincode)
  └─ #086 (name search)             ← needs #085
       └─ #087 (cuisine/tag filter) ← needs #086
            └─ #088 (sort options)  ← needs #087

#089 (query builder)                ← needs #023
#090 (delivery tests)               ← needs #085
```

### Sprint 7 — Cart & Search Refinement (Weeks 15-16)

```
#091 (cart models)                  ★ critical path, needs #069
  └─ #092 (pricing calculator)      ← needs #091
       └─ #093 (get cart)           ← needs #092
            └─ #094 (add item)      ← needs #093
                 └─ #095 (update)   ← needs #094
                      └─ #096 (remove)
                           └─ #097 (tests)

#098 (item search)                  ← needs #076, parallel
#099 (menu filters)                 ← needs #076, parallel
#100 (pagination audit)             ← needs #089, parallel

#101 (Redis cache)                  ← needs #007
  └─ #102 (cache public)            ← needs #101
```

### Sprint 8 — Orders & Lifecycle (Weeks 17-18)

```
#103 (order models)                 ★ critical path, needs #091, #044
  ├─ #104 (state machine docs)      ← needs #022, #103
  └─ #105 (order number)            ← needs #103, #101

#103 → #106 (place order service)   ★ critical path
  └─ #107 (place endpoint)          ← needs #106
       ├─ #108 (customer orders)    ← needs #107
       └─ #109 (vendor queue)       ← needs #107

#104 → #110 (transition service)
  ├─ #111 (vendor actions)          ← needs #110
  ├─ #112 (customer cancel)         ← needs #110
  ├─ #113 (admin override)          ← needs #110
  ├─ #114 (lifecycle tests)         ← needs all above
  └─ #115 (order events audit)      ← needs #110
```

### Sprint 9 — Payments & Wallet (Weeks 19-20)

```
#116 (payment model)                ★ critical path, needs #103
  └─ #117 (dummy gateway)           ← needs #116
       └─ #118 (initiate payment)   ★ critical path
            └─ #119 (confirm)       ← needs #118

#120 (wallet models)                ← needs #021
  └─ #121 (wallet service)          ← needs #120
       └─ #122 (wallet endpoints)   ← needs #121
            └─ #125 (admin adjust)  ← needs #122

#118, #121 → #123 (wallet payment)
  └─ #124 (refund on cancel)        ← needs #123, #112

#125 → #126 (payment tests)
```

### Sprint 10 — Coupons, Ratings, Reviews (Weeks 21-22)

```
#127 (coupon model)                 ← needs #103
  └─ #128 (usage log)               ← needs #127
       └─ #129 (validation service) ← needs #128
            └─ #130 (apply/remove)  ← needs #129
                 └─ #131 (consume)  ← needs #130, #106

#127 → #132 (admin coupon CRUD)     parallel

#133 (review model)                 ← needs #103
  └─ #134 (post review)             ← needs #133
       └─ #135 (aggregation)        ← needs #134
            └─ #136 (public list)   ← needs #135
                 └─ #137 (moderation)

#131, #137 → #138 (integration tests)
```

### Sprint 11 — Notifications & Uploads (Weeks 23-24)

```
#139 (Celery spike)                 → decision doc
  └─ #140 (Celery setup)            ← needs #139

#141 (notification model)           ← needs #021
  └─ #142 (service+endpoints)       ← needs #141
       └─ #143 (order triggers)     ← needs #142, #115

#140 → #144 (email sender)
  └─ #145 (reset via Celery)        ← needs #144

#146 (object storage)               ← needs #009
  └─ #147 (vendor upload)           ← needs #146
       └─ #148 (menu upload)        ← needs #147
            └─ #149 (thumbnails)    ← needs #148
```

### Sprint 12 — Reports & Dashboards (Weeks 25-26)

```
#150 (customer dashboard)           ← needs #108, parallel
#151 (vendor dashboard)             ← needs #109
  ├─ #153 (sales report)            ← needs #151
  │    └─ #154 (item report)        ← needs #153
  └─ #152 (admin dashboard)         ← needs #151
       └─ #155 (revenue report)     ← needs #152
            └─ #156 (CSV export)    ← needs #155

#152 → #157 (dashboard cache)
  └─ #158 (dashboard tests)         ← needs #157

#156 → #159 (report tests)
  └─ #160 (analytics docs)          ← needs #159
```

### Sprint 13 — Security & Audit (Weeks 27-28)

```
#161 (audit log)                    ← needs #021
  └─ #162 (audit middleware)        ← needs #161
       └─ #163 (audit viewer)       ← needs #162

#164 (rate limit)                   ← needs #101, parallel
#165 (security headers)             ← needs #026, parallel
#166 (strict schemas)               ← parallel
#167 (soft delete audit)            ← needs #016, parallel
#168 (activity tracking)            ← needs #021, parallel

#012 → #169 (secret scan)
#012 → #170 (dep scan)
#025 → #171 (API v2 stub)

All above → #172 (security tests)
```

### Sprint 14 — Test Hardening & Docs (Weeks 29-30)

```
#173 (coverage push)                ← no blocking deps
  └─ #174 (E2E scenarios)           ← needs #173
       └─ #175 (load baseline)      ← needs #174
            └─ #176 (fix slow endpoints) ← needs #175

Parallel docs:
#177 (OpenAPI polish)
  └─ #178 (README overhaul)         ← needs #177
       └─ #180 (runbook)            ← needs #178
#179 (ADRs)                         parallel
```

### Sprint 15 — CI/CD & Deploy (Weeks 31-32)

```
#181 (multi-env config)             ← needs #009

#012 → #182 (image publish)
  └─ #183 (deploy target)           ★ critical path
       └─ #184 (CD staging)         ← needs #183
       └─ #188 (backup playbook)    ← needs #183

#010 → #185 (Prometheus)
#010 → #186 (Sentry)
#010, #140 → #187 (tracing IDs)

#189 (CHANGELOG)                    parallel
  └─ #190 (go-live)                 ★ critical path, needs #189
```

---

## What to do when reality diverges from this plan

Things that will happen: an issue takes 3x its estimate, a decision reverses, a new requirement appears, one developer is out for a week.

**If a non-critical-path issue slips**: skip it or push to next sprint. Move on.

**If a critical-path issue slips**: both devs pair on it. Delay the sprint end date rather than skipping steps.

**If scope changes**: update this file first, then create/close/edit issues to match. Do not let issues and this file drift out of sync.

**If a sprint has excess capacity**: pull from the next sprint's "parallel" items first, never from the critical path (those are ordered for a reason).

---

## Maintenance

- Update this file at the start of every sprint planning session (max 5 min).
- If an issue is retitled or renumbered on GitHub, update this file in the same commit.
- Retro this roadmap every 4 sprints — accuracy of estimates tells you if you're over/underscoping.