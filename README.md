# flutter-skills-example

[![CI](https://github.com/gabuldev/flutter-skills-example/actions/workflows/ci.yaml/badge.svg)](https://github.com/gabuldev/flutter-skills-example/actions/workflows/ci.yaml)
[![Flutter](https://img.shields.io/badge/Flutter-3.38.4-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A small, complete Flutter app built with the conventions in
[**flutter-skills**](https://github.com/gabuldev/flutter-skills).

The skills repo is text — it says how we do things. This is the same thing
compiling, with tests, in CI. If the two ever disagree, this repo is the
evidence and the skill is the bug.

```bash
git clone https://github.com/gabuldev/flutter-skills-example.git
cd flutter-skills-example
make setup
make dev            # runs on Chrome against http://localhost:8080
make test
```

## What it is

**Agenda** — appointment scheduling. Three screens: a paginated, searchable,
offline-first list; a detail view; and one form that both creates and edits.

The domain is deliberately thin (a client, a date, a status). It exists to
carry the patterns, not to be a product.

## Layout

```
packages/design_system/   tokens + shared components, no domain knowledge
packages/app_core/        domain + data + the global DI registrations
apps/agenda/              the app: routes, theme, feature modules
```

A Dart **pub workspace** (`resolution: workspace`) resolves all three at once;
`melos.yaml` is there for the script runner.

## Where each skill shows up

Every convention in the skills repo has a file here you can open.

| Skill | See it in |
|---|---|
| `flutter-clean-arch` | `packages/app_core/lib/src/` — `domain/` has zero Flutter imports; models convert, entities don't |
| `flutter-monorepo` | root `pubspec.yaml` workspace, `melos.yaml`, the three `resolution: workspace` packages |
| `flutter-di` | `packages/app_core/lib/injections.dart` (global) vs each `*_module.dart` (feature-scoped) |
| `flutter-new-module` | `apps/agenda/lib/modules/appointments/` — module + controller + status + screen + widgets |
| `flutter-state` | `appointments_status.dart` — sealed, four variants, switched on exhaustively with no `default:` |
| `flutter-concurrency` | `appointments_controller.dart` — debounced search, paging that survives a failed page |
| `flutter-caching` | `appointment_repository_impl.dart` — first page cached, write invalidates, page 2 never served offline |
| `flutter-theming` | `apps/agenda/lib/theme/app_theme.dart` — M3 from a seed, no hex outside the tokens |
| `flutter-design-system` | `packages/design_system/lib/src/` — `DSColors`, `DSSpacing`, `DSRadius`, `DSTypography` |
| `flutter-forms` | `appointment_form_screen.dart` + `shared/formatters.dart` — pt-BR phone mask, field-level errors |
| `flutter-accessibility` | `DSButton`, `DSCard`, `AppointmentStatusChip` — status in text not only colour, 48dp targets, `MergeSemantics` |
| `flutter-testing` | 27 tests: use case, model, repository with a fake `Storage`, `bloc_test` on the Cubit, widget tests |
| `flutter-run` | `Makefile` — flavors, `--dart-define-from-file`, a fallback that warns loudly |
| `flutter-web` | `app_route_names.dart` split from `app_routes.dart`; `make clean` before trusting a blank page |
| `flutter-dart-style` | throughout: `mounted` guards after `await`, private widget classes over `_build` helpers, stable `ValueKey`s |

## A few things worth opening

**`app_route_names.dart` imports nothing.** The route *table* imports every
screen, and on web one of those can drag in `dart:ui_web`. A use case that
wants one route name must not pull that chain — it takes the names file. Note
`app_routes.dart` re-exports it with a library `export`, **not** by extending
it: Dart does not inherit static members, so `AppRoutes.appointments` would
never resolve.

**The repository caches page 1 and only page 1.** Paging while offline is not
a promise worth making, so `getAppointments(page: 2)` throws `NetworkFailure`
instead of quietly returning stale rows. There is a test for exactly that.

**`SaveAppointmentUsecase` holds the scheduling rules, not the controller.**
So a second app — an admin panel, say — cannot disagree with the phone app
about whether you may book in the past.

**`AppointmentsController.loadNextPage` keeps the list on a failed page.**
Losing twenty rows the user was reading because page three timed out is worse
than the missing page.

## Running against a real API

The app reads `BASE_URL` from a `--dart-define`, so there is no backend in this
repo. Point it at anything that serves:

```
GET  /appointments?page=1&limit=20&q=      -> { items: [...], total, page, limit }
GET  /appointments/:id                     -> { ... }
POST /appointments                         -> { ... }
PUT  /appointments/:id                     -> { ... }
POST /appointments/:id/cancel              -> 200
```

```bash
make dev BASE_URL=https://your-api.example.com
```

`String.fromEnvironment` is compile-time, so a missing define is the **empty
string**, not an error — and changing one needs a rebuild, not a hot reload.

## Verification

CI runs on every push and PR, plus weekly on a schedule, against two SDKs:
the pinned **Flutter 3.38.4** this repo is developed on, and **latest stable**
(allowed to fail, so an SDK release that breaks the example shows up as a
signal rather than as a reader's bug report).

Each run does: `dart format --set-exit-if-changed`, `flutter analyze`, both
test suites, and a release web build.

```bash
make analyze && make test
```

## License

MIT — see [LICENSE](LICENSE). The skills it demonstrates live in
[gabuldev/flutter-skills](https://github.com/gabuldev/flutter-skills).
