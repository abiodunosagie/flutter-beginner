# Setting Up iOS Schemes - Complete Guide

## Understanding iOS Schemes (5-Year-Old Explanation)

Imagine you have a magic costume box with three different superhero costumes:
- **Practice costume** (dev) - Has training wheels, shows your moves, safe to fall
- **Rehearsal costume** (staging) - Looks real but you're still practicing
- **Real superhero costume** (prod) - The actual outfit for saving the world!

**Same person (you), different outfits for different situations!**

iOS Schemes are like these costumes. They're different configurations that tell Xcode:
- Which "outfit" to wear (which settings to use)
- Which "badge" to show (app icon)
- Which "name" to use (app display name)
- Which "superpower settings" to activate (API endpoints, Firebase config, etc.)

## Why iOS Schemes Are Different from Android Flavors

**Android**: Uses Gradle configuration files (text files you edit)
**iOS**: Uses Xcode (a visual editor with buttons and menus)

**5-Year-Old Analogy:**
- **Android** = Lego instructions (step-by-step written guide)
- **iOS** = Playdough molds (you shape things with tools)

Both achieve the same result, just different approaches!

## Prerequisites

Before we start, make sure:
- ✅ You have Xcode installed (Mac only)
- ✅ You've run `flutter create` for your project
- ✅ You understand what flavors/schemes are (Lesson 01)
- ✅ You completed Android setup (Lesson 02) - not required but helpful

## Step-by-Step iOS Scheme Setup

### Step 1: Open Your iOS Project in Xcode

**From Terminal:**
```bash
# Navigate to your Flutter project
cd /path/to/your/flutter_project

# Open iOS project in Xcode
open ios/Runner.xcworkspace
```

**Important:** Open the `.xcworkspace` file, **NOT** `.xcodeproj`!

**5-Year-Old Analogy:**
- `.xcworkspace` = The full toy box with all toys
- `.xcodeproj` = Just one toy (missing pieces!)

### Step 2: Understand the Xcode Interface

When Xcode opens, you'll see:

```
┌─────────────────────────────────────────────────────┐
│  [←] [→]  Runner                          [▶ Run]   │  ← Top toolbar
├──────────┬──────────────────────────────────────────┤
│          │                                          │
│  Files   │         Configuration Area               │
│  └ Runner│         (This is where we work!)         │
│  └ Pods  │                                          │
│          │                                          │
└──────────┴──────────────────────────────────────────┘
```

**What to look for:**
1. **Left sidebar**: List of files (Navigator)
2. **Middle area**: Where we configure settings
3. **Top toolbar**: Where we select schemes and run

### Step 3: Create Build Configurations

Build configurations are like **recipe cards** that tell iOS how to build your app.

**Click on:**
1. `Runner` (the project) in left sidebar
2. `Runner` (under PROJECTS) in the middle area
3. Click the `Info` tab at the top

You'll see a section called **Configurations** with:
- Debug
- Release
- Profile

**We need to create THREE versions of each (dev, staging, prod)!**

#### Add Development Configurations

1. Click the `+` button under Configurations
2. Select `Duplicate "Debug" Configuration`
3. Name it: `Debug-dev`

Repeat for Release and Profile:
4. Duplicate `Release` → name it `Release-dev`
5. Duplicate `Profile` → name it `Profile-dev`

#### Add Staging Configurations

6. Duplicate `Debug` → `Debug-staging`
7. Duplicate `Release` → `Release-staging`
8. Duplicate `Profile` → `Profile-staging`

#### Add Production Configurations

9. Duplicate `Debug` → `Debug-prod`
10. Duplicate `Release` → `Release-prod`
11. Duplicate `Profile` → `Profile-prod`

**What you should have now:**
```
Configurations:
├── Debug               (original - we can delete this later)
├── Debug-dev           ← Development
├── Debug-staging       ← Staging
├── Debug-prod          ← Production
├── Release             (original - we can delete this later)
├── Release-dev         ← Development
├── Release-staging     ← Staging
├── Release-prod        ← Production
├── Profile             (original - we can delete this later)
├── Profile-dev         ← Development
├── Profile-staging     ← Staging
└── Profile-prod        ← Production
```

### Step 4: Create Schemes

Schemes connect everything together. They say "When I click Run with this scheme, use these configurations."

**5-Year-Old Analogy:**
Think of schemes like **activity plans**:
- **Development plan**: Play in sandbox (safe, messy, fun)
- **Staging plan**: Practice performance (dress rehearsal)
- **Production plan**: Real performance (showtime!)

#### Create Development Scheme

1. Click on the scheme selector (top left, says "Runner")
2. Select `Manage Schemes...`
3. Click the `+` button at bottom
4. Name: `dev`
5. Make sure `Runner` is selected as target
6. Click `OK`

**Configure the dev scheme:**
1. Select `dev` scheme from the list
2. Click `Edit` button
3. For each action (Run, Test, Profile, Analyze, Archive), select the corresponding **dev** configuration:
   - **Run** → `Debug-dev`
   - **Test** → `Debug-dev`
   - **Profile** → `Profile-dev`
   - **Analyze** → `Debug-dev`
   - **Archive** → `Release-dev`

4. Check **Shared** checkbox (so your team can use this scheme)

#### Create Staging Scheme

Repeat the same process:
1. Click `+` to create new scheme
2. Name: `staging`
3. Target: `Runner`
4. Edit the scheme:
   - **Run** → `Debug-staging`
   - **Test** → `Debug-staging`
   - **Profile** → `Profile-staging`
   - **Analyze** → `Debug-staging`
   - **Archive** → `Release-staging`
5. Check **Shared**

#### Create Production Scheme

1. Click `+` to create new scheme
2. Name: `prod`
3. Target: `Runner`
4. Edit the scheme:
   - **Run** → `Debug-prod`
   - **Test** → `Debug-prod`
   - **Profile** → `Profile-prod`
   - **Analyze** → `Debug-prod`
   - **Archive** → `Release-prod`
5. Check **Shared**

**What you should have now:**
```
Schemes:
├── Runner      (original - can delete later)
├── dev         ← Development
├── staging     ← Staging
└── prod        ← Production
```

### Step 5: Set Up Different Bundle Identifiers

Bundle Identifiers are like **unique ID cards** for your apps. They let iOS know these are different apps.

**Click on:**
1. `Runner` target (under TARGETS in left area)
2. `Build Settings` tab
3. Search for "Product Bundle Identifier" in the search box

**You'll see the current bundle ID:** `com.example.myApp`

We need to make this **dynamic** based on scheme!

#### Method 1: Using Build Settings (Easier)

1. Click on the `+` button next to `Product Bundle Identifier`
2. Select `Add User-Defined Setting`
3. Name it: `BUNDLE_ID_SUFFIX`

4. Expand `BUNDLE_ID_SUFFIX` and add values for each configuration:
   - **Debug-dev**: `.dev`
   - **Release-dev**: `.dev`
   - **Profile-dev**: `.dev`
   - **Debug-staging**: `.staging`
   - **Release-staging**: `.staging`
   - **Profile-staging**: `.staging`
   - **Debug-prod**: `` (empty - no suffix for production)
   - **Release-prod**: `` (empty)
   - **Profile-prod**: `` (empty)

5. Now modify `Product Bundle Identifier`:
   - Change from: `com.example.myApp`
   - Change to: `com.example.myApp$(BUNDLE_ID_SUFFIX)`

**What this does:**
- **Dev**: `com.example.myApp.dev`
- **Staging**: `com.example.myApp.staging`
- **Prod**: `com.example.myApp`

**5-Year-Old Analogy:**
Like name tags at school:
- "John (practicing)" - dev
- "John (rehearsal)" - staging
- "John" - production (formal!)

### Step 6: Set Up Different App Names

Now let's make each app show a different name on the home screen!

#### Create Info.plist for Each Flavor

Currently, you have: `ios/Runner/Info.plist`

**We need three versions:**

1. In Finder, navigate to `your_project/ios/Runner/`
2. Copy `Info.plist` three times:
   - `Info-dev.plist`
   - `Info-staging.plist`
   - `Info-prod.plist`

**Or use terminal:**
```bash
cd ios/Runner
cp Info.plist Info-dev.plist
cp Info.plist Info-staging.plist
cp Info.plist Info-prod.plist
```

#### Edit Each Info.plist

**Info-dev.plist:**
Open in text editor and find:
```xml
<key>CFBundleDisplayName</key>
<string>$(PRODUCT_NAME)</string>
```

Change to:
```xml
<key>CFBundleDisplayName</key>
<string>MyApp DEV</string>
```

**Info-staging.plist:**
```xml
<key>CFBundleDisplayName</key>
<string>MyApp STAGING</string>
```

**Info-prod.plist:**
```xml
<key>CFBundleDisplayName</key>
<string>MyApp</string>
```

#### Configure Xcode to Use Correct Info.plist

Back in Xcode:

1. Select `Runner` target
2. `Build Settings` tab
3. Search for "Info.plist"
4. Find `Info.plist File` setting
5. Expand it to show all configurations

**Set each configuration:**
- **Debug-dev**: `Runner/Info-dev.plist`
- **Release-dev**: `Runner/Info-dev.plist`
- **Profile-dev**: `Runner/Info-dev.plist`
- **Debug-staging**: `Runner/Info-staging.plist`
- **Release-staging**: `Runner/Info-staging.plist`
- **Profile-staging**: `Runner/Info-staging.plist`
- **Debug-prod**: `Runner/Info-prod.plist`
- **Release-prod**: `Runner/Info-prod.plist`
- **Profile-prod**: `Runner/Info-prod.plist`

### Step 7: Set Up Different App Icons (Optional but Professional)

iOS lets you have different icons per flavor!

#### Create Asset Catalogs

1. In Xcode, right-click on `Runner` folder
2. Select `New File...`
3. Choose `Asset Catalog`
4. Name it: `Assets-dev.xcassets`
5. Click `Create`

**Repeat for other flavors:**
- `Assets-staging.xcassets`
- `Assets-prod.xcassets`

#### Add App Icons to Each Catalog

1. Open `Assets-dev.xcassets`
2. Right-click in the left panel
3. Select `App Icons & Launch Images > New iOS App Icon`
4. Drag your **development icon** (with "D" badge) into the slots

**Repeat for staging and prod with their respective icons!**

#### Configure Asset Catalogs Per Configuration

1. Select `Runner` target
2. `Build Settings` tab
3. Search for "Asset Catalog"
4. Find `Asset Catalog Compiler - Options`
5. Expand `Primary App Icon Set Name`

**Set each configuration:**
- **Debug-dev**: `AppIcon` (from Assets-dev)
- **Release-dev**: `AppIcon` (from Assets-dev)
- **Profile-dev**: `AppIcon` (from Assets-dev)
- **Debug-staging**: `AppIcon` (from Assets-staging)
- **Release-staging**: `AppIcon` (from Assets-staging)
- **Profile-staging**: `AppIcon` (from Assets-staging)
- **Debug-prod**: `AppIcon` (from Assets-prod)
- **Release-prod**: `AppIcon` (from Assets-prod)
- **Profile-prod**: `AppIcon` (from Assets-prod)

Also set `Asset Catalog Compiler - Options > Primary Asset Catalog Name`:
- **Debug-dev**: `Assets-dev`
- **Release-dev**: `Assets-dev`
- **Profile-dev**: `Assets-dev`
- **Debug-staging**: `Assets-staging`
- **Release-staging**: `Assets-staging`
- **Profile-staging**: `Assets-staging`
- **Debug-prod**: `Assets-prod`
- **Release-prod**: `Assets-prod`
- **Profile-prod**: `Assets-prod`

### Step 8: Test Your Setup!

Time to see if everything works!

#### From Terminal (Recommended):

```bash
# Run development
flutter run --flavor dev

# Run staging
flutter run --flavor staging

# Run production
flutter run --flavor prod
```

#### From Xcode:

1. Select scheme from dropdown (dev, staging, or prod)
2. Click the Run button (▶)

**What should happen:**
- Each flavor installs as a **separate app**
- Each has a **different name** on home screen
- Each has a **different bundle ID** (they coexist!)
- Each can have a **different icon** (if you set it up)

### Step 9: Build for Release

When ready to ship to App Store:

```bash
# Development IPA (for testing)
flutter build ios --flavor dev --release

# Staging IPA (for beta testers)
flutter build ios --flavor staging --release

# Production IPA (for App Store)
flutter build ios --flavor prod --release
```

**Or in Xcode:**
1. Select `prod` scheme
2. Select `Any iOS Device` as target
3. Menu: `Product > Archive`
4. Wait for archive to complete
5. Click `Distribute App`

## Complete Configuration Summary

Here's a visual summary of what we set up:

```
┌─────────────────────────────────────────────────────────┐
│                    iOS SCHEMES SETUP                    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  BUILD CONFIGURATIONS:                                  │
│  ├── Debug-dev, Release-dev, Profile-dev                │
│  ├── Debug-staging, Release-staging, Profile-staging    │
│  └── Debug-prod, Release-prod, Profile-prod             │
│                                                         │
│  SCHEMES:                                               │
│  ├── dev → uses *-dev configurations                    │
│  ├── staging → uses *-staging configurations            │
│  └── prod → uses *-prod configurations                  │
│                                                         │
│  BUNDLE IDENTIFIERS:                                    │
│  ├── com.example.myApp.dev                              │
│  ├── com.example.myApp.staging                          │
│  └── com.example.myApp                                  │
│                                                         │
│  APP NAMES:                                             │
│  ├── MyApp DEV                                          │
│  ├── MyApp STAGING                                      │
│  └── MyApp                                              │
│                                                         │
│  INFO.PLIST FILES:                                      │
│  ├── Info-dev.plist                                     │
│  ├── Info-staging.plist                                 │
│  └── Info-prod.plist                                    │
│                                                         │
│  ASSET CATALOGS (optional):                             │
│  ├── Assets-dev.xcassets                                │
│  ├── Assets-staging.xcassets                            │
│  └── Assets-prod.xcassets                               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Advanced: Using xcconfig Files (Professional Approach)

For larger projects, managing settings in Xcode UI gets messy. Use **xcconfig** files (text files with settings).

### Create xcconfig Files

```bash
mkdir ios/Flutter/Config
touch ios/Flutter/Config/dev.xcconfig
touch ios/Flutter/Config/staging.xcconfig
touch ios/Flutter/Config/prod.xcconfig
```

**dev.xcconfig:**
```xcconfig
// Development Configuration
#include "Generated.xcconfig"

PRODUCT_BUNDLE_IDENTIFIER = com.example.myApp.dev
DISPLAY_NAME = MyApp DEV
ASSET_CATALOG_NAME = Assets-dev
INFOPLIST_FILE = Runner/Info-dev.plist
```

**staging.xcconfig:**
```xcconfig
// Staging Configuration
#include "Generated.xcconfig"

PRODUCT_BUNDLE_IDENTIFIER = com.example.myApp.staging
DISPLAY_NAME = MyApp STAGING
ASSET_CATALOG_NAME = Assets-staging
INFOPLIST_FILE = Runner/Info-staging.plist
```

**prod.xcconfig:**
```xcconfig
// Production Configuration
#include "Generated.xcconfig"

PRODUCT_BUNDLE_IDENTIFIER = com.example.myApp
DISPLAY_NAME = MyApp
ASSET_CATALOG_NAME = Assets-prod
INFOPLIST_FILE = Runner/Info-prod.plist
```

### Link xcconfig Files to Configurations

In Xcode:
1. Select `Runner` project (not target)
2. `Info` tab
3. Expand each configuration under `Configurations`
4. Select the xcconfig file for each:
   - **Debug-dev** → `dev.xcconfig`
   - **Release-dev** → `dev.xcconfig`
   - **Profile-dev** → `dev.xcconfig`
   - **Debug-staging** → `staging.xcconfig`
   - **Release-staging** → `staging.xcconfig`
   - **Profile-staging** → `staging.xcconfig`
   - **Debug-prod** → `prod.xcconfig`
   - **Release-prod** → `prod.xcconfig`
   - **Profile-prod** → `prod.xcconfig`

**Benefits of xcconfig:**
- ✅ All settings in text files (easy to version control)
- ✅ Easy to review changes in Git
- ✅ Harder to make mistakes in Xcode UI
- ✅ Professional approach used by large teams

## Common Errors & Solutions

### Error 1: "Scheme not found"

**Error:**
```
Could not find an option named "flavor" with value "dev"
```

**Solutions:**
- Make sure Xcode schemes are **Shared** (checkmark in Manage Schemes)
- Check that scheme name matches exactly (case-sensitive!)
- Close and reopen Xcode
- Run `flutter clean` and try again

### Error 2: "Multiple commands produce Info.plist"

**Error:**
```
Multiple commands produce '/Info.plist'
```

**Solution:**
This happens when Info.plist files are in the wrong location or duplicated.

1. In Xcode, select Runner target
2. Go to `Build Phases` tab
3. Expand `Copy Bundle Resources`
4. Remove any `Info.plist` files you see there
5. Info.plist should NOT be in Copy Bundle Resources!

### Error 3: "App installs but has wrong name/icon"

**Solutions:**
- Delete app from device/simulator completely
- In Xcode: `Product > Clean Build Folder` (Shift+Cmd+K)
- Reinstall the app
- Check that correct Info.plist is selected for configuration

### Error 4: "Bundle identifier has illegal characters"

**Solution:**
- Bundle IDs can only have: letters, numbers, hyphens, and periods
- ✅ Good: `com.example.myApp.dev`
- ❌ Bad: `com.example.my-app.dev` (no hyphens in app name part)
- ❌ Bad: `com.example.myApp_dev` (no underscores)

### Error 5: "Signing requires a development team"

**Solution:**
This is normal. For each scheme:
1. Select Runner target
2. `Signing & Capabilities` tab
3. Check `Automatically manage signing`
4. Select your Team (or add Apple ID in Xcode Preferences)

**For different bundle IDs:**
You might need to set signing separately for each configuration if you have multiple developer accounts.

### Error 6: "CocoaPods could not find compatible versions"

**Solution:**
```bash
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
flutter clean
```

## Verification Checklist

Use this checklist to verify your setup:

### Build Configurations
- ✅ Created Debug-dev, Release-dev, Profile-dev
- ✅ Created Debug-staging, Release-staging, Profile-staging
- ✅ Created Debug-prod, Release-prod, Profile-prod
- ✅ All configurations appear in Xcode

### Schemes
- ✅ Created dev, staging, prod schemes
- ✅ Each scheme uses correct configurations
- ✅ All schemes are marked as **Shared**
- ✅ Schemes appear in Xcode scheme selector

### Bundle Identifiers
- ✅ Dev uses: `com.example.myApp.dev`
- ✅ Staging uses: `com.example.myApp.staging`
- ✅ Prod uses: `com.example.myApp`
- ✅ All three can be installed simultaneously

### App Names
- ✅ Info-dev.plist shows "MyApp DEV"
- ✅ Info-staging.plist shows "MyApp STAGING"
- ✅ Info-prod.plist shows "MyApp"
- ✅ Correct Info.plist selected for each configuration

### Testing
- ✅ `flutter run --flavor dev` works
- ✅ `flutter run --flavor staging` works
- ✅ `flutter run --flavor prod` works
- ✅ Each installs as separate app on device
- ✅ Each shows correct app name
- ✅ Each shows correct icon (if configured)

### File Structure
- ✅ Info-dev.plist exists
- ✅ Info-staging.plist exists
- ✅ Info-prod.plist exists
- ✅ Asset catalogs created (if using different icons)
- ✅ xcconfig files created (if using advanced setup)

## Comparison: Android vs iOS Flavors

| Feature | Android | iOS |
|---------|---------|-----|
| **Setup File** | `build.gradle` | Xcode project |
| **Configuration** | Product Flavors | Build Configurations |
| **Selection** | Schemes (implicit) | Schemes (explicit) |
| **Package ID** | `applicationId` + suffix | `PRODUCT_BUNDLE_IDENTIFIER` |
| **App Name** | `resValue` in gradle | Info.plist `CFBundleDisplayName` |
| **Icons** | Folder structure | Asset Catalogs |
| **Complexity** | ⭐⭐ (Medium) | ⭐⭐⭐⭐ (Higher) |
| **Flexibility** | ⭐⭐⭐⭐ (High) | ⭐⭐⭐⭐⭐ (Very High) |

**5-Year-Old Analogy:**
- **Android**: Following a recipe (step-by-step text instructions)
- **iOS**: Using a toy assembly kit (visual, lots of pieces to click together)

Both make the same delicious cake, just different cooking methods!

## Pro Tips

### 1. Keep Schemes Consistent

Make sure Android flavor names match iOS scheme names exactly:
- ✅ Android: `dev`, iOS: `dev`
- ❌ Android: `dev`, iOS: `development` (inconsistent!)

### 2. Use Version Control

After setting up, commit your Xcode project:
```bash
git add ios/
git commit -m "Add iOS schemes for dev/staging/prod flavors"
```

Important files to commit:
- `ios/Runner.xcodeproj/project.pbxproj`
- `ios/Runner.xcodeproj/xcshareddata/xcschemes/`
- `ios/Runner/Info-*.plist`
- `ios/Flutter/Config/*.xcconfig` (if using)

### 3. Share with Team

Make sure schemes are **Shared** so your team gets them when they pull from Git!

### 4. Document Your Setup

Create a `FLAVORS.md` in your project root:
```markdown
# App Flavors Setup

## Running the App

- Development: `flutter run --flavor dev`
- Staging: `flutter run --flavor staging`
- Production: `flutter run --flavor prod`

## iOS Specifics

- Schemes: dev, staging, prod
- Bundle IDs: *.dev, *.staging, (base)
```

### 5. Clean Regularly

iOS builds can get messy:
```bash
# Clean Flutter
flutter clean

# Clean iOS
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

## Next Lesson

Congratulations! You've mastered both Android flavors and iOS schemes! 🎉

In the next lesson, we'll learn how to **manage environment configuration in Dart** - this is where the magic happens! We'll create Dart classes that load different settings based on the current flavor.

**You're becoming a flavor expert!** 🚀
