# Appomodoro - AI Agent Comparison Project

A comprehensive comparison study of different AI coding agents implementing the same Pomodoro timer application across multiple platforms and frameworks.

## 🎯 Project Overview

This repository serves as a testing ground to evaluate and document how different AI agents approach the same coding challenge: building a feature-rich Pomodoro timer with a unique dual-ring dial interface.

### Key Features of the Pomodoro App
- **Unique Dual-Ring Dial**: Two concentric rotating number rings (seconds & minutes) with fixed selector windows
- **Smooth 60fps Animation**: Continuous motion without stepping
- **Full Pomodoro Workflow**: Focus sessions, short breaks, long breaks with customizable durations
- **Modern UI/UX**: Dark/light themes, accessibility support, haptic feedback
- **Cross-Platform**: iOS (SwiftUI), Android (Kotlin), Windows (Flutter)

## 🤖 AI Agents Being Tested

### Current Implementations
- **Claude 4.5** - iOS SwiftUI implementation ✅

### Planned Implementations
- **Gemini 2.5 Pro** - iOS SwiftUI implementation 🔄
- **GPT-5 Codex** - iOS SwiftUI implementation 🔄
- **Claude 4.5** - Android Kotlin implementation 🔄
- **Gemini 2.5 Pro** - Android Kotlin implementation 🔄
- **GPT-5 Codex** - Android Kotlin implementation 🔄
- **Claude 4.5** - Windows Flutter implementation 🔄
- **Gemini 2.5 Pro** - Windows Flutter implementation 🔄
- **GPT-5 Codex** - Windows Flutter implementation 🔄

## 📁 Repository Structure

```
appomodoro/
├── README.md                    # This file
├── .gitignore                  # Monorepo-safe ignore rules
├── .gitattributes              # Git attributes for cross-platform
│
├── IOS/                        # iOS Platform Implementations
│   ├── Prompt.md              # Standardized prompt for iOS agents
│   ├── Claude45/              # Claude 4.5 implementation
│   │   └── appomodoro/        # Complete Xcode project
│   ├── Gemini25/              # Future: Gemini 2.5 Pro implementation
│   └── GPT5-Codex/            # Future: GPT-5 Codex implementation
│
├── Android-Kotlin/             # Future: Android Platform Implementations
│   ├── Prompt.md              # Standardized prompt for Android agents
│   ├── Claude45/              # Future: Claude 4.5 implementation
│   ├── Gemini25/              # Future: Gemini 2.5 Pro implementation
│   └── GPT5-Codex/            # Future: GPT-5 Codex implementation
│
└── Windows-Flutter/            # Future: Windows Platform Implementations
    ├── Prompt.md              # Standardized prompt for Flutter agents
    ├── Claude45/              # Future: Claude 4.5 implementation
    ├── Gemini25/              # Future: Gemini 2.5 Pro implementation
    └── GPT5-Codex/            # Future: GPT-5 Codex implementation
```

## 🎨 Design Specifications

### The Unique Dial Interface
The centerpiece of this project is a mechanical-style timer dial with very specific requirements:

- **Two Concentric Rings**: 
  - Outer ring (seconds): 00-59, rotates once per minute
  - Inner ring (minutes): 00-59, rotates once per hour
- **Fixed Selector Windows**: 
  - Left window shows current second
  - Right window shows current minute
- **Continuous Motion**: 60fps smooth rotation, no stepping
- **Center Display**: Large minute countdown + small second badge
- **Visual Style**: Dark/graphite theme with high contrast and customizable accent colors

## 🔧 Technical Requirements

### Build Requirements
- Each implementation must build successfully from command line
- Automated build verification scripts included
- No build errors, minimal warnings

### Git Standards
- Proper .gitignore files for each platform
- No secrets or sensitive data committed
- Consistent project structure across agents
- Complete source code tracking (no missing files)

### Performance Standards
- 60fps animation performance
- Responsive UI interactions
- Proper memory management
- Background/foreground state handling

## 📊 Evaluation Criteria

Each AI agent implementation will be evaluated on:

1. **Code Quality**
   - Architecture and design patterns
   - Code organization and structure
   - Error handling and edge cases
   - Documentation quality

2. **Feature Completeness**
   - All required Pomodoro functionality
   - UI/UX fidelity to specifications
   - Accessibility support
   - Platform-specific optimizations

3. **Technical Excellence**
   - Build system integration
   - Performance optimization
   - Testing coverage
   - Git workflow adherence

4. **Innovation & Problem Solving**
   - Creative solutions to technical challenges
   - Code efficiency and elegance
   - Handling of complex animation requirements
   - Platform-specific feature utilization

## 🚀 Current Status

### iOS Platform - Claude 4.5 Implementation ✅
- **Status**: Complete and functional
- **Key Features**: 
  - Dual-ring dial with smooth 60fps animation
  - Complete Pomodoro workflow (focus/short break/long break)
  - Customizable settings and themes
  - Notifications and haptic feedback
  - Terminal build verification
- **Tech Stack**: Swift 6.2, iOS 17+, SwiftUI, Combine
- **Build Status**: ✅ Passes `xcodebuild` verification

## 📋 Getting Started

### For iOS Development
1. Navigate to `IOS/Claude45/appomodoro/`
2. Open `appomodoro.xcodeproj` in Xcode
3. Build and run on iOS Simulator or device
4. Or use terminal: `./build_and_verify.sh`

### For Future Implementations
Each platform folder contains a detailed `Prompt.md` with specific requirements and guidelines for AI agents.

## 🤝 Contributing

This project serves as a research and comparison tool. Each AI agent implementation should:

1. Follow the standardized prompt for their platform
2. Maintain the same feature set and design specifications
3. Include proper documentation and build scripts
4. Ensure Git repository hygiene

## 📄 License

This project is open source and available under the MIT License.

## 🔍 Research Goals

This project aims to provide insights into:
- How different AI agents approach the same complex UI challenge
- Code quality and architecture differences between AI systems
- Platform-specific implementation strategies
- Evolution of AI coding capabilities over time

---

**Note**: This is an active research project. Implementation details and comparisons will be updated as new AI agent implementations are completed.