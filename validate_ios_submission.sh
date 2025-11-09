#!/bin/bash

# iOS App Store Pre-Submission Validation Script
# Run this before every App Store submission to catch common issues

echo "🔍 School Dynamics - iOS Pre-Submission Validation"
echo "=================================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Check 1: Info.plist Required Permissions
echo "📋 Checking Info.plist permissions..."
INFOPLIST_PATH="ios/Runner/Info.plist"

required_permissions=(
    "NSCameraUsageDescription"
    "NSPhotoLibraryUsageDescription"
    "NSPhotoLibraryAddUsageDescription"
    "NSLocationWhenInUseUsageDescription"
)

for permission in "${required_permissions[@]}"; do
    if grep -q "$permission" "$INFOPLIST_PATH"; then
        echo -e "  ${GREEN}✓${NC} $permission found"
    else
        echo -e "  ${RED}✗${NC} $permission MISSING"
        ((ERRORS++))
    fi
done

# Check 2: Version Consistency
echo ""
echo "🔢 Checking version consistency..."

# Get version from pubspec.yaml
PUBSPEC_VERSION=$(grep "^version:" pubspec.yaml | awk '{print $2}')
echo "  pubspec.yaml: $PUBSPEC_VERSION"

# Get versions from project.pbxproj
MARKETING_VERSIONS=$(grep "MARKETING_VERSION = " ios/Runner.xcodeproj/project.pbxproj | awk -F' = ' '{print $2}' | tr -d ';' | sort -u)
PROJECT_VERSIONS=$(grep "CURRENT_PROJECT_VERSION = " ios/Runner.xcodeproj/project.pbxproj | awk -F' = ' '{print $2}' | tr -d ';' | sort -u)

# Extract version and build from pubspec
PUBSPEC_VERSION_NUM=$(echo $PUBSPEC_VERSION | cut -d'+' -f1)
PUBSPEC_BUILD_NUM=$(echo $PUBSPEC_VERSION | cut -d'+' -f2)

echo "  Expected Marketing Version: $PUBSPEC_VERSION_NUM"
echo "  Expected Build Number: $PUBSPEC_BUILD_NUM"

# Check if all marketing versions match
UNIQUE_MARKETING=$(echo "$MARKETING_VERSIONS" | wc -l)
if [ "$UNIQUE_MARKETING" -eq 1 ] && echo "$MARKETING_VERSIONS" | grep -q "$PUBSPEC_VERSION_NUM"; then
    echo -e "  ${GREEN}✓${NC} Marketing versions consistent"
else
    echo -e "  ${RED}✗${NC} Marketing version mismatch!"
    echo "    Found: $MARKETING_VERSIONS"
    ((ERRORS++))
fi

# Check if all build versions match
UNIQUE_BUILD=$(echo "$PROJECT_VERSIONS" | wc -l)
if [ "$UNIQUE_BUILD" -eq 1 ] && echo "$PROJECT_VERSIONS" | grep -q "$PUBSPEC_BUILD_NUM"; then
    echo -e "  ${GREEN}✓${NC} Build numbers consistent"
else
    echo -e "  ${RED}✗${NC} Build number mismatch!"
    echo "    Found: $PROJECT_VERSIONS"
    ((ERRORS++))
fi

# Check 3: Bundle Identifier
echo ""
echo "📦 Checking bundle identifier..."
BUNDLE_ID=$(grep "PRODUCT_BUNDLE_IDENTIFIER" ios/Runner.xcodeproj/project.pbxproj | head -1 | awk -F' = ' '{print $2}' | tr -d ';')
if [ "$BUNDLE_ID" = "schooldynamics.ug" ]; then
    echo -e "  ${GREEN}✓${NC} Bundle ID correct: $BUNDLE_ID"
else
    echo -e "  ${YELLOW}⚠${NC} Bundle ID: $BUNDLE_ID (expected: schooldynamics.ug)"
    ((WARNINGS++))
fi

# Check 4: Development Team
echo ""
echo "👥 Checking development team..."
DEV_TEAM=$(grep "DEVELOPMENT_TEAM = " ios/Runner.xcodeproj/project.pbxproj | head -1 | awk -F' = ' '{print $2}' | tr -d ';')
if [ "$DEV_TEAM" = "G23MGVX9R5" ]; then
    echo -e "  ${GREEN}✓${NC} Development Team: $DEV_TEAM"
else
    echo -e "  ${RED}✗${NC} Development Team: $DEV_TEAM (expected: G23MGVX9R5)"
    ((ERRORS++))
fi

# Check 5: Code Signing
echo ""
echo "🔐 Checking code signing..."
CODE_SIGN_IDENTITY=$(grep "CODE_SIGN_IDENTITY" ios/Runner.xcodeproj/project.pbxproj | grep -v "/\*" | head -1 | awk -F'"' '{print $2}')
if [ -n "$CODE_SIGN_IDENTITY" ]; then
    echo -e "  ${GREEN}✓${NC} Code signing identity set: $CODE_SIGN_IDENTITY"
else
    echo -e "  ${YELLOW}⚠${NC} Code signing identity not explicitly set"
    ((WARNINGS++))
fi

# Check 6: Dependencies
echo ""
echo "📚 Checking Flutter dependencies..."
if [ -f "pubspec.lock" ]; then
    echo -e "  ${GREEN}✓${NC} pubspec.lock exists"
else
    echo -e "  ${RED}✗${NC} pubspec.lock missing - run 'flutter pub get'"
    ((ERRORS++))
fi

if [ -f "ios/Podfile.lock" ]; then
    echo -e "  ${GREEN}✓${NC} Podfile.lock exists"
else
    echo -e "  ${RED}✗${NC} Podfile.lock missing - run 'cd ios && pod install'"
    ((ERRORS++))
fi

# Check 7: Clean build check
echo ""
echo "🧹 Checking for clean build state..."
if [ -d "build/ios" ]; then
    echo -e "  ${YELLOW}⚠${NC} Build directory exists (consider 'flutter clean')"
    ((WARNINGS++))
else
    echo -e "  ${GREEN}✓${NC} No existing build directory"
fi

# Check 8: App Icon
echo ""
echo "🎨 Checking app icon..."
ICON_PATH="ios/Runner/Assets.xcassets/AppIcon.appiconset"
if [ -d "$ICON_PATH" ]; then
    ICON_COUNT=$(find "$ICON_PATH" -name "*.png" | wc -l)
    if [ "$ICON_COUNT" -gt 0 ]; then
        echo -e "  ${GREEN}✓${NC} App icons found ($ICON_COUNT images)"
    else
        echo -e "  ${RED}✗${NC} No app icon images found"
        ((ERRORS++))
    fi
else
    echo -e "  ${RED}✗${NC} AppIcon.appiconset directory missing"
    ((ERRORS++))
fi

# Summary
echo ""
echo "=================================================="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All critical checks passed!${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠️  $WARNINGS warning(s) found${NC}"
    fi
    echo ""
    echo "Next steps:"
    echo "1. Run: flutter clean && flutter pub get"
    echo "2. Run: cd ios && pod install"
    echo "3. Open Xcode: open ios/Runner.xcworkspace"
    echo "4. Archive and upload to App Store Connect"
    exit 0
else
    echo -e "${RED}❌ $ERRORS error(s) found${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠️  $WARNINGS warning(s) found${NC}"
    fi
    echo ""
    echo "Please fix the errors above before submitting to App Store"
    exit 1
fi
