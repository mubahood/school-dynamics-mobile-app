/// School Dynamics Design System
/// 
/// A unified design system providing consistent colors, typography,
/// spacing, and components for the School Dynamics app.
/// 
/// Usage:
/// ```dart
/// import 'package:schooldynamics/design_system/design_system.dart';
/// 
/// // Use colors
/// Container(color: AppColors.primary)
/// 
/// // Use typography
/// Text('Title', style: AppTypography.headlineMedium)
/// 
/// // Use spacing
/// Padding(padding: AppSpacing.allMD)
/// ```

library design_system;

// Core design tokens
export 'colors/app_colors.dart';
export 'typography/app_typography.dart';
export 'spacing/app_spacing.dart';

// Components
export 'components/app_input_decorations.dart';

// Components (to be added in Phase 2)
// export 'components/app_card.dart';
// export 'components/app_button.dart';
