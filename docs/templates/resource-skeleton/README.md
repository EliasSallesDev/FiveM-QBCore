# Resource skeleton `qbx-feature`

Copy this folder to your FiveM `resources/[standalone]/qbx-<name>/`.

1. Rename `qbx-feature` in `fxmanifest.lua` and folder name.
2. Add dependencies you actually use (`ox_target`, inventory, etc.).
3. Run SQL from `sql/` against your database.
4. Add `ensure qbx-<name>` to `server.cfg` **after** `qb-core`, `oxmysql`, `ox_lib`.

Locale files: add `locale/en.lua` and `locale/pt-br.lua` when you expose strings — wire them in manifest following qb-core conventions.

**NUI / Distopia branding:** copy logos from `qb-core` → `shared/Pack Logo Distopia/` into `html/assets/brand/` (see [`docs/branding.md`](../../branding.md)). Uncomment the `ui_page` / `files` block in `fxmanifest.lua`. Reference HTML patterns in [`html/example-snippet.html`](html/example-snippet.html).
