<!--
SYNC IMPACT REPORT
==================
Version change: N/A (template) → 1.0.0 (initial ratification)
Modified principles: All placeholders replaced — first real constitution
Added sections: Core Principles (I–VIII), Architecture Constraints, Quality & Governance Gates, Governance
Removed sections: None (all template comment stubs cleaned up)
Templates requiring updates:
  ✅ .specify/templates/plan-template.md — Constitution Check section now maps to gates below
  ✅ .specify/templates/spec-template.md — aligns with FR/SC language and Flutter-specific constraints
  ✅ .specify/templates/tasks-template.md — test task category is MANDATORY (not optional) per constitution
Deferred TODOs: None — all fields resolvable from project documentation
-->

# Moto Orbito Constitution

> **Read this document completely before writing a single line of code.**
> This constitution supersedes all other practices within the project.
> Any instruction not found here defers to `AGENTS.md`.

---

## Core Principles

### I. Feature-First Clean Architecture (NON-NEGOTIABLE)

Every feature MUST be structured as `features/<featureName>/{presentation, domain, data}`.
Layer flow is strictly one-directional: **Presentation → Domain → Data**. No layer may import
from a higher layer. The `domain` layer MUST NOT import any `package:flutter/...` symbol.
Business logic MUST live exclusively in UseCases — never in `initState`, `build()`,
widget callbacks, or Cubits directly.

**Rationale**: Enforces testability, replaceability of each layer, and prevents accidental
coupling that compounds into technical debt at scale.

### II. Cubit/Bloc State Management (NON-NEGOTIABLE)

All UI state MUST be managed through Cubit (preferred) or Bloc (for complex event flows).
States MUST be `sealed class`. UI MUST use exhaustive `switch` — never `if (state is X)`.
Cubits MUST depend only on UseCases, never on repositories or services directly.
`FutureBuilder` MUST NOT be used alongside Cubit/Bloc state.
`ValueNotifier`/`ChangeNotifier` are permitted for purely local, non-shareable widget state.

**Rationale**: Consistent, predictable state guarantees that any screen can be tested in
isolation by emitting states without running the full app.

### III. ApiResult<T> Error Handling (NON-NEGOTIABLE)

Every cross-layer call MUST return `ApiResult<T>`. Nullable returns and raw types are
forbidden at layer boundaries. The data layer MUST catch all exceptions, map them to
`Failure` types, and return `ApiResult`. The UI MUST always render all four states:
**loading, success, empty, error**. Exceptions MUST NOT be swallowed silently. Raw
exception messages MUST NOT be surfaced to the user — always map through localized
`Failure` strings.

**Rationale**: A uniform result type eliminates null-checks across the codebase, makes
error paths explicit, and ensures users never see raw stack traces or cryptic messages.

### IV. Supabase-as-Backend (NON-NEGOTIABLE)

All database, auth, realtime, and storage operations MUST go through Supabase. Direct calls
to `supabase.from(...)`, `supabase.channel(...)`, or `supabase.storage` MUST reside only
in `data/repositories/` implementations. Cubits, UseCases, and Widgets MUST NOT hold a
Supabase reference. Every Supabase call MUST be wrapped in try/catch → `Failure` mapping.
The Flutter app MUST use only the `anon` key — the `service_role` key is forbidden client-side.

**Rationale**: Centralizing Supabase access in repositories allows swapping or mocking the
backend without touching any business or presentation code.

### V. Test-First Discipline (NON-NEGOTIABLE)

Every feature is **incomplete** without full test coverage. Unit tests MUST cover all
UseCase paths (success, failure, edge-cases). Cubit tests MUST cover every state transition:
`initial → loading → success | error | empty`. Widget tests MUST cover key interactions.
`mocktail` MUST be used for mocking — `mockito` is forbidden. Bug fixes MUST include a
regression test. One assertion/behavior per test — no multi-assertion mega-tests.

**Rationale**: Tests are the primary safety net for a 62-screen app with GPS, realtime,
and AI integrations. Without them, regressions are undetectable.

### VI. Theming via ThemeData + ThemeExtension (NON-NEGOTIABLE)

Raw color literals, hardcoded text styles, and direct `AppColors` access are forbidden
anywhere in the codebase. All colors MUST come from `AppColorsExtension` (via
`Theme.of(context).extension<AppColorsExtension>()`). All text styles MUST come from
`theme.textTheme`. Spacing constants MUST come from `ThemeExtension` or the `Spacing`
class in `core/theme/`. Both light and dark modes MUST be implemented from day one.

**Rationale**: A single source of truth for visuals makes it possible to re-skin the app,
add brand variants, or fix a color globally without hunting through every widget.

### VII. Localization via slang (NON-NEGOTIABLE)

No user-visible string MUST ever be hardcoded. All strings MUST use the `slang` key format
`context.t.featureName.screenName.keyName`. Strings MUST be added to `assets/i18n/*.json`
(Arabic and English). `dart run slang` MUST be run after every string addition. Arabic is
the primary language (RTL); every screen MUST be tested in RTL layout. Date and number
formatting MUST use `intl` with locale-awareness (Arabic-Indic numerals for `ar`).

**Rationale**: The primary target market is Arabic-speaking; half-baked localization
ships a broken product to the majority of users.

### VIII. Security-by-Default (NON-NEGOTIABLE)

No secrets, API keys, or credentials MUST be hardcoded in Flutter source code. JWT tokens
MUST be stored exclusively via `flutter_secure_storage`. AI API keys MUST be stored in
Supabase Edge Function environment variables and accessed only through the Edge Function
proxy — never called directly from the Flutter client. Sensitive data (blood type, emergency
contacts) MUST NOT be logged. Supabase Row Level Security (RLS) MUST be enabled on every
table. Client-side role checks (Rider / Group Admin / Group Owner) are advisory only —
all authoritative enforcement lives in RLS and Domain UseCases.

**Rationale**: A motorcycle group app handles location data and personal emergency info.
Security is not optional — a breach directly endangers riders.

---

## Architecture Constraints

### Dependency Injection

`get_it` is the only approved DI container. All registrations live in `core/di/`.
Cubits MUST use `registerFactory`. UseCases and Repositories MUST use `registerLazySingleton`.
Widgets MUST NOT access `get_it` directly — inject through Cubit or constructor only.

### Navigation

`go_router` is the only navigation mechanism. Named routes only — route name constants
live in `core/router/routes.dart`. `Navigator.push` is forbidden. Navigation logic MUST
NOT live inside widgets. Only primitive IDs (never full entity objects) MUST be passed
between screens.

### Networking

`dio` via `BaseApiClient` is the only HTTP client. Interceptors handle auth tokens, logging,
and error mapping. Dio MUST NOT be called directly anywhere outside `BaseApiClient`.

### Dependency Approval

No package MUST be added to `pubspec.yaml` without explicit team approval. The pre-approved
package list is maintained in `AGENTS.md §18`. Always use the latest stable version with a
strong pub.dev score.

### Android Flavors

The project has two flavors: `development` and `production`. Flavor-specific logic lives
only in the entry point files (`main_development.dart` / `main_production.dart`). `AppLogger`
is enabled in `development` and is a no-op in `production`. `kDebugMode`/`kReleaseMode` MUST
NOT be used as a flavor proxy. No `AppConfig` class, `--dart-define`, or `.env` file is used.

### Phase Scope

Only Phase 1 features (Modules 01–10) MUST be built. Phase 2 and Phase 3 modules are
strictly out of scope until explicitly instructed. No scaffolding, imports, or references
to out-of-scope modules are permitted.

---

## Quality & Governance Gates

Every feature plan MUST pass these gates before implementation begins (and MUST be
re-checked after design):

| Gate | Check |
|------|-------|
| **Architecture Gate** | Presentation / Domain / Data layers respected; no layer bypass |
| **State Gate** | Cubit/Bloc used; states are `sealed class`; exhaustive `switch` in UI |
| **Error Gate** | `ApiResult<T>` used at every layer boundary; all four UI states handled |
| **Localization Gate** | No hardcoded strings; all keys in `assets/i18n/*.json`; `dart run slang` run |
| **Theming Gate** | No raw colors/sizes; ThemeExtension used throughout |
| **Security Gate** | No secrets in code; RLS on all tables; JWT in secure storage |
| **Test Gate** | Unit, Cubit, and Widget tests written; `mocktail` used; one behavior per test |
| **Dependency Gate** | No unapproved packages; `pubspec.yaml` not modified without approval |
| **Navigation Gate** | `go_router` named routes only; only primitive IDs passed |
| **Phase Gate** | No Phase 2/3 files scaffolded or referenced |

Any violation MUST be documented in the plan's **Complexity Tracking** table with
justification. Unjustified violations block merge.

---

## Governance

- This constitution supersedes all other internal style guides or practices.
- Amendments require: written rationale, impact analysis on existing features, and explicit
  approval from the project owner before any code changes are merged.
- **Versioning policy** follows semantic versioning:
  - MAJOR — backward-incompatible governance changes or principle removals.
  - MINOR — new principle added or materially expanded guidance.
  - PATCH — clarifications, wording fixes, non-semantic refinements.
- All AI agents and developers MUST read this file completely before writing any code.
- `flutter analyze` MUST pass with zero errors before any feature is considered done.
- All PRs/reviews MUST verify compliance with all gates in the Quality & Governance section.
- Complexity MUST be justified — simple solutions are preferred over clever ones.
- For runtime development guidance, refer to `AGENTS.md`.

**Version**: 1.0.0 | **Ratified**: 2026-06-28 | **Last Amended**: 2026-06-28
