# Example 03: App Store Assets Guide

## Creating Professional Store Listing Assets

This guide shows you how to create all the visual assets needed for both app stores.

---

## Asset Overview

```
┌─────────────────────────────────────────────────────────────┐
│              REQUIRED ASSETS SUMMARY                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  BOTH STORES:                                                │
│  ├── App Icon                                               │
│  ├── Screenshots                                            │
│  └── Privacy Policy URL                                     │
│                                                              │
│  GOOGLE PLAY ONLY:                                           │
│  └── Feature Graphic (1024 x 500)                           │
│                                                              │
│  OPTIONAL BUT RECOMMENDED:                                   │
│  ├── App Preview Video                                      │
│  └── Promotional Graphics                                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## App Icon Creation

### Icon Specifications

```
GOOGLE PLAY:
├── Size: 512 x 512 px
├── Format: 32-bit PNG
├── Color space: sRGB
└── Max file size: 1 MB

APPLE APP STORE:
├── Size: 1024 x 1024 px
├── Format: PNG (no alpha/transparency!)
├── Color space: sRGB or P3
└── No rounded corners (iOS adds them)
```

### Icon Design Tips

```
GOOD ICON DESIGN:

┌─────────────────────────┐
│                         │
│    ┌───────────────┐    │
│    │               │    │
│    │      ✓        │    │   Simple, bold shape
│    │               │    │   One main element
│    │               │    │   Works at 16x16
│    └───────────────┘    │
│                         │
└─────────────────────────┘

DO:
✅ Use simple shapes
✅ Make it recognizable at small sizes
✅ Use your brand colors
✅ Create unique silhouette

DON'T:
❌ Add text (hard to read when small)
❌ Use photos (too detailed)
❌ Copy other apps
❌ Use transparent background (iOS)
```

### Using flutter_launcher_icons

```yaml
# pubspec.yaml

dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"

  # iOS specific (no transparency allowed)
  remove_alpha_ios: true

  # Android adaptive icon (Android 8+)
  adaptive_icon_background: "#2196F3"
  adaptive_icon_foreground: "assets/icon/foreground.png"

  # Web favicon
  web:
    generate: true
    image_path: "assets/icon/app_icon.png"

  # Windows
  windows:
    generate: true
    image_path: "assets/icon/app_icon.png"

  # macOS
  macos:
    generate: true
    image_path: "assets/icon/app_icon.png"
```

```bash
# Generate all icons
flutter pub run flutter_launcher_icons
```

---

## Screenshot Creation

### Screenshot Sizes

```
GOOGLE PLAY SCREENSHOT SIZES:

Phone (Required):
├── Minimum: 320 px
├── Maximum: 3840 px
├── Aspect ratio: 16:9 or 9:16
└── Recommended: 1080 x 1920 px (portrait)

7-inch Tablet (If supporting):
└── 1200 x 1920 px

10-inch Tablet (If supporting):
└── 1800 x 2560 px


APPLE APP STORE SCREENSHOT SIZES:

iPhone:
├── 6.7" (iPhone 15 Pro Max): 1290 x 2796 px
├── 6.5" (iPhone 14 Plus): 1284 x 2778 px
├── 5.5" (iPhone 8 Plus): 1242 x 2208 px
└── 5.8" (iPhone X/XS): 1125 x 2436 px

iPad:
├── 12.9" iPad Pro: 2048 x 2732 px
└── 11" iPad Pro: 1668 x 2388 px
```

### Screenshot Best Practices

```
SCREENSHOT STRUCTURE:

┌────────────────────────────┐
│                            │
│  "Track Your Goals"        │  ← Headline (what it does)
│                            │
│   ┌──────────────────┐     │
│   │                  │     │
│   │   Device Frame   │     │  ← App screenshot in frame
│   │   with App       │     │
│   │   Screenshot     │     │
│   │                  │     │
│   └──────────────────┘     │
│                            │
│  Simple background color   │
│                            │
└────────────────────────────┘

TIPS:
1. First 2 screenshots are most important
2. Show best features, not splash screen
3. Add context text above/below device
4. Use consistent style across all screenshots
5. Show real content, not lorem ipsum
```

### Screenshot Sequence

```
RECOMMENDED SCREENSHOT ORDER:

Screenshot 1: "Welcome to [App]"
└── Main screen / Hero feature

Screenshot 2: "Easy to Use"
└── Key feature #1

Screenshot 3: "Stay Organized"
└── Key feature #2

Screenshot 4: "Beautiful Design"
└── Settings or customization

Screenshot 5: "Works Everywhere"
└── Sync or multi-platform

Screenshot 6-8: Additional features
└── Other notable features
```

### Free Tools for Screenshots

```
SCREENSHOT TOOLS:

Device Frames:
├── Previewed (previewed.app)
├── Mockuphone (mockuphone.com)
├── AppMockUp (app-mockup.com)
└── Screenshots.pro

Design Tools:
├── Figma (free tier available)
├── Canva (free tier available)
├── GIMP (free)
└── Photoshop (paid)

Screenshot Generators:
├── LaunchMatic
├── AppLaunchpad
└── Hotpot.ai
```

---

## Feature Graphic (Android Only)

### Specifications

```
FEATURE GRAPHIC:

Size: 1024 x 500 px
Format: PNG or JPEG
Shown at top of Play Store listing

┌──────────────────────────────────────────────────────────────┐
│                                                              │
│     [Your Logo]    "Your Tagline Here"     [App Preview]    │
│                                                              │
│              Background: Brand color                         │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Feature Graphic Tips

```
DO:
✅ Use brand colors
✅ Include app name or logo
✅ Show the app in action
✅ Keep text large and readable
✅ Make it eye-catching

DON'T:
❌ Crowd with too much info
❌ Use small text
❌ Make it look like an ad
❌ Use misleading imagery
```

### Feature Graphic Examples

```
STYLE 1: App Focus
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│                         ┌──────┐                             │
│    "Task Manager        │ 📱   │                             │
│     Made Simple"        │      │                             │
│                         └──────┘                             │
│                                                              │
└──────────────────────────────────────────────────────────────┘

STYLE 2: Illustration
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│   ┌────┐  ┌────┐  ┌────┐                                    │
│   │ ✓  │  │ ✓  │  │ ○  │     "Get Things Done"              │
│   └────┘  └────┘  └────┘                                    │
│                                                              │
└──────────────────────────────────────────────────────────────┘

STYLE 3: Minimal
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│                                                              │
│             [App Icon]   TaskFlow                            │
│                                                              │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## App Preview Video (Optional)

### Video Specifications

```
GOOGLE PLAY:
├── YouTube video link
├── Any length (keep it under 2 minutes)
└── Landscape or portrait

APPLE APP STORE:
├── Device recording or animation
├── 15-30 seconds
├── Must match device dimensions:
│   ├── 6.7": 886 x 1920 or 1920 x 886
│   ├── 6.5": 886 x 1920 or 1920 x 886
│   └── iPad: varies by size
└── No hands shown, just the screen
```

### Video Content Tips

```
APP PREVIEW STRUCTURE:

0-5 sec:  Opening / Hook
          "Organize your life with TaskFlow"

5-15 sec: Main Feature Demo
          Show the core functionality

15-25 sec: Additional Features
           Quick tour of other features

25-30 sec: Call to Action
           "Download now"

TIPS:
✅ Show real usage, not marketing fluff
✅ Highlight unique features
✅ Keep it fast-paced
✅ Add subtle background music
❌ Don't include audio narration (App Store)
❌ Don't show things not in the app
```

---

## Privacy Policy

### What to Include

```
PRIVACY POLICY SECTIONS:

1. INTRODUCTION
   What this policy covers

2. INFORMATION WE COLLECT
   ├── Personal info (name, email)
   ├── Usage data (how you use app)
   ├── Device info (model, OS)
   └── Location (if applicable)

3. HOW WE USE INFORMATION
   ├── To provide the service
   ├── To improve the app
   └── To communicate with you

4. INFORMATION SHARING
   ├── With whom we share
   └── Third-party services used

5. DATA SECURITY
   How we protect your data

6. YOUR RIGHTS
   ├── Access your data
   ├── Delete your data
   └── Opt-out options

7. CHILDREN'S PRIVACY
   COPPA compliance if applicable

8. CHANGES TO POLICY
   How we notify of changes

9. CONTACT US
   How to reach you
```

### Free Privacy Policy Tools

```
GENERATE A PRIVACY POLICY:

Free:
├── Termly.io (limited free tier)
├── FreePrivacyPolicy.com
├── PrivacyPolicies.com
└── Iubenda.com (limited free)

Note: These provide templates.
Review and customize for your specific app.
```

### Hosting Your Privacy Policy

```
OPTIONS:

1. YOUR WEBSITE
   yourapp.com/privacy

2. GITHUB PAGES (Free)
   ├── Create repo: yourapp-privacy
   ├── Add index.html with policy
   └── Enable GitHub Pages

3. GOOGLE SITES (Free)
   ├── Create site
   ├── Add privacy policy page
   └── Publish

4. NOTION (Free)
   ├── Create page
   └── Share publicly

URL MUST:
✅ Be accessible without login
✅ Not have broken links
✅ Be mobile-friendly
✅ Load quickly
```

---

## Asset Checklist

```
COMPLETE ASSET CHECKLIST:

APP ICON:
□ Source file (1024x1024 or larger)
□ Android: 512x512 for Play Store
□ iOS: 1024x1024 (no transparency)
□ Generated all size variants

SCREENSHOTS:
□ Phone screenshots (minimum 2)
□ Tablet screenshots (if supporting)
□ Device frames applied
□ Context text added
□ All required sizes for iOS

FEATURE GRAPHIC (Android):
□ 1024 x 500 px
□ Brand colors
□ App name visible

VIDEO (Optional):
□ 15-30 seconds
□ Correct dimensions
□ No restricted content

PRIVACY POLICY:
□ Written and complete
□ Hosted and accessible
□ URL tested

TEXT CONTENT:
□ App name finalized
□ Short description (80 chars)
□ Full description (4000 chars)
□ Keywords researched
□ What's New text
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              APP STORE ASSETS SUMMARY                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ICONS:                                                      │
│  ├── Create 1024x1024 master icon                           │
│  ├── Use flutter_launcher_icons to generate                 │
│  └── Ensure no transparency for iOS                         │
│                                                              │
│  SCREENSHOTS:                                                │
│  ├── Create for all required device sizes                   │
│  ├── Add device frames and context text                     │
│  ├── Show best features first                               │
│  └── Minimum 2, recommend 5-8                               │
│                                                              │
│  FEATURE GRAPHIC (Android):                                  │
│  ├── 1024 x 500 px                                          │
│  └── Brand-focused with app preview                         │
│                                                              │
│  PRIVACY POLICY:                                             │
│  ├── Required for both stores                               │
│  ├── Host on accessible URL                                 │
│  └── Covers data collection practices                       │
│                                                              │
│  TOOLS:                                                      │
│  ├── Figma/Canva for design                                 │
│  ├── Mockuphone for device frames                           │
│  └── Termly for privacy policy                              │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```
