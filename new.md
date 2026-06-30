make upload scrollable because of that qr part you added so it doesnt show overflow, and also read this and make a plan on how you will implement them.
1. Dashboard (most important)

Scrolls has a full dashboard where you see all your forms. Perma.link needs the same — a page at /dashboard showing all links you've created, their filenames, short codes, click counts, and upload dates. Right now after uploading you get one link and it's gone if you close the tab. A dashboard fixes that permanently.

2. Connect Wallet / Auth

Scrolls uses a Sui wallet to tie forms to an owner. For Perma.link you don't need a full wallet — but you need some form of identity so a user can see their own links in a dashboard. Options in order of complexity: Supabase Auth (email magic link, simplest), Sui wallet connect (web3 native, fits the Walrus branding), or anonymous session stored in localStorage. Sui wallet is the right call for this product — it's built on Walrus which is part of the Sui ecosystem.

3. Link history / My Links page

Direct result of having auth. After connecting wallet or signing in, user sees every link they've ever created. Table or card grid showing filename, short code, click count, date. Click any row → goes to /:code file page.

4. QR code for each link

Every short link should have a QR code on the file page. One tap to copy as image. Huge for sharing files at events, in presentations, in print. Simple to add with a Flutter QR package.

5. Link expiry / Epoch display

Walrus stores blobs for a set number of epochs (you're using 3). Scrolls shows storage status. Perma.link should show on the file page when the blob was stored and roughly when the storage epoch ends — honest transparency about the testnet vs mainnet difference.

6. File preview

Scrolls shows form fields inline. Perma.link should preview the file directly on the /:code page if it's an image — show a thumbnail. If it's a PDF show the first page. If it's code or text show the first few lines. Anything else show a generic file icon. Makes the file page feel alive instead of just a card with metadata.

7. Copy embed code

Alongside copy link and download, add a third share option — copy an HTML embed snippet like <a href="perma.link/abc123">filename.png</a>. Developers will use this constantly for READMEs, docs, and portfolios.

8. Docs page

Scrolls has a full docs page. Perma.link should have a simple /docs page explaining the API — because the natural extension of this product is letting developers upload files programmatically via a REST endpoint, not just through the UI. Even if the API doesn't exist yet, documenting the vision signals that this is a serious dev tool.

Prioritized order for what to build next:

Sui wallet connect + auth — gives the product identity
Dashboard / My Links — gives the product stickiness
File preview on file page — makes the product feel complete
QR code — quick win, high value for sharing
Embed code copy — developer-specific feature, fits your audience
Epoch / storage status display — honest and web3-native
Docs page — signals maturity

# Phase 2: identity, dashboard, file page, full QA pass

## Context

`new.md` is the feature list from the client review. Per the latest direction:

- **Skip Sui wallet** — too much surface area for now. Identity is **Supabase email magic-link auth** only.
- **Skip the Docs page** — not needed yet.
- **The dominant priority is making every existing button and feature actually work.** Nothing new ships until the current UI is honest end-to-end.

Revised feature list, in priority order:

0. **Full feature audit + fix pass** (new — see §0)
1. Supabase email auth (was: Sui wallet)
2. Dashboard / My Links
3. File preview on file page
4. QR code on file page (already on success card — lift to a shared widget)
5. Embed code copy (`<a href>`, Markdown, image)
6. Epoch / storage status chip

Two cross-cutting shifts the feature work forces, called out up front because they shape every step:

- **`/:code` stops being a redirect.** Today `RedirectScreen` calls `launchUrl(walrusUrl, externalApplication)` the moment it resolves. To preview a file in-product, that route becomes a real page with metadata, preview, QR, embed code, and explicit View/Download buttons. The "instant bounce" UX dies — that's the point.
- **DB schema gets a `user_id` column.** Without it there's no dashboard and no ownership checks. Backwards-compatible additive migration (existing rows get `null` and remain visible only by direct short-code lookup), so authed users coexist with pre-auth shared links.

---

## 0. Full feature audit + fix pass

Before anything new ships, walk the entire UI and fix everything that's currently broken, fake, or half-wired. Treat this as a checklist PR — small surgical fixes, no new features.

### Audit checklist

**Landing screen (`/`)**

- [ ] Hero "Upload a file" CTA → `/upload`. Confirm route works on direct visit (refresh on Vercel).
- [ ] Hero secondary "Learn how it works" / equivalent — verify it scrolls to the right section.
- [ ] Navbar logo → `/`. "Launch A File" rocket button → `/upload`.
- [ ] Navbar section anchors (Why / Features / Workflow) — confirm `_scrollToSection` actually scrolls; smooth on desktop and mobile.
- [ ] Bottom CTA "Upload your first file" → `/upload`.
- [ ] Bottom CTA "Read the docs" → external GitHub. Already wired; confirm.
- [ ] Footer Upload link → `/upload`. GitHub / Walrus / Sui Explorer footer links → external; confirm they open in a new tab.
- [ ] Footer "Testnet operational" indicator — confirm copy matches reality (we changed from Mainnet).
- [ ] Anywhere `perma.link/xk4r` appeared in copy is now `permalink-gamma.vercel.app/xk4r` or styled domain+code; spot-check on each card.
- [ ] No remaining `print()` calls anywhere in `lib/` — `flutter analyze` clean.

**Upload screen (`/upload`)**

- [ ] Drag-drop a file → uploads. Cancel mid-upload → returns cleanly to idle.
- [ ] Browse files button → file picker → uploads.
- [ ] Files > 10 MB → friendly error, not a crash.
- [ ] Files of every common type (png, jpg, pdf, txt, json, zip, mp4, mp3) — upload completes and a link is created.
- [ ] Quota badge increments each successful upload; "0/5 left this session" badge turns red at 1.
- [ ] 6th upload attempt blocked with friendly error.
- [ ] Clearing localStorage resets quota.
- [ ] Recent uploads panel only renders when history > 0; chip count is accurate; expanded list scrolls if long; copy-code chip flips to check icon for 2s; external-open icon opens the Walrus URL.
- [ ] Page scrolls correctly on small viewports (this is the bug we just fixed — verify).
- [ ] After upload, success card renders all three action buttons: View, Download, Share. Each works:
  - View → opens Walrus URL in a new tab.
  - Download → file lands in Downloads folder with the correct filename and MIME type. Already-tested via the §1 download fix; re-verify after every change.
  - Share → native Web Share on supported browsers (mobile Safari, mobile Chrome); falls back to clipboard copy + "Link copied" SnackBar elsewhere.
- [ ] Copy buttons on Share link + Stats link → flip to check icon for 2s.
- [ ] QR panel scans correctly on a phone — opens `/<code>` and resolves.
- [ ] "Upload another file" button resets to idle and the recent uploads panel now includes the previous upload.

**Stats screen (`/s/:code`)**

- [ ] Valid code → renders filename, size, click count.
- [ ] Invalid / non-existent code → friendly not-found.
- [ ] Click count updates after a redirect (need to manually visit `/<code>` and refresh stats).

**Redirect (`/:code`)** *(audit current behavior; will be replaced in §3)*

- [ ] Valid code resolves to Walrus URL and opens.
- [ ] Invalid code shows the not-found screen.
- [ ] Error during resolve shows the redirect-failed screen with a usable error message.

**Cross-cutting**

- [ ] Every external link uses `LaunchMode.externalApplication` (opens in a new tab on web, not in-app).
- [ ] No `onPressed: () {}` placeholders anywhere — grep `lib/` and the diff is empty.
- [ ] Hover states on buttons are consistent (cursor changes to pointer on web).
- [ ] Keyboard: tab-through reaches every interactive element.
- [ ] All routes survive a hard refresh on Vercel (go_router + Vercel rewrites configured).

### Deliverable for §0

A single audit PR that:
- Runs the checklist above manually in Chrome + mobile Safari.
- Fixes any item that fails.
- Adds a `flutter analyze` + `flutter test` step to the build script (already partially there) and confirms green.
- Lists in the PR description every item that was checked and the outcome.

Only after §0 is done do §1+ get touched.

---

## 1. DB migration + Supabase email auth

### Schema migration

```sql
alter table links
  add column user_id uuid references auth.users(id) on delete set null;
create index links_user_id_idx on links (user_id);
```

Single column — we're skipping the wallet path, so no `owner_address` needed.

RLS update: keep the existing public-read policy on short_code resolution (any visitor must be able to open a link), and add `select where user_id = auth.uid()` for the dashboard query path. Delete policy: `delete where user_id = auth.uid()`.

### Auth itself

Supabase Auth, email magic link only. Already in `pubspec.yaml`; just need to wire it.

Files:

- **New** `lib/services/auth_service.dart` — thin `ChangeNotifier` around `Supabase.instance.client.auth`:
  - `User? currentUser`
  - `Future<void> sendMagicLink(String email)` — calls `signInWithOtp(email: ..., emailRedirectTo: '<appUrl>/auth-callback')`.
  - `Future<void> signOut()`.
  - Listens to `onAuthStateChange` and notifies.
- **New** `lib/screens/auth/auth_callback_screen.dart` — handles the magic-link redirect. Supabase Flutter takes care of parsing the URL hash; the screen just shows a spinner, waits for `onAuthStateChange`, then routes to `/dashboard` (or back to `/upload` if no return path was set).
- **New** `lib/screens/auth/sign_in_modal.dart` — a bottom-sheet / dialog with an email field, "Send magic link" button, and a friendly success state ("Check your inbox").
- `lib/app.dart`:
  - Wrap the app in an `AuthScope` `InheritedNotifier` so any screen can read the current identity.
  - Register `/auth-callback`.
- `lib/core/app_navbar.dart` — add a `_AuthButton` that shows:
  - Signed out: a "Sign in" pill that opens `SignInModal`.
  - Signed in: an avatar/initial + dropdown with Dashboard / Sign out. Truncated email under the avatar on hover.
- `lib/screens/home/home_screen.dart` — on successful upload, set `user_id` on the new row when `AuthService.currentUser != null`. Signed-out uploads continue to work and land only in the localStorage recent-uploads list.
- `lib/services/link_service.dart` — extend `createLink` to accept an optional `userId` and pass it into the insert.

Open question I'm answering up front: **uploads stay anonymous-friendly.** Gating uploads behind sign-in kills the "drop and share" hook. Signed-in uploads get the dashboard bonus; signed-out uploads work exactly as today.

---

## 2. Dashboard / My Links

Page at `/dashboard`. Lists every link owned by the current user.

- **New** `lib/screens/dashboard/dashboard_screen.dart`
  - Guard: if signed out, render a `_SignInPrompt` with a button that opens the same `SignInModal`. No redirect — the empty state explains what's behind the door.
  - Data: `LinkService.listMine()` — `select * from links where user_id = auth.uid() order by created_at desc limit 100`. Add a "Load more" button if exactly 100 returned.
  - Layout: responsive grid — 2 columns on tablet, 3+ on desktop, 1 on mobile.
  - Each card: filename + extension icon, size + MIME line, short code as a copyable chip, click count chip, created date, a kebab menu (Open file page → `/:code`, Copy link, Copy embed, Delete with confirm).
  - Empty state: friendly illustration + "Upload your first file" → `/upload`.
- `lib/services/link_service.dart` — add `listMine()`, `deleteLink(shortCode)`. RLS handles ownership; the client just calls the methods.
- `lib/app.dart` — register `/dashboard`.
- `lib/core/app_navbar.dart` — Dashboard nav link, visible only when signed in.

Click on a row → `/:code` (the new file page, see §3).

Delete UX: optimistic remove from the local list, undo SnackBar for 5s, real delete fires after the SnackBar closes. If the undo is hit, restore the card and skip the delete call.

---

## 3. File preview on file page

Restructure `/:code`. Replaces today's instant-bounce redirect.

- **Rename** `RedirectScreen` → `FilePageScreen` at `lib/screens/file/file_page_screen.dart`. Old `RedirectScreen` deleted; click-tracking logic from `resolveAndTrack` is reused (still increments on page view).
- Page layout (signed-out and signed-in both work):
  1. Filename, size, MIME, uploaded date — same `_MetaRow` style as `SuccessCard`.
  2. **Preview area** — see preview rules below.
  3. Short URL box with copy.
  4. Action buttons: View, Download (reuse the blob-fetch downloader from the previous plan), Share, Copy embed (§5).
  5. QR panel (§4).
  6. Storage status chip (§6).
  7. If the current user owns the link, a small "Owner" pill + Delete action.
- **Preview rules** — keyed off `mime_type`:
  - `image/*` → `Image.network(walrusUrl)` with a loading placeholder and a max-height cap (60vh).
  - `application/pdf` → first page via `pdfx` (web-compatible). On failure or oversize, fall back to a generic icon + "Preview unavailable, click View to open."
  - `text/*`, `application/json`, `application/xml`, `text/markdown` → fetch the first 64KB with a `Range` header, decode as UTF-8, render first ~80 lines in a monospace code block with horizontal scroll.
  - Everything else → generic file icon + filename + "Preview not available for this file type."
- **Routing migration concern.** Anyone with an existing `/:code` link expects "click → file opens." Mitigation: View is the primary, above-the-fold CTA so the path stays one click. Also support `?download=1` for power users — auto-triggers the download flow on mount.

Files:
- **New** `lib/screens/file/file_page_screen.dart`
- **New** `lib/screens/file/widgets/file_preview.dart` (the MIME switch)
- **New** `lib/screens/file/widgets/text_preview.dart` (text fetch + render)
- **New** `lib/screens/file/widgets/pdf_preview.dart` (`pdfx` wrapper)
- `lib/app.dart` — `/:code` now builds `FilePageScreen`. `/s/:code` stats page unchanged.
- `lib/services/link_service.dart` — add `fetchTextPreview(walrusUrl, maxBytes: 65536)` using `http.get` with a `Range` header.

Package add: `pdfx: ^2.x`. ~300KB to bundle; acceptable.

---

## 4. QR code on file page

Lift the existing `_QrPanel` from `SuccessCard` into a shared widget so the file page can reuse it.

- **Move** `_QrPanel` from `lib/screens/home/widgets/success_card.dart` → `lib/screens/shared/qr_panel.dart` (rename `QrPanel`, make public).
- Used by both `SuccessCard` and `FilePageScreen`. Default expanded on success, default collapsed on the file page (it's secondary there).
- Add a "Download QR" affordance: render the QR to PNG via `RepaintBoundary.toImage`, save via the existing `downloadFile` helper (filename `qr-<code>.png`). Skip "Copy QR as image" — clipboard image support is browser-spotty and not worth the complexity.

---

## 5. Embed code copy

A new share affordance on both the success card and the file page.

- **New** `lib/screens/shared/embed_snippet_box.dart` — small UI with a label ("Embed in your README"), a monospace text field showing the snippet, and a copy button. Three presets the user can switch between via a tab strip:
  - **HTML**: `<a href="$shortUrl">$fileName</a>`
  - **Markdown**: `[$fileName]($shortUrl)`
  - **Image (Markdown)** — only shown for `image/*`: `![$fileName]($walrusUrl)` — uses the Walrus URL directly so the image inlines instead of resolving through the file page.
- Add the component below the share/download row on both `SuccessCard` and `FilePageScreen`. Collapsed by default on success (already a lot going on), expanded by default on the file page (developer audience).
- Text only — no clipboard image type needed.

---

## 6. Epoch / storage status chip

Walrus stores blobs for a fixed number of epochs. The product should be honest about this on the file page.

- **New** `lib/services/walrus_status_service.dart` — `getStatus(blobId)` returns `{network: 'testnet', endEpoch, currentEpoch}`. Caches in memory for the session (epochs don't change minute-to-minute).
- **New** `lib/screens/file/widgets/storage_status_chip.dart` — small chip on the file page:
  > `🧪 Testnet · expires ~Jul 12 · epoch 142 of 145`
  Tooltip on tap: "Walrus stores files for a fixed number of epochs. After expiry, the blob is purged unless renewed."
- If `endEpoch - currentEpoch <= 1`, render in warning color.

Verify the Walrus testnet metadata endpoint shape before relying on it (the dartus SDK might have a helper; `GET https://aggregator.walrus-testnet.walrus.space/v1/blobs/{blobId}/metadata` is the likely path). If it's flaky or undocumented, ship the chip with a static "Testnet · 3 epochs" string and revisit later — don't block on it.

---

## Critical files

**Create:**
- `lib/services/auth_service.dart`
- `lib/screens/auth/auth_callback_screen.dart`
- `lib/screens/auth/sign_in_modal.dart`
- `lib/screens/dashboard/dashboard_screen.dart`
- `lib/screens/file/file_page_screen.dart` (replaces redirect screen)
- `lib/screens/file/widgets/file_preview.dart`
- `lib/screens/file/widgets/text_preview.dart`
- `lib/screens/file/widgets/pdf_preview.dart`
- `lib/screens/file/widgets/storage_status_chip.dart`
- `lib/screens/shared/qr_panel.dart` (lifted from success_card)
- `lib/screens/shared/embed_snippet_box.dart`
- `lib/services/walrus_status_service.dart`

**Modify:**
- `lib/app.dart` — auth scope, `/dashboard`, `/auth-callback`, `/:code` → file page
- `lib/core/app_navbar.dart` — auth button, Dashboard link
- `lib/services/link_service.dart` — `listMine`, `deleteLink`, `fetchTextPreview`, pass `userId` on insert
- `lib/screens/home/home_screen.dart` — pass current `userId` to `createLink`
- `lib/screens/home/widgets/success_card.dart` — use shared `QrPanel`, add `EmbedSnippetBox`
- `pubspec.yaml` — `pdfx`
- Supabase: migration for `user_id` column and RLS update

**Delete:**
- `lib/screens/redirect/redirect_screen.dart` (folded into `FilePageScreen`)
- `lib/screens/redirect/widgets/loading_view.dart` if unused after the move

---

## Shipping order (incremental PRs)

1. **§0 audit + fix pass.** No new features. Everything currently visible works end-to-end.
2. **DB migration + auth foundation.** `AuthService`, `SignInModal`, navbar auth button, auth callback. No new pages.
3. **Dashboard.** `/dashboard` reading `listMine()`. Empty + signed-out states. Delete with undo.
4. **File page restructure.** `/:code` becomes `FilePageScreen` — metadata + View/Download/Share above the fold. No preview engines yet; just the new shell with feature parity to today's redirect via the View button.
5. **Preview engines.** Image first (trivial), then text, then PDF. Each one ships independently behind the `mime_type` switch.
6. **Shared QR panel + embed snippet box.** Lifted, then reused on both success card and file page.
7. **Storage status chip.** Walrus metadata wiring + the chip on the file page.

---

## Risks / verify before starting

- **Magic-link redirect on Vercel.** Supabase needs `<appUrl>/auth-callback` whitelisted in the Supabase project Auth settings. Confirm the URL and that Vercel rewrites pass the hash through cleanly to Flutter's go_router.
- **`/:code` UX regression.** Existing bookmarked links expect "click → file opens." Mitigated by View being the primary CTA and `?download=1` shortcut, but worth shipping behind a feature flag or behind a clear "What's new" banner for the first week.
- **Walrus metadata endpoint.** May be undocumented / unstable. Ship §6 with a static chip if so; don't block.
- **Bundle size.** `pdfx` adds ~300KB. Measure before/after and confirm.

## Out of scope

- Sui wallet (dropped this phase).
- Docs / API page (dropped this phase).
- Real API behind any `/api/*` route.
- File renaming / metadata editing post-upload.
- Sharing permissions / ACLs — all files stay publicly readable; ownership only affects dashboard visibility and delete rights.
- Push/email notifications for upcoming epoch expiry.
- Sui mainnet.
