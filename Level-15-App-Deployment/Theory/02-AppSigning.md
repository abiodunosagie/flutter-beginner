# App Signing

## The Simple Explanation

App signing is like putting your signature on a painting. It proves YOU made it, and nobody can pretend to be you. Every app must be signed before it goes to the store.

```
┌─────────────────────────────────────────────────────────────┐
│                  WHY APP SIGNING?                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Think of it like a wax seal on a letter:                   │
│                                                              │
│     ┌──────────────────┐                                    │
│     │  Your App        │                                    │
│     │  ...             │                                    │
│     │  [Official Seal] │  ← Your unique signature           │
│     └──────────────────┘                                    │
│                                                              │
│  WHAT SIGNING DOES:                                          │
│  1. Proves you made the app                                 │
│  2. Ensures app wasn't modified                             │
│  3. Required for app store submission                       │
│  4. Needed for updates (same key = trusted update)         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Android Signing

### Understanding Keys and Keystores

```
ANDROID SIGNING EXPLAINED:

  KEYSTORE FILE (.jks or .keystore)
  └── Like a safe that holds your keys

  KEY (inside keystore)
  └── Your unique digital signature

  PASSWORD
  └── Opens the safe

┌─────────────────────────────────────────────────────────────┐
│                                                              │
│     ┌─────────────────────────────────────────┐             │
│     │  KEYSTORE (my-key.keystore)             │             │
│     │  Password: ********                      │             │
│     │                                          │             │
│     │  ┌───────────────────────────────────┐  │             │
│     │  │  KEY (upload-key)                 │  │             │
│     │  │  Password: ********               │  │             │
│     │  │  Your digital signature           │  │             │
│     │  └───────────────────────────────────┘  │             │
│     └─────────────────────────────────────────┘             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Creating a Keystore (Android)

```bash
# Run this command in terminal:

keytool -genkey -v \
  -keystore ~/upload-keystore.jks \
  -storetype JKS \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload

# You'll be asked:
# - Keystore password (remember this!)
# - Key password (can be same as keystore)
# - Your name
# - Organization details
# - Country code (e.g., US)
```

```
⚠️  CRITICAL: SAVE YOUR KEYSTORE AND PASSWORDS!

If you lose them:
• You can NEVER update your app
• You'll have to publish a NEW app
• You'll lose all your users and reviews

RECOMMENDED:
• Store keystore in a safe place (not in code repo!)
• Write down passwords somewhere secure
• Make backup copies
• Consider using Google Play App Signing
```

### Configure Signing in Gradle

**Step 1: Create key.properties file**

```properties
# android/key.properties
# ⚠️ Add this file to .gitignore!

storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=upload
storeFile=/path/to/your/upload-keystore.jks
```

**Step 2: Update build.gradle**

```gradle
// android/app/build.gradle

// Add this at the top, before 'android {'
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(
        new FileInputStream(keystorePropertiesFile)
    )
}

android {
    // ... existing config ...

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ?
                file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release

            // Code shrinking (recommended)
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile(
                'proguard-android-optimize.txt'
            ), 'proguard-rules.pro'
        }
    }
}
```

### Google Play App Signing (Recommended!)

```
GOOGLE PLAY APP SIGNING:

Instead of managing your own signing key forever,
let Google manage it for you!

HOW IT WORKS:

  You                    Google                  Users
   │                        │                       │
   │  Upload Key            │                       │
   │ ──────────────────────>│                       │
   │                        │                       │
   │                        │  App Signing Key      │
   │                        │ ─────────────────────>│
   │                        │                       │
   │                        │                       │

BENEFITS:
✅ Google keeps the master key safe
✅ If you lose your upload key, Google can reset it
✅ Better security (App Bundle support)
✅ Smaller downloads for users

You create an UPLOAD KEY (to upload to Google)
Google uses their SIGNING KEY (to sign for users)
```

---

## iOS Signing

### Understanding iOS Signing

```
iOS SIGNING IS MORE COMPLEX:

You need:
1. Apple Developer Account ($99/year)
2. Certificates (proves your identity)
3. Provisioning Profiles (links everything)
4. App ID (unique identifier)

┌─────────────────────────────────────────────────────────────┐
│                                                              │
│    APPLE DEVELOPER ACCOUNT                                   │
│    │                                                         │
│    ├── CERTIFICATES                                          │
│    │   ├── Development (testing)                            │
│    │   └── Distribution (App Store)                         │
│    │                                                         │
│    ├── APP IDs                                               │
│    │   └── com.yourcompany.yourapp                          │
│    │                                                         │
│    └── PROVISIONING PROFILES                                 │
│        ├── Development Profile                               │
│        └── Distribution Profile                              │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Setting Up iOS Signing (Xcode)

```
STEP-BY-STEP:

1. OPEN XCODE
   Open ios/Runner.xcworkspace (not .xcodeproj!)

2. SELECT RUNNER
   Click Runner in the left sidebar

3. SIGNING & CAPABILITIES
   Go to "Signing & Capabilities" tab

4. TEAM
   Select your Apple Developer Team

5. BUNDLE IDENTIFIER
   Set to com.yourcompany.yourapp
   (Must match your App ID)

6. AUTOMATIC SIGNING
   Check "Automatically manage signing"
   Xcode creates certificates and profiles for you!
```

```
AUTOMATIC VS MANUAL SIGNING:

AUTOMATIC (Recommended for beginners):
✅ Xcode handles everything
✅ Less to understand
✅ Good for small teams
❌ Less control

MANUAL (For advanced users):
✅ Full control
✅ Better for large teams
✅ Custom provisioning
❌ More complex
❌ Must manage certificates yourself
```

### iOS Signing Troubleshooting

```
COMMON iOS SIGNING ERRORS:

ERROR: "No signing certificate found"
FIX: Go to Xcode > Preferences > Accounts
     Add your Apple ID and download certificates

ERROR: "Provisioning profile doesn't include..."
FIX: Enable "Automatically manage signing"
     Or update profile in Apple Developer Portal

ERROR: "Bundle identifier is not available"
FIX: Someone else is using that ID
     Choose a different bundle identifier

ERROR: "Your account doesn't have permission"
FIX: Make sure you have the right Apple Developer role
     Admin or App Manager required for distribution
```

---

## Signing Best Practices

```
┌─────────────────────────────────────────────────────────────┐
│              SIGNING SECURITY CHECKLIST                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  NEVER:                                                      │
│  ✗ Commit keys/keystores to git                             │
│  ✗ Share passwords in plain text                            │
│  ✗ Use weak passwords                                       │
│  ✗ Store keys on shared computers                           │
│                                                              │
│  ALWAYS:                                                     │
│  ✓ Add key.properties to .gitignore                         │
│  ✓ Backup keys in secure location                           │
│  ✓ Use strong, unique passwords                             │
│  ✓ Document key locations securely                          │
│  ✓ Use Google Play App Signing                              │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### .gitignore for Keys

```gitignore
# .gitignore

# Android
android/key.properties
*.jks
*.keystore

# iOS
ios/*.mobileprovision
*.p12
*.cer

# Environment files
.env
.env.local
```

---

## Key Storage Options

```
WHERE TO STORE YOUR KEYS:

PERSONAL PROJECTS:
├── Password manager (1Password, LastPass)
├── Encrypted USB drive
└── Printed and in a safe

TEAM PROJECTS:
├── Secrets manager (AWS Secrets, HashiCorp Vault)
├── Team password manager
└── CI/CD secrets (GitHub Secrets, etc.)

ENTERPRISE:
├── Hardware Security Module (HSM)
├── Dedicated secrets management
└── Audit logging

┌─────────────────────────────────────────────────────────────┐
│                                                              │
│  MINIMUM BACKUP STRATEGY:                                    │
│                                                              │
│  1. Keystore file → Cloud storage (encrypted)               │
│  2. Passwords → Password manager                            │
│  3. Recovery info → Written down, in a safe                 │
│                                                              │
│  Test your backups! Can you restore and sign?               │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                 APP SIGNING SUMMARY                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ANDROID:                                                    │
│  ├── Create keystore with keytool                           │
│  ├── Configure key.properties                               │
│  ├── Update build.gradle                                    │
│  └── Use Google Play App Signing (recommended)              │
│                                                              │
│  iOS:                                                        │
│  ├── Apple Developer Account required                       │
│  ├── Certificates + Provisioning Profiles                   │
│  ├── Configure in Xcode                                     │
│  └── Automatic signing is easiest                           │
│                                                              │
│  BOTH PLATFORMS:                                             │
│  ├── Keep keys SECURE                                       │
│  ├── BACKUP everything                                      │
│  ├── Never commit to git                                    │
│  └── Document locations safely                              │
│                                                              │
│  ⚠️  REMEMBER:                                               │
│  Lost key = Can't update app = Start over                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

**Next:** `03-BuildingForProduction.md` - Creating release builds
