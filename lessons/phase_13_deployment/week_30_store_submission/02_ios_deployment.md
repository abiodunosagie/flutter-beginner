# iOS Deployment: Complete App Store Guide

## Prerequisites
- Mac computer
- Apple Developer Account ($99/year)
- Xcode installed

## Step 1: Configure App in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target
3. Set Team (your Apple Developer account)
4. Set Bundle Identifier (com.yourcompany.yourapp)
5. Update Version and Build number

## Step 2: App Icons

Use Asset Catalog in Xcode:
- Assets.xcassets → AppIcon
- Drag 1024x1024 icon

## Step 3: Build for Release

```bash
flutter build ios --release
```

## Step 4: Archive in Xcode

1. Product → Archive
2. Wait for archive to complete
3. Click "Distribute App"
4. Choose "App Store Connect"
5. Upload

## Step 5: App Store Connect

1. Create app in App Store Connect
2. Fill in app information
3. Upload screenshots
4. Submit for review

## Common Issues

### Code Signing
Ensure certificates and provisioning profiles are valid

### Missing Compliance
Add NSAppTransportSecurity to Info.plist if needed

You're ready for the App Store! 🚀
