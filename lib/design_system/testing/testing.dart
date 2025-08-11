/// Comprehensive testing package for Flutter applications
///
/// This package provides:
/// - Cross-platform device and screen testing
/// - User acceptance testing with real scenarios
/// - Performance testing on low-end devices
/// - Network condition validation
/// - Stakeholder feedback collection
/// - Improvement metrics tracking
///
/// Usage:
/// ```dart
/// import 'package:school_dynamics/design_system/testing/testing.dart';
///
/// // Run cross-platform tests
/// final deviceReport = await CrossPlatformTestingFramework.devices.testAndroidDevices(
///   app: MyApp(),
/// );
///
/// // Conduct usability testing
/// final usabilityReport = await UserAcceptanceTestingFramework.usability.conductUsabilityTesting(
///   scenarios: UsabilityTesting.getDefaultTestScenarios(),
/// );
///
/// // Test network conditions
/// final networkReport = await CrossPlatformTestingFramework.network.testNetworkConditions(
///   app: MyApp(),
/// );
/// ```
library testing;

export 'cross_platform_testing.dart';
export 'user_acceptance_testing.dart';
