# Quit Quest

A simple SwiftUI iPhone app for quitting habits such as smoking or drinking. Each habit counts the days since you last did it, and you earn stickers at milestones along the way.

## Features

- **Streak counters.** Track as many habits as you like. Each one shows the days since your last slip, a live days/hours/minutes/seconds counter, and a progress ring toward the next milestone.
- **Stickers and achievements.** These unlock at 1 day, 3 days, 1 week, 15 days, 1 month, 2 months, 3 months, 6 months, 9 months, 1 year, 2 years and 5 years. A confetti celebration plays when you reach one.
- **Sticker Book tab.** Shows every sticker you've collected. Stickers stay in the book even if you reset a streak.
- **"I slipped up" reset.** Starts a fresh streak but keeps your best streak and reset count.
- **Quick-start presets** for Smoking, Vaping, Drinking, Sugar, Caffeine, Social Media, Fast Food and Gambling. You can also set the start date in the past if you've already stopped.
- **Local notifications** when you reach an upcoming milestone.
- All data stays on the device (SwiftData). No accounts and no third-party dependencies.

## Requirements

- A Mac with **Xcode 16 or later**, because the project uses folder-synchronized groups.
- iOS 17 or later, iPhone only.
- To upload to the App Store: Xcode 26 or later.

## Run it

1. Open `HabitTracker.xcodeproj` in Xcode.
2. Pick an iPhone simulator and press **Run** (⌘R).

To install it on your own iPhone:

1. Select the **HabitTracker** target, open **Signing & Capabilities**, and pick your Apple ID team.
2. The bundle identifier is `com.namivivi.QuitQuest`. If you're building under a different Apple account, change it to something unique.
3. Plug in your phone and run.

A free Apple ID works, but the app must be re-installed every 7 days. See Apple's guide: [Running your app in Simulator or on a device](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device).

## Project layout

```
HabitTracker/
  HabitTrackerApp.swift         App entry, SwiftData container
  ContentView.swift             Tabs, milestone checks, celebration queue
  Models/Habit.swift            Streak data and logic (reset, milestones)
  Models/Milestone.swift        Milestone and sticker definitions (edit to change rewards)
  Models/HabitPreset.swift      Quick-start presets and emoji choices
  Services/NotificationScheduler.swift
  Views/                        List, detail, add/edit form, sticker book, celebration
HabitTracker-Info.plist         Extra Info.plist keys merged with Xcode's generated ones
docs/                           Website, privacy policy and support pages (GitHub Pages)
AppStore/listing.md             App Store Connect listing text, ready to copy
```

A "day" means a full 24 hours since the time you set as your last slip, and "1 month" means 30 days.

## App Store

- **Name:** Quit Quest. **Bundle ID:** `com.namivivi.QuitQuest`.
- **Encryption:** `ITSAppUsesNonExemptEncryption` is `NO`, so uploads skip the export compliance question.
- **Privacy:** the app collects no data. In App Store Connect, choose "Data Not Collected".
- **Listing text:** [`AppStore/listing.md`](AppStore/listing.md) has the subtitle, description, keywords, review notes and age-rating answers.
- **Web pages:** `docs/` holds the privacy policy (`privacy.html`) and support page (`support.html`). To publish them, turn on GitHub Pages for the `main` branch's `/docs` folder.
