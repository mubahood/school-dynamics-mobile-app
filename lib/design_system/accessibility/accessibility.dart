/// Comprehensive accessibility package for Flutter applications
///
/// This package provides:
/// - Screen reader support and semantic labeling
/// - Visual accessibility with contrast and focus management
/// - Motor accessibility with touch targets and gesture alternatives
/// - Comprehensive testing framework for accessibility validation
///
/// Usage:
/// ```dart
/// import 'package:school_dynamics/design_system/accessibility/accessibility.dart';
///
/// // Use accessibility utilities
/// AccessibilitySystem.screenReader.announceMessage('Loading complete');
///
/// // Create accessible UI components
/// VisualAccessibilitySystem.focus.addFocusIndicator(
///   child: MyButton(),
/// );
///
/// // Ensure proper touch targets
/// MotorAccessibilitySystem.touchTargets.accessibleButton(
///   child: Text('Submit'),
///   onPressed: () {},
/// );
///
/// // Run accessibility tests
/// final report = await AccessibilityTestingFramework.audit.performAudit(
///   widget: MyWidget(),
/// );
/// ```
library accessibility;

export 'accessibility_system.dart';
export 'visual_accessibility.dart' hide AccessibilityReport;
export 'motor_accessibility.dart';
export 'accessibility_testing.dart';
