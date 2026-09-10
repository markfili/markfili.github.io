# Pages menu — design

## Goal

List every GitHub repository of `markfili` that has GitHub Pages enabled, reachable
from the arilus.hr home screen, so visitors can open each project site.

## Decisions

- **Data source:** live GitHub REST API, fetched in the browser. New Pages repos
  appear without a redeploy. Unauthenticated limit: 60 requests/hour per visitor IP.
- **UI:** a fourth round badge (`FontAwesomeIcons.layerGroup`, tooltip "Projects")
  next to LinkedIn / GitHub / email opens a modal bottom sheet with the list.
- **No state-management package:** one request on one screen; `FutureBuilder` is enough.

## Data

`GET https://api.github.com/users/markfili/repos?per_page=100&type=owner`

- Keep repos with `has_pages == true`.
- Exclude `markfili.github.io` — that repo *is* arilus.hr.
- Sort by `pushed_at`, newest first.
- `url` = `homepage` when non-empty, else `https://arilus.hr/<name>/` (project Pages
  sites are served under the user site's custom domain).
- `description` empty string → `null`.
- Any non-200 response → `PagesFetchException(statusCode)`.
- Append fixed extra links the user endpoint can't return (sheet title is just
  "Projects" since not all are Pages sites):
  - Zagreb Developers Drinkup — `https://zagreb-developers.github.io/drinkup/` (org repo)
  - Zagreb Developers Spaces — `https://zagreb-developers.github.io/spaces/` (org repo)
  - Uradi sad — `https://uradisad.vercel.app/` (Vercel, no Pages)

## Components

| Unit | Responsibility |
|---|---|
| `lib/data/pages_repository.dart` | `PagesSite` model, `PagesRepository.fetchSites()` (injected `http.Client`), `PagesFetchException` |
| `lib/widgets/pages_sheet.dart` | Bottom sheet; states: loading, list, empty ("No projects yet"), error (message + Retry + link to GitHub repositories tab) |
| `lib/utils/widgets.dart` | `ContactBadge` accepts `onPressed` as an alternative to `url`; shared `openUrl()` awaits `launchUrlString` and logs failures in debug |
| `lib/main.dart` | Adds the badge; home state owns the repository and caches the fetch `Future` so reopening the sheet does not refetch; Retry replaces it |

## Platform

- Web: api.github.com sends CORS headers — no proxy needed.
- Android: add `android.permission.INTERNET` to the main manifest (release builds).

## Testing

- `test/pages_repository_test.dart` — `MockClient`: request URL, filtering, self
  exclusion, sort order, URL fallback, empty description, non-200 error.
- `test/pages_sheet_test.dart` — fake loader: loading, list, empty, error, Retry.
- Manual: open the sheet in `flutter run -d chrome`.

## Implementation plan

1. Add `http` dependency.
2. Write `pages_repository_test.dart` (failing) → implement `pages_repository.dart` → green.
3. Write `pages_sheet_test.dart` (failing) → implement `pages_sheet.dart` → green.
4. Add `openUrl()` + `onPressed` to `ContactBadge`; wire the badge and cached fetch into `main.dart`.
5. Add the Android `INTERNET` permission.
6. `flutter analyze`, `flutter test`, hot restart the running web app and open the sheet.

## Out of scope

- Authenticated API calls / private repos (all current Pages repos are public).
- Pagination beyond 100 repos.
- Fixing the Android Gradle setup flagged in code review.
