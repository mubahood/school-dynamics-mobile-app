# iOS App Store Submission Checklist

## Critical Requirements Before Each Submission

### 1. Info.plist Privacy Permissions ✅
**Location:** `ios/Runner/Info.plist`

All required privacy permission strings are now included:

#### Camera & Media Access
- ✅ `NSCameraUsageDescription` - Required for QR scanning, photo capture
- ✅ `NSPhotoLibraryUsageDescription` - Required for accessing photo library
- ✅ `NSPhotoLibraryAddUsageDescription` - Required for saving photos (iOS 14+)

#### Location Services
- ✅ `NSLocationWhenInUseUsageDescription` - Location while app is in use
- ✅ `NSLocationAlwaysUsageDescription` - Background location access
- ✅ `NSLocationAlwaysAndWhenInUseUsageDescription` - Combined location permission

### 2. Version Number Consistency ✅
Ensure version numbers match across all files:
- `pubspec.yaml` → `version: 3.0.24+24`
- `ios/Runner.xcodeproj/project.pbxproj` → `MARKETING_VERSION = 3.0.24`
- `ios/Runner.xcodeproj/project.pbxproj` → `CURRENT_PROJECT_VERSION = 24`

### 3. Build Configuration Check
Before submitting, verify:
- [ ] All three build configurations have matching versions:
  - Debug configuration
  - Release configuration  
  - Profile configuration
- [ ] Code signing identity is correct: "Apple Development" or "Apple Distribution"
- [ ] Development team ID is set: `G23MGVX9R5`
- [ ] Bundle identifier is correct: `schooldynamics.ug`

### 4. Pre-Submission Testing
- [ ] Test app on physical iOS device
- [ ] Test all camera/photo features
- [ ] Test QR code scanning functionality
- [ ] Test location-based attendance features
- [ ] Verify push notifications work (OneSignal)
- [ ] Check app doesn't crash on launch
- [ ] Test in both portrait and landscape modes

### 5. App Store Connect Metadata
- [ ] App version matches build version
- [ ] Screenshots are up-to-date (if features changed)
- [ ] What's New in This Version is filled
- [ ] Privacy policy URL is accessible: https://www.freeprivacypolicy.com/live/0ace623e-1852-4825-a38f-12af735fcdfe
- [ ] Account deletion form is accessible: https://forms.gle/eRZuEqzkcEDyros28

### 6. Common Rejection Reasons to Avoid

#### ITMS-90683: Missing Purpose String
**Solution:** All required permission strings are now in Info.plist

#### ITMS-90717: Invalid App Store Icon
**Solution:** Verify icon at `assets/images/logo.png` meets requirements:
- 1024x1024 pixels
- No transparency
- No rounded corners

#### Version Mismatch
**Solution:** Run this command before building:
```bash
flutter clean && flutter pub get
cd ios && pod install
```

### 7. Build & Archive Process

#### Step 1: Clean Build
```bash
cd /Users/mac/Desktop/github/school_dynamics
flutter clean
flutter pub get
```

#### Step 2: Update iOS Dependencies
```bash
cd ios
pod install
pod update
```

#### Step 3: Open Xcode
```bash
open /Users/mac/Desktop/github/school_dynamics/ios/Runner.xcworkspace
```

#### Step 4: In Xcode
1. Select "Any iOS Device (arm64)" as target
2. Product → Clean Build Folder (Cmd+Shift+K)
3. Product → Archive
4. Window → Organizer
5. Select archive → Distribute App
6. App Store Connect → Upload

### 8. Post-Upload Verification
- [ ] Check App Store Connect for processing status
- [ ] Review any new warnings from Apple
- [ ] Verify build appears in TestFlight within 15 minutes
- [ ] Test build via TestFlight before submitting for review

## Current App Information
- **App Name:** School Dynamics
- **Bundle ID:** schooldynamics.ug
- **Apple ID:** 6469381244
- **Current Version:** 3.0.24
- **Build Number:** 24
- **Team ID:** G23MGVX9R5

## Dependencies Requiring Permissions
Based on `pubspec.yaml`:
- `image_picker: ^1.1.2` → Requires Camera & Photo Library
- `mobile_scanner: ^7.0.0` → Requires Camera
- `qr_code_scanner_plus: ^2.0.10+1` → Requires Camera
- `geolocator: ^13.0.2` → Requires Location Services
- `onesignal_flutter: ^5.2.6` → Requires Push Notifications

## Quick Reference: Permission Keys
If you add new features requiring permissions, add these to Info.plist:

```xml
<!-- Microphone -->
<key>NSMicrophoneUsageDescription</key>
<string>Reason here</string>

<!-- Contacts -->
<key>NSContactsUsageDescription</key>
<string>Reason here</string>

<!-- Calendar -->
<key>NSCalendarsUsageDescription</key>
<string>Reason here</string>

<!-- Bluetooth -->
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Reason here</string>

<!-- Face ID -->
<key>NSFaceIDUsageDescription</key>
<string>Reason here</string>
```

## Emergency Contact
If submission is rejected:
- **Contact:** +256783204665
- **Email:** info@schooldynamics.ug
- **Developer:** mubahood

---
**Last Updated:** November 9, 2025
**Last Successful Build:** 3.0.24 (Build 24)
**Issue Fixed:** ITMS-90683 - Added NSCameraUsageDescription
