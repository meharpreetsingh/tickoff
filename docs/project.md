# Habit Tracker App — Project Prompt

## App Description

A minimal, streak-focused habit tracker with a built-in micro-journal. Users create daily habits, tap to complete them, grow visual streaks, and optionally log notes/photos per habit entry. The app prioritizes zero-friction daily check-ins over feature bloat — the entire daily flow should take under 30 seconds. No account required to start; cloud backup is opt-in.

---

## Core Features

**Habit Management** — Create, edit, reorder, archive, and delete habits. Each habit has a name, icon, color, category, and a schedule (daily, specific weekdays, or custom frequency like "3x per week"). Habits can be paused without breaking streak history.

**Daily Tracking** — Single tap to mark a habit complete for today. Long-press or swipe to undo. Visual feedback on completion (confetti, haptic, sound — all toggleable).

**Streaks** — Auto-calculated current streak and best streak per habit. Streak freezes (1 free miss without breaking streak, configurable). Milestone badges at 7, 21, 30, 60, 90, 100, 200, 365 days.

**Two Home Views** — Streak View (card grid showing each habit's streak count with a radial/circular progress indicator) and List View (compact checklist sorted by category or custom order). User picks default; swipeable between them.

**Agenda View** — Shows only habits due today, filterable by all/due/completed.

**Journey Journal** — Per-habit micro-journal. After completing a habit, optionally add a short note and/or photo. Entries displayed in a vertical timeline per habit.

**Analytics** — Per-habit: weekly/monthly completion rate, streak history chart, year-in-pixels grid (GitHub-style contribution graph). Global: overall habit score (% of due habits completed today/this week/this month).

**Categories** — User-created categories (e.g., Health, Work, Learning) to group habits. Filterable on home screen.

**Reminders** — Per-habit local notifications at user-set times. Option for a single daily reminder ("Time to check your habits").

**Widgets** — 3 styles: today's checklist, streak overview, single-habit streak counter. Tappable to mark complete without opening the app.

**Cloud Backup** — Automatic backup of all habits, streaks, journal entries, and settings. Restore on new device. No account needed for local-only use; account required only for backup/sync.

**Themes** — Light mode and dark mode. Accent color picker for personalization.

**Wrapped/Year in Review** — Annual summary showing total completions, longest streaks, most consistent habit, journal highlights.

---

## Screens & Navigation

### Bottom Navigation (3-4 tabs)

1. **Home** (Streak View / List View toggle)
2. **Timeline** (global journal feed, chronological)
3. **Analytics** (stats dashboard)
4. **Settings**

### Screen Breakdown

**Home Screen** — Date selector (horizontal scrollable week strip at top, today highlighted). Below it: habits for selected date in chosen view mode. FAB to add new habit. Empty state for new users with onboarding prompt.

**Add/Edit Habit Sheet** — Bottom sheet or full screen. Fields: name, icon picker, color picker, category (dropdown + create new), schedule (daily / specific days / X times per week), reminder toggle + time picker, notes placeholder. Save/Cancel.

**Habit Detail Screen** — Opened by tapping a habit. Shows: current streak, best streak, year grid, weekly bar chart, completion rate, full journal timeline for this habit. Edit button. Archive button.

**Journal Entry Sheet** — Triggered after marking complete (optional). Text input + camera/gallery image picker. Save or skip.

**Timeline Screen** — Reverse-chronological feed of all journal entries across all habits. Each card shows: habit name, date, note text, photo thumbnail. Tappable to expand. Option to hide streak-only entries (entries with no note/photo).

**Analytics Screen** — Top section: today's score, this week's score, this month's score. Below: per-habit cards with mini streak chart and completion %. Tap any card to go to Habit Detail.

**Settings Screen** — General: theme (light/dark/system), accent color, week start day (Mon/Sun), sound & haptic toggles. Data: cloud backup toggle, export data (JSON/CSV), import data, delete all data. About: version, feedback link, rate app, privacy policy.

**Onboarding (first launch only)** — 2-3 swipeable intro cards explaining the core loop: create → track → streak. Skip button. No sign-up gate.

---

## Key Flows

**First Launch** → Onboarding cards → Home (empty state) → Tap "Add your first habit" → Add Habit Sheet → Save → Habit appears on Home → Tap to complete → Confetti → Optional journal entry → Done.

**Daily Check-in** → Open app → Home shows today's habits → Tap each to complete → Optional journal entries → Close app. Total time: <30 seconds.

**Reviewing Progress** → Tap habit → Habit Detail with streak, charts, journal timeline → Scroll journal → Tap entry to expand photo.

**Restoring Data** → Settings → Cloud Backup → Sign in → Restore → All data populated.

**Archiving a Habit** → Habit Detail → Archive → Habit moves to "Archived" section in Settings → Can be restored anytime with streak history intact.

---

## Edge Cases to Handle

**Streak Logic**

- Timezone changes (travel): anchor streak calculation to the user's current local date, not UTC. If a user crosses a timezone boundary, they shouldn't lose a streak because the server clock disagrees.
- Missed day at 11:59 PM vs 12:01 AM: use device local midnight as the cutoff. No grace period unless streak freeze is enabled.
- Streak freeze: if enabled, auto-consume one freeze per missed day. Show "freeze used" indicator on that day. Limit freezes (e.g., 1 per week or user-configurable).
- Habit created mid-day: the creation day counts as Day 0. Streak starts when they first complete it. Don't penalize for the creation day if not completed.
- Habit schedule changes: if a user changes from "daily" to "Mon/Wed/Fri", recalculate streak based on new schedule going forward. Don't retroactively break the streak for past non-scheduled days.
- Paused habits: pausing should freeze the streak counter, not break it. Unpausing resumes from where it left off. Paused days don't count as missed.

**Date & Time**

- Date selector should prevent marking habits complete for future dates.
- Back-dating: decide on a policy and enforce it. Either allow marking past days (within 1-2 day window) or hard-block it. Users have strong opinions on both — make it a setting if possible.
- Week start day (Mon vs Sun) must consistently reflect in: home date strip, analytics charts, widgets, and the schedule picker.

**Data Integrity**

- Offline-first: all tracking must work with zero connectivity. Queue cloud backup writes and sync when online.
- Conflict resolution on restore: if local and cloud data diverge (e.g., user tracks on two devices), use last-write-wins per habit per day, or prompt the user.
- Deleting a habit: confirm with dialog. Offer "archive instead?" option. If deleted, journal entries and streak data are gone. Make this clear.
- Export/import: handle malformed import files gracefully. Validate schema before applying.

**Journal**

- Large photos: compress/resize before storing (both local and cloud). Set a max file size.
- Empty journal entries: don't save entries with no text and no photo.
- Journal entry for a non-completed habit: disallow. Journal entries are tied to completion events.
- Editing past journal entries: allow text edits, allow photo removal, but don't allow adding a photo to an old entry (prevents backdating fake entries).

**Widgets**

- Widget must stay in sync with app state. If a user completes via widget, the app must reflect it immediately on next open (and vice versa).
- Widget tap to complete should trigger the same streak/completion logic as in-app. Don't bypass validation.
- Handle widget rendering when there are 0 habits, 1 habit, or 20+ habits gracefully.

**Notifications**

- If a habit is already completed for today, suppress its reminder.
- If the user hasn't opened the app in 3+ days, send a gentle "we miss you" nudge (if opted in). Don't spam.
- Respect system-level notification permissions. Handle the "denied" state with an in-app prompt explaining why notifications help.

**UI/UX**

- Empty states for: no habits, no journal entries, no analytics data, no search results (in timeline).
- Rapid tapping: debounce the completion toggle to prevent double-firing.
- Reordering habits: drag-and-drop must persist order to storage immediately, not just in memory.
- Category deletion: if a category is deleted, habits in it become "uncategorized" — don't delete the habits.
- Very long habit names: truncate with ellipsis in cards/list, show full name in detail screen.
- Color accessibility: ensure streak colors and completion indicators are distinguishable in both light and dark mode, and for colorblind users (don't rely on red/green alone).

**Backup & Auth**

- Cloud backup toggle off → clearly communicate that data is local-only and a phone reset means data loss.
- Account deletion: must delete all cloud data. Comply with app store requirements for account deletion flows.
- Session expiry: handle gracefully. Don't block local functionality if the auth token expires.
- First backup on a fresh account with 6 months of local data: handle large initial sync without freezing the UI. Show progress.

**Platform-Specific**

- iOS: handle app tracking transparency if using any analytics. Review guidelines for subscription/IAP if monetizing.
- Android: handle battery optimization killing background notification service. Guide users to whitelist the app if reminders stop working.
- Both: handle app updates that change the local DB schema — write migrations, never drop tables.
