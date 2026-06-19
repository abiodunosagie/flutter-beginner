# Store Listings

## The Big Idea In One Sentence

> A store listing is your app's shop window: the name, icon, screenshots, and description that convince people to download, so it deserves real care, not an afterthought.

## The Simple Explanation

Your store listing is like a movie poster and trailer combined. It's the first thing users see, and it determines whether they download your app. Make it count!

```
┌─────────────────────────────────────────────────────────────┐
│                  STORE LISTING ELEMENTS                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────────────────────────────────────┐        │
│  │  [App Icon]  APP NAME                           │        │
│  │              ★★★★☆ (4.5)  10K+ downloads        │        │
│  │                                                  │        │
│  │  [Screenshot 1] [Screenshot 2] [Screenshot 3]   │        │
│  │                                                  │        │
│  │  Short description that appears                 │        │
│  │  at the top of the listing...                   │        │
│  │                                                  │        │
│  │  Full description with features,                │        │
│  │  benefits, and what makes your                  │        │
│  │  app special...                                 │        │
│  │                                                  │        │
│  │  [INSTALL] button                               │        │
│  └─────────────────────────────────────────────────┘        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## App Icon Requirements

### Design Guidelines

```
GOOD APP ICONS:

✅ Simple and recognizable
✅ Works at tiny sizes (16x16)
✅ Unique shape or color
✅ Consistent with brand
✅ No text (usually)

BAD APP ICONS:

❌ Too much detail
❌ Text that's hard to read
❌ Generic/stock images
❌ Looks like another app
❌ Transparent background (iOS)
```

### Size Requirements

```
ANDROID ICON SIZES:
├── Google Play Store: 512 x 512 px
├── mipmap-xxxhdpi: 192 x 192 px
├── mipmap-xxhdpi: 144 x 144 px
├── mipmap-xhdpi: 96 x 96 px
├── mipmap-hdpi: 72 x 72 px
└── mipmap-mdpi: 48 x 48 px

iOS ICON SIZES:
├── App Store: 1024 x 1024 px
├── iPhone @3x: 180 x 180 px
├── iPhone @2x: 120 x 120 px
├── iPad Pro: 167 x 167 px
├── iPad: 152 x 152 px
└── Settings: 87 x 87 px, 58 x 58 px, 29 x 29 px

TIP: Create one 1024x1024 icon, then use
     flutter_launcher_icons to generate all sizes!
```

---

## Screenshots

### Screenshot Requirements

```
GOOGLE PLAY:
├── Minimum: 2 screenshots
├── Maximum: 8 screenshots
├── Phone screenshots
├── 7-inch tablet screenshots (optional)
└── 10-inch tablet screenshots (optional)

Sizes:
├── Phone: 1080 x 1920 px (or similar)
├── 7-inch: 1200 x 1920 px
└── 10-inch: 1800 x 2560 px

APPLE APP STORE:
├── 6.7" (iPhone 15 Pro Max): 1290 x 2796 px
├── 6.5" (iPhone 14 Plus): 1284 x 2778 px
├── 5.5" (iPhone 8 Plus): 1242 x 2208 px
├── 12.9" iPad Pro: 2048 x 2732 px
└── Various other sizes...

TIP: App Store Connect shows exactly what sizes you need
     based on which devices you support.
```

### Screenshot Best Practices

```
┌─────────────────────────────────────────────────────────────┐
│               SCREENSHOT STRATEGY                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  WHAT MAKES GREAT SCREENSHOTS:                               │
│                                                              │
│  1. SHOW THE BEST FEATURES FIRST                            │
│     └── First 2 screenshots matter most                     │
│                                                              │
│  2. ADD CONTEXT TEXT                                         │
│     └── "Track your habits"                                 │
│     └── "Beautiful charts"                                  │
│     └── "Sync across devices"                               │
│                                                              │
│  3. USE DEVICE FRAMES                                        │
│     └── Shows app in context                                │
│     └── Looks more professional                             │
│                                                              │
│  4. CONSISTENT STYLE                                         │
│     └── Same colors, fonts, layout                          │
│     └── Creates cohesive look                               │
│                                                              │
│  5. HIGHLIGHT KEY SCREENS                                    │
│     └── Home screen                                         │
│     └── Main feature                                        │
│     └── Settings/customization                              │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Screenshot Layout Example

```
SCREENSHOT 1:          SCREENSHOT 2:          SCREENSHOT 3:
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│              │       │              │       │              │
│ "Organize    │       │ "Track       │       │ "Beautiful   │
│  Your Life"  │       │  Progress"   │       │  Dark Mode"  │
│              │       │              │       │              │
│  ┌────────┐  │       │  ┌────────┐  │       │  ┌────────┐  │
│  │  📱    │  │       │  │  📊    │  │       │  │  🌙    │  │
│  │  Home  │  │       │  │ Charts │  │       │  │ Dark   │  │
│  │ Screen │  │       │  │        │  │       │  │ Theme  │  │
│  └────────┘  │       │  └────────┘  │       │  └────────┘  │
│              │       │              │       │              │
└──────────────┘       └──────────────┘       └──────────────┘

Each screenshot should highlight ONE key feature!
```

---

## App Name and Title

### Choosing a Good Name

```
APP NAME TIPS:

✅ GOOD NAMES:
├── Short and memorable (1-3 words)
├── Easy to spell and pronounce
├── Hints at what the app does
├── Unique and searchable
└── Available as a domain/social handle

❌ BAD NAMES:
├── Too long or complex
├── Hard to spell
├── Too generic ("Notes App")
├── Similar to popular apps
└── Contains special characters
```

### Title Optimization

```
GOOGLE PLAY TITLE:
Maximum: 30 characters

Examples:
"TodoMaster - Task Manager"     ← Name + keyword
"Fitness Pro: Workout Tracker"  ← Name + description
"NoteX"                         ← Just the name

APPLE APP STORE:
App Name: 30 characters max
Subtitle: 30 characters max

Example:
Name: "TaskFlow"
Subtitle: "Simple Task Management"
```

---

## Descriptions

### Short Description

```
SHORT DESCRIPTION (Google Play):
80 characters maximum

This appears:
├── In search results
├── At top of listing
└── Users see this FIRST

Examples:

✅ GOOD:
"The simplest way to track your daily habits and build better routines."

❌ BAD:
"Download now for free best app ever made for habits tracking productivity"
```

### Full Description

```
FULL DESCRIPTION STRUCTURE:

1. HOOK (First 2-3 lines)
   Users might not read more!
   "TaskFlow helps you get more done with less stress.
    Join 100,000+ users who've transformed their productivity."

2. KEY FEATURES
   Use bullet points or emojis:
   ✓ Create unlimited tasks
   ✓ Set reminders and due dates
   ✓ Beautiful themes and widgets
   ✓ Sync across all devices

3. SOCIAL PROOF
   "★★★★★ 'Best task app I've ever used' - App Store Review"
   "Featured in ProductHunt, TechCrunch, Lifehacker"

4. CALL TO ACTION
   "Download now and start being more productive today!"

CHARACTER LIMITS:
Google Play: 4,000 characters
App Store: 4,000 characters
```

### Description Template

```
[APP NAME] - [ONE LINE DESCRIPTION]

[2-3 sentence hook explaining the main benefit]

WHY CHOOSE [APP NAME]?

✓ [Feature 1 with benefit]
✓ [Feature 2 with benefit]
✓ [Feature 3 with benefit]
✓ [Feature 4 with benefit]
✓ [Feature 5 with benefit]

PERFECT FOR:
• [Use case 1]
• [Use case 2]
• [Use case 3]

WHAT USERS SAY:
"[Quote from user/review]" - [Source]

COMING SOON:
• [Upcoming feature 1]
• [Upcoming feature 2]

Download [APP NAME] today and [benefit]!

Questions? Contact us at support@yourapp.com
Follow us: @yourapp on Twitter
```

---

## Feature Graphic (Android)

```
FEATURE GRAPHIC:

Size: 1024 x 500 px
Appears at top of Play Store listing

┌──────────────────────────────────────────────────────────────┐
│                                                              │
│     "Your Life, Organized"          [App Preview]           │
│     TaskFlow                           ┌─────┐              │
│                                        │ 📱  │              │
│     [Download Now]                     └─────┘              │
│                                                              │
└──────────────────────────────────────────────────────────────┘

TIPS:
✅ Show your app in action
✅ Include your logo/name
✅ Use brand colors
✅ Keep text minimal and large
❌ Don't crowd with too much info
```

---

## Keywords and ASO

### App Store Optimization (ASO)

```
ASO = Making your app findable in search

GOOGLE PLAY:
├── Keywords in title help a lot
├── Keywords in description help
├── Category selection matters
└── No separate keyword field

APPLE APP STORE:
├── Title and subtitle
├── Keyword field (100 chars, comma-separated)
├── Category selection
└── Description doesn't affect search (but affects users!)
```

### Keyword Research

```
HOW TO FIND KEYWORDS:

1. BRAINSTORM
   What would users search for?
   "task manager", "to do list", "productivity"

2. COMPETITOR ANALYSIS
   What keywords do similar apps use?

3. TOOLS
   ├── AppTweak
   ├── Sensor Tower
   ├── App Annie
   └── AppFollow

4. TEST AND ITERATE
   Track rankings, adjust keywords

KEYWORD PLACEMENT (Priority order):
1. App title
2. App subtitle (iOS)
3. Keyword field (iOS)
4. Short description (Android)
5. Full description (Android)
```

---

## Privacy Policy

```
PRIVACY POLICY REQUIREMENTS:

BOTH STORES REQUIRE:
├── Privacy policy URL
├── Accessible webpage
└── Must explain data collection

WHAT TO INCLUDE:
├── What data you collect
├── How you use the data
├── Third-party services used
├── User rights (delete data, etc.)
├── Contact information
└── Last updated date

FREE TOOLS TO CREATE:
├── Termly.io
├── FreePrivacyPolicy.com
├── PrivacyPolicies.com
└── Iubenda.com

⚠️  IMPORTANT:
If your app doesn't collect any data,
you still need a policy saying that!
```

---

## Category Selection

```
CHOOSE YOUR CATEGORY WISELY:

GOOGLE PLAY CATEGORIES:
├── Art & Design
├── Business
├── Education
├── Entertainment
├── Finance
├── Health & Fitness
├── Lifestyle
├── Productivity
├── Shopping
├── Social
├── Tools
├── Travel
└── ...and more

APPLE APP STORE:
├── Primary category (required)
└── Secondary category (optional)

TIPS:
✅ Choose most relevant category
✅ Consider competition (less crowded = easier to rank)
✅ Look at where competitors are listed
❌ Don't choose wrong category to avoid rejection
```

---

## Store Listing Checklist

```
BEFORE SUBMITTING:

APP IDENTITY:
□ App name (unique, memorable)
□ App icon (all required sizes)
□ Category selected

MEDIA:
□ Screenshots (minimum required)
□ Feature graphic (Android)
□ Preview video (optional but helpful)

TEXT:
□ Short description (compelling hook)
□ Full description (features, benefits)
□ What's New text (for updates)

LEGAL:
□ Privacy policy URL
□ Terms of service (if needed)
□ Content rating questionnaire completed

CONTACT:
□ Support email
□ Support website (optional)
□ Developer name/address
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              STORE LISTINGS SUMMARY                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  VISUAL ASSETS:                                              │
│  ├── App icon (1024x1024, all sizes)                        │
│  ├── Screenshots (highlight best features)                  │
│  ├── Feature graphic (Android, 1024x500)                    │
│  └── Preview video (optional)                               │
│                                                              │
│  TEXT CONTENT:                                               │
│  ├── App name (short, memorable)                            │
│  ├── Short description (hook in 80 chars)                   │
│  ├── Full description (features + benefits)                 │
│  └── Keywords (for discoverability)                         │
│                                                              │
│  REQUIREMENTS:                                               │
│  ├── Privacy policy URL                                     │
│  ├── Contact information                                    │
│  ├── Category selection                                     │
│  └── Content rating                                         │
│                                                              │
│  TIPS:                                                       │
│  ├── First impression matters!                              │
│  ├── Show, don't tell (good screenshots)                    │
│  ├── Keep updating based on feedback                        │
│  └── A/B test if possible                                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Name three things in a store listing.

<details>
<summary>Answer</summary>
Any three: app name, icon, screenshots, short and full description, category, and a feature graphic/preview.
</details>

**Q2.** Why do screenshots matter so much?

<details>
<summary>Answer</summary>
They are the first thing users look at; good screenshots show value fast and drive downloads.
</details>

**Q3.** What should the first line of your description do?

<details>
<summary>Answer</summary>
Clearly say what the app does and why someone wants it, since many users only read the first line.
</details>

---

## Assignment

### Problem 1: Listing pieces

List four parts of a store listing you must prepare.

### Problem 2: First impression

Which listing element usually has the biggest impact on downloads?

### Problem 3: Write a hook

Write a one-line opening description for a simple habit-tracker app.

---

## Assignment Answers

### Problem 1: Listing pieces

App name, app icon, screenshots, and a description (plus category, and often a feature graphic).

### Problem 2: First impression

The screenshots (and icon) usually matter most, they are what users scan first.

### Problem 3: Write a hook

Something like: "Build better habits one day at a time, track your streaks and never miss a day."

---

**Next:** `05-SubmissionProcess.md` - Submitting to app stores
