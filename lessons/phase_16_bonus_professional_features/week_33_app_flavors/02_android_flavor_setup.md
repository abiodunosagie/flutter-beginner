# Setting Up Android Flavors - Complete Guide

## Understanding Android Build System (5-Year-Old Explanation)

Imagine you have a toy factory that makes different versions of robots:
- **Red robots** for Team A
- **Blue robots** for Team B
- **Gold robots** for special customers

The factory uses the **same assembly line** (your code) but different:
- Paint colors (app names)
- Stickers (app icons)
- Boxes (package names)

Android's build system (Gradle) is like the factory manager that creates these different versions!

## Step-by-Step Android Flavor Setup

### Step 1: Understand the File Structure

Your Flutter project has this structure:
```
my_app/
├── android/
│   └── app/
│       ├── build.gradle  ← WE'LL EDIT THIS!
│       └── src/
│           ├── main/     ← Default files
│           ├── dev/      ← We'll create this
│           ├── staging/  ← We'll create this
│           └── prod/     ← We'll create this
├── lib/
└── pubspec.yaml
```

**Think of it like:**
- `main/` = The base recipe (shared by all)
- `dev/` = Extra ingredients for development version
- `staging/` = Extra ingredients for staging version
- `prod/` = Extra ingredients for production version

### Step 2: Open build.gradle File

Navigate to: `android/app/build.gradle`

This file is like a **recipe book** that tells Android how to build your app.

### Step 3: Add Product Flavors

Find this section in `build.gradle`:

```gradle
android {
    compileSdkVersion flutter.compileSdkVersion

    defaultConfig {
        applicationId "com.example.myapp"
        minSdkVersion flutter.minSdkVersion
        targetSdkVersion flutter.targetSdkVersion
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    // ADD THIS SECTION HERE! ⬇️
}
```

**Add this block inside the `android` section:**

```gradle
android {
    // ... existing code above ...

    flavorDimensions "app"  // Like saying "We're making app flavors"

    productFlavors {
        // Development Flavor (Your test kitchen)
        dev {
            dimension "app"
            applicationIdSuffix ".dev"  // com.example.myapp.dev
            versionNameSuffix "-dev"    // 1.0.0-dev
            resValue "string", "app_name", "MyApp DEV"  // App name
        }

        // Staging Flavor (Dress rehearsal)
        staging {
            dimension "app"
            applicationIdSuffix ".staging"  // com.example.myapp.staging
            versionNameSuffix "-staging"    // 1.0.0-staging
            resValue "string", "app_name", "MyApp STAGING"
        }

        // Production Flavor (The real deal)
        prod {
            dimension "app"
            // No suffix = com.example.myapp (clean for app stores)
            resValue "string", "app_name", "MyApp"
        }
    }
}
```

### Step 4: Understanding Each Part

Let's break down what each line means:

#### 1. **flavorDimensions "app"**

Think of this as creating a **category**.

**5-Year-Old Analogy:**
When sorting toys, you might sort by:
- Size dimension: small, medium, large
- Color dimension: red, blue, green

Here, we have one dimension called "app" for our app versions.

#### 2. **productFlavors { }**

This is where we define each version!

#### 3. **applicationIdSuffix**

```gradle
applicationIdSuffix ".dev"
```

**Original ID**: `com.example.myapp`
**With suffix**: `com.example.myapp.dev`

**Why?** This is like giving each robot a different serial number. Android sees these as **completely different apps**, so you can install all three on one phone!

**5-Year-Old Analogy:**
- Your full name: "John Smith"
- Nickname at home: "John Smith Junior" (.dev)
- Name at school: "John Smith Student" (.staging)
- Official name: "John Smith" (production)

All are you, but different contexts!

#### 4. **versionNameSuffix**

```gradle
versionNameSuffix "-dev"
```

**Version**: 1.0.0
**With suffix**: 1.0.0-dev

This helps you see which version you're running!

#### 5. **resValue "string", "app_name"**

This changes the app name that appears on your phone's home screen.

**Dev**: "MyApp DEV" (with dev label)
**Staging**: "MyApp STAGING"
**Prod**: "MyApp" (clean and professional)

### Step 5: Update AndroidManifest.xml

Navigate to: `android/app/src/main/AndroidManifest.xml`

Find this line:
```xml
<application
    android:label="myapp"  ← CHANGE THIS
    ...>
```

**Change it to:**
```xml
<application
    android:label="@string/app_name"  ← Use the dynamic name!
    ...>
```

**Why?** Now the app name comes from `build.gradle` and changes per flavor!

### Step 6: Create Flavor-Specific Folders (Optional but Professional)

Sometimes you want completely different files per flavor (like different icons, Firebase config, etc.)

```bash
# In your terminal, from project root:
mkdir -p android/app/src/dev
mkdir -p android/app/src/staging
mkdir -p android/app/src/prod
```

**Structure now:**
```
android/app/src/
├── main/
│   ├── AndroidManifest.xml  ← Shared by all
│   └── res/                  ← Shared resources
├── dev/
│   └── res/                  ← Dev-only resources (icons, colors)
├── staging/
│   └── res/                  ← Staging-only resources
└── prod/
    └── res/                  ← Production-only resources
```

**5-Year-Old Analogy:**
- `main/` = Shared toys everyone can use
- `dev/` = Special toys only for development
- `staging/` = Special toys for testing
- `prod/` = Special toys for the real deal

### Step 7: Add Different App Icons Per Flavor

Let's give each flavor its own icon!

#### Create icon folders:

```bash
mkdir -p android/app/src/dev/res/mipmap-hdpi
mkdir -p android/app/src/dev/res/mipmap-mdpi
mkdir -p android/app/src/dev/res/mipmap-xhdpi
mkdir -p android/app/src/dev/res/mipmap-xxhdpi
mkdir -p android/app/src/dev/res/mipmap-xxxhdpi
```

**Do the same for staging and prod:**
```bash
# Repeat for staging
mkdir -p android/app/src/staging/res/mipmap-hdpi
mkdir -p android/app/src/staging/res/mipmap-mdpi
mkdir -p android/app/src/staging/res/mipmap-xhdpi
mkdir -p android/app/src/staging/res/mipmap-xxhdpi
mkdir -p android/app/src/staging/res/mipmap-xxxhdpi

# Repeat for prod
mkdir -p android/app/src/prod/res/mipmap-hdpi
mkdir -p android/app/src/prod/res/mipmap-mdpi
mkdir -p android/app/src/prod/res/mipmap-xhdpi
mkdir -p android/app/src/prod/res/mipmap-xxhdpi
mkdir -p android/app/src/prod/res/mipmap-xxxhdpi
```

#### Add your icons:

Place different icons in each folder:
- `dev/res/mipmap-*/ic_launcher.png` ← Icon with "D" badge
- `staging/res/mipmap-*/ic_launcher.png` ← Icon with "S" badge
- `prod/res/mipmap-*/ic_launcher.png` ← Clean professional icon

**Pro Tip:** Use online tools like [AppIcon.co](https://appicon.co) to generate icons with badges!

### Step 8: Test Your Setup!

Time to see if it works!

#### Build Development Flavor:
```bash
flutter run --flavor dev
```

#### Build Staging Flavor:
```bash
flutter run --flavor staging
```

#### Build Production Flavor:
```bash
flutter run --flavor prod
```

**What should happen:**
- Each command installs a **different app** on your phone
- Each app has a **different name** ("MyApp DEV", "MyApp STAGING", "MyApp")
- Each app has a **different package name** (they can coexist!)

### Step 9: Build Release APKs

When you're ready to ship:

```bash
# Development APK
flutter build apk --flavor dev

# Staging APK (for QA team)
flutter build apk --flavor staging

# Production APK (for Google Play Store)
flutter build apk --flavor prod --release
```

## Complete build.gradle Example

Here's what your final `android/app/build.gradle` should look like:

```gradle
def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterRoot = localProperties.getProperty('flutter.sdk')
if (flutterRoot == null) {
    throw new GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}

apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"

android {
    compileSdkVersion flutter.compileSdkVersion
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        applicationId "com.example.myapp"
        minSdkVersion flutter.minSdkVersion
        targetSdkVersion flutter.targetSdkVersion
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    // ============================================
    // FLAVORS CONFIGURATION
    // ============================================
    flavorDimensions "app"

    productFlavors {
        dev {
            dimension "app"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "MyApp DEV"
        }

        staging {
            dimension "app"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
            resValue "string", "app_name", "MyApp STAGING"
        }

        prod {
            dimension "app"
            resValue "string", "app_name", "MyApp"
        }
    }
    // ============================================

    buildTypes {
        release {
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
}
```

## Common Errors & Solutions

### Error 1: "Flavor not found"

**Error:**
```
Error: Unknown flavor 'dev'
```

**Solution:**
- Make sure you added flavors to `build.gradle`
- Check spelling (case-sensitive!)
- Run `flutter clean` and try again

### Error 2: "Duplicate resources"

**Error:**
```
Duplicate resources for app_name
```

**Solution:**
- Make sure `AndroidManifest.xml` uses `@string/app_name`, not hardcoded name

### Error 3: "Cannot find property 'flutterRoot'"

**Solution:**
- This is usually fine, just make sure `local.properties` exists
- Run `flutter doctor` to verify setup

## Verification Checklist

✅ `build.gradle` has `flavorDimensions "app"`
✅ `build.gradle` has all three `productFlavors` (dev, staging, prod)
✅ `AndroidManifest.xml` uses `@string/app_name`
✅ Each flavor has unique `applicationIdSuffix`
✅ Running `flutter run --flavor dev` works
✅ You can install all three flavors on one device

## Next Lesson

In the next lesson, we'll set up iOS schemes (the iOS equivalent of Android flavors). iOS is a bit trickier but we'll make it super easy!

**Great job!** You've just mastered Android flavors like a pro! 🎉
