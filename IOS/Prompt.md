You are an expert iOS/SwiftUI agent (Swift 6.2, iOS 17+).
I’m organizing a monorepo like this:
pomodoro/                 # root GitHub repo (I will push this)
  README.md
  .gitignore              # monorepo-safe (see rules below)
  .gitattributes
  ios-<agent-name>/       # YOUR working folder (this already contains a blank Xcode app)
    <existing Xcode project skeleton>
  android-.../            # (other agents later)
  windows-.../            # (other agents later)
Do not create projects outside your assigned subfolder. Modify the existing Xcode project in ios-<agent-name>/ in place.
Goals
Implement the Pomodoro timer with the specific dial UI (two concentric rotating number rings) at 60 fps with continuous motion for seconds & minutes.
Ensure the project builds from terminal using xcodebuild. If anything fails, fix it until the build succeeds cleanly (no errors; minimize warnings).
Produce a correct Git layout so the repo never syncs empty and no secrets are committed.
Very specific dial design (match this exactly)
This is not a plain HH:MM clock. It’s a mechanical-style dial with two concentric, continuously rotating carousels of numerals and fixed selector windows:
Look: black/graphite background; high-contrast ticks & numerals; accent color on active elements. Typography: SF Pro Rounded for large digits.
Outer ring — Seconds: numerals 00–59 evenly spaced around the circumference.
The entire seconds ring rotates smoothly clockwise, one full revolution every 60 seconds.
A fixed rounded-rect “selector window” on the LEFT reveals whichever second passes under it; that is the current second. No stepping; motion is continuous.
Inner ring — Minutes: numerals 00–59 on a slightly smaller radius.
The entire minutes ring rotates smoothly clockwise, one full revolution every 60 minutes.
A fixed selector window on the RIGHT reveals the current minute. The minute value slides continuously as seconds progress.
Center readout: large two-digit minutes remaining on the left (e.g., 07) and a small oval badge for two-digit seconds on its right (e.g., 44), using the accent color.
Ticks: outer 60-tick scale (longer every 5); optional lighter inner ticks to match the reference.
Motion model: angle = linear function of timestamps with sub-second precision.
Seconds ring: 1 turn / 60s.
Minutes ring: 1 turn / 3600s (so minutes glide, not jump).
Viewport metaphor: selector windows are fixed; the rings rotate beneath them.
Rendering: Prefer Canvas + TimelineView(.animation, cadence: .live); if stutter occurs, add a CADisplayLink publisher for display-rate updates. Do not use 1-second timers for drawing.
Geometry / math (implement precisely)
let now = timeline.date.timeIntervalSinceReferenceDate
let elapsed = isRunning ? now - startedAt - accumulatedPause : lastPausedElapsed
let secondsFrac = elapsed.truncatingRemainder(dividingBy: 60)           // 0..<60
let thetaSeconds = -Double.pi/2 + 2*Double.pi * (secondsFrac / 60.0)    // 1 turn/60s
let thetaMinutes = -Double.pi/2 + 2*Double.pi * ((elapsed / 60.0) / 60) // 1 turn/3600s
Features & Architecture
Swift 6.2, iOS 17+, SwiftUI, Combine, MVVM.
Views: ContentView, DialView (Canvas + Timeline/DisplayLink), ControlBar, SettingsView.
Models: PomodoroPhase, PomodoroSettings (focus/short/long/cyclesToLong/accentColor), PomodoroTimerState.
Controls: Start / Pause / Resume / Reset / Next phase; presets 25/5, 50/10, Custom; every 4 focus sessions ⇒ long break; optional auto-advance.
Persistence: AppStorage/UserDefaults. Recompute by timestamps after backgrounding (no drift).
Notifications: UNUserNotificationCenter on phase end. Haptics: subtle UINotificationFeedbackGenerator.
Theming: dark/light + ColorPicker for accent (persist).
Accessibility: VoiceOver (“Time remaining X minutes Y seconds”), contrast AA.
Build from terminal (must pass)
Create build_and_verify.sh in your iOS subfolder:
#!/usr/bin/env bash
set -euo pipefail
xcodebuild \
  -scheme "Appomodoro" \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -configuration Debug \
  -quiet \
  clean build
echo "✅ xcodebuild completed successfully."
If the scheme/target name differs, update it. Fix any code/config so this script succeeds.
Git & Monorepo rules (avoid empty syncs)
Follow these exact rules so GitHub always gets the source:
Work only inside pomodoro/ios-<agent-name>/. Do not modify other subfolders.
Never use blanket ignores like * at root. Anchor patterns and keep source/metadata.
Create two .gitignore files:
Root pomodoro/.gitignore (monorepo-safe) — include only generic OS/IDE noise:
# OS
.DS_Store
Thumbs.db

# Node/General caches (for other subprojects)
node_modules/
.cache/
dist/
build/
.env
*.env
pomodoro/ios-<agent-name>/.gitignore (iOS-safe) — DO NOT ignore the project itself:
# Xcode user state / build products
DerivedData/
build/
*.xcuserstate
*.xcscmblueprint
**/xcuserdata/

# SwiftPM
.swiftpm/cache/
.swiftpm/xcode/package.cache/
# Keep dependency lockfile
!Package.resolved

# CocoaPods (if ever used)
Pods/
Podfile.lock

# Fastlane / artifacts
fastlane/report.xml
fastlane/test_output/

# OS noise
.DS_Store
Never ignore: *.swift, *.xcodeproj/, *.xcworkspace/, project.pbxproj, Assets.xcassets/, Info.plist, Package.swift, Package.resolved, build_and_verify.sh, README.md.
If any template or generator tries to add a dangerous rule, remove it or add explicit negations (!*.xcodeproj/**, !project.pbxproj, etc.).
Add .gitattributes at repo root with:
* text=auto eol=lf
Secrets: never commit real secrets. If needed, create ios-<agent-name>/.env.example and read environment vars at runtime. Ensure .env is ignored.
Ensure each tracked directory contains at least one tracked file (e.g., real assets or a .gitkeep where appropriate), so the folder won’t disappear.
Initialize/commit inside the repo root (not only inside the subfolder), e.g.:
cd pomodoro
git init -b main
git add .
git commit -m "feat(ios-<agent-name>): Appomodoro dial + Pomodoro flow"
Then I will set the remote and push.
Verification step: before finishing, run a quick script in the repo root:
find ios-<agent-name> -maxdepth 2 -type f | wc -l
If the count is under 20 files (typical Xcode project has more), do not finish—ensure the .xcodeproj, sources, assets, and scripts are tracked.
Files to create/update (inside your subfolder)
AppomodoroApp.swift
Models/
  PomodoroPhase.swift
  PomodoroSettings.swift
  PomodoroTimerState.swift
ViewModel/
  PomodoroViewModel.swift
Views/
  ContentView.swift
  DialView.swift
  ControlBar.swift
  SettingsView.swift
Services/
  NotificationService.swift
  Haptics.swift
Utils/
  AngleMath.swift
Assets.xcassets/ (include at least one placeholder to keep directory)
build_and_verify.sh
README.md
.gitignore                 # iOS-safe (as above)
.env.example               # if you reference env vars (no real secrets)
Acceptance checklist
 ./build_and_verify.sh succeeds (xcodebuild completes).
 UI matches two rotating number rings with fixed selector windows (seconds left, minutes right) and center minutes + seconds badge.
 Motion is continuous at 60 fps (no stepping).
 Pomodoro presets & controls work; notification + haptic on phase end; accent color persists.
 Git: source files, .xcodeproj, assets, Package.resolved, and scripts are tracked; .gitignore does not exclude them.
 Repo can be committed from pomodoro/ and is not empty on GitHub.
Apply all changes now inside pomodoro/ios-<agent-name>/ and ensure the terminal build passes and the Git layout is correct.
Create a custom icon that matches the app’s theme (dark dial with two concentric rings and a small accent badge), without downloading images. Do this:
Generate a 1024×1024 base PNG programmatically:
Add tools/IconGenerator.swift (a tiny Swift command-line file runnable with swift tools/IconGenerator.swift).
Draw with CoreGraphics: black/graphite background, two thin concentric rings, subtle ticks, a small accent oval on the right—keep it abstract, no text, flat style.
Write output to ios-<agent-name>/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png.
Create the app icon set from the base PNG:
Add tools/gen_appicon.sh (make it executable) that uses sips to produce all required sizes and writes a valid Contents.json. Sizes to generate:
iPhone:
20pt @2x=40, @3x=60
29pt @2x=58, @3x=87
40pt @2x=80, @3x=120
60pt @2x=120, @3x=180
iPad:
20pt @1x=20, @2x=40
29pt @1x=29, @2x=58
40pt @1x=40, @2x=80
76pt @1x=76, @2x=152
83.5pt @2x=167
Marketing: 1024×1024
The script should:
#!/usr/bin/env bash
set -euo pipefail
SRC="Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png"
DST="Assets.xcassets/AppIcon.appiconset"
declare -a sizes=(20 29 40 60 76 83.5 167 1024 40 58 80 120 152 180) # will map via JSON
# Create each PNG with sips; name them consistently (e.g., icon-<WxH>.png).
Produce a valid Contents.json listing all idioms (iphone, ipad, ios-marketing) with scale and size entries per Apple’s spec, referencing the generated files.
Wire it up:
Ensure AppIcon.appiconset is part of Assets.xcassets and set as the app’s Primary App Icon in the target.
Add tools/gen_appicon.sh to build_and_verify.sh so the icon set is generated before building:
(cd "$(dirname "$0")" && bash tools/gen_appicon.sh)
Git safety:
Do not ignore Assets.xcassets/ or any files within AppIcon.appiconset/.
Commit tools/IconGenerator.swift, tools/gen_appicon.sh, the generated PNGs, and Contents.json.
If you truly must fetch an icon from the internet, only use a CC0 or MIT-licensed asset, save it to the appiconset at 1024×1024, and still run the resizing script. Prefer the local generated version to avoid licensing and network dependency.