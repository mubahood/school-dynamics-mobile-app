# School Dynamics Design System

## Overview

The School Dynamics Design System provides a unified approach to UI design and development for the educational platform. It ensures consistency, accessibility, and maintainability across the entire application.

## Core Principles

### 🎯 **Educational Focus**
- Design optimized for educational workflows
- Clear information hierarchy for academic data
- Accessible to all user types (students, teachers, admins)

### 🎨 **Brand Flexibility**
- Dynamic primary colors based on school branding
- Consistent semantic colors across all schools
- Professional appearance suitable for educational institutions

### ♿ **Accessibility First**
- WCAG 2.1 AA compliance
- Minimum 44x44dp touch targets
- High contrast ratios for readability

### 📱 **Mobile Optimized**
- Responsive design for all screen sizes
- Touch-friendly interactions
- Thumb-accessible navigation

## Design Tokens

### Colors (`lib/design_system/colors/app_colors.dart`)

#### Dynamic Primary Colors
- **Primary**: School-specific branding color
- **Primary Dark**: Darker variant for active states
- **Primary Light**: Lighter variant for backgrounds
- **Primary Surface**: Very light variant for surfaces

#### Semantic Colors
- **Success**: `#068425` - Positive actions and states
- **Warning**: `#FF9800` - Cautionary states
- **Error**: `#F44336` - Error states and destructive actions
- **Info**: `#2196F3` - Informational content

#### Educational Theme Colors
- **Academic**: `#6A1B9A` - Academic achievements and grades
- **Student**: `#388E3C` - Student-related activities
- **Admin**: `#1976D2` - Administrative functions
- **Finance**: `#E65100` - Financial operations

### Typography (`lib/design_system/typography/app_typography.dart`)

#### Font Families
- **Primary**: Inter (headings, titles, UI elements)
- **Secondary**: Roboto (body text, educational content)

#### Type Scale
- **Display Large**: 57px - Hero text and prominent headers
- **Display Medium**: 45px - Section headers
- **Display Small**: 36px - Subsection headers
- **Headline Large**: 32px - Page titles
- **Headline Medium**: 28px - Screen titles
- **Headline Small**: 24px - Card titles
- **Title Large**: 22px - Prominent titles
- **Title Medium**: 16px - Standard titles
- **Title Small**: 14px - Small titles and labels
- **Body Large**: 16px - Prominent body text
- **Body Medium**: 14px - Standard body text
- **Body Small**: 12px - Secondary body text
- **Label Large**: 14px - Button labels
- **Label Medium**: 12px - Standard labels
- **Label Small**: 11px - Small labels and captions

#### Educational Specific Styles
- **Grade Text**: 18px, weight 600 - For displaying grades
- **Student Name**: 16px, weight 500 - For student identification
- **Subject Text**: 14px, weight 500 - For academic subjects
- **Amount Text**: 16px, weight 600 - For financial amounts

### Spacing (`lib/design_system/spacing/app_spacing.dart`)

#### 8px Grid System
- **XS**: 4px - Minimal spacing
- **SM**: 8px - Small spacing
- **MD**: 16px - Medium spacing (default)
- **LG**: 24px - Large spacing
- **XL**: 32px - Extra large spacing
- **XXL**: 48px - Extra extra large spacing
- **XXXL**: 64px - Maximum spacing

#### Component Spacing
- **Card Padding**: 16px
- **Button Padding**: 24px horizontal, 8px vertical
- **Input Padding**: 16px
- **Screen Padding**: 16px
- **Section Spacing**: 32px

#### Border Radius
- **SM**: 4px - Small elements
- **MD**: 8px - Standard elements
- **LG**: 12px - Large elements
- **XL**: 16px - Extra large elements
- **Round**: 1000px - Fully rounded elements

#### Touch Targets
- **Minimum**: 44x44dp (accessibility requirement)
- **Standard**: 48x48dp (recommended)
- **Large**: 56x56dp (prominent actions)

## Component Architecture

### Base Components
Located in `lib/design_system/components/`

#### Planned Components
- **AppCard**: Unified card component with consistent styling
- **AppButton**: Button system with all variants
- **AppInput**: Input field with consistent theming
- **AppListItem**: Standardized list item layouts
- **SkeletonLoader**: Loading state components
- **AppBottomNav**: Navigation bar component

### Implementation Guidelines

#### Color Usage
```dart
// ✅ Correct usage
Container(
  color: AppColors.primary,
  child: Text(
    'Title',
    style: AppTypography.titleMedium.copyWith(
      color: AppColors.white,
    ),
  ),
)

// ❌ Avoid hardcoded colors
Container(
  color: Color(0xFF1976D2),
  child: Text('Title'),
)
```

#### Typography Usage
```dart
// ✅ Correct usage
Text(
  'Student Name',
  style: AppTypography.studentName,
)

// ✅ With color override
Text(
  'Error Message',
  style: AppTypography.bodyMedium.copyWith(
    color: AppColors.error,
  ),
)
```

#### Spacing Usage
```dart
// ✅ Correct usage
Padding(
  padding: AppSpacing.allMD,
  child: Column(
    children: [
      Widget1(),
      AppSpacing.gapMD,
      Widget2(),
    ],
  ),
)
```

### Migration Strategy

#### Phase 1: Foundation (Current)
- ✅ Create design system architecture
- ✅ Define color tokens
- ✅ Establish typography system
- ✅ Set up spacing constants

#### Phase 2: Component Creation
- Create base components
- Implement unified card system
- Build button component library
- Standardize input decorations

#### Phase 3: Integration
- Update existing components to use design tokens
- Migrate from hardcoded values
- Implement consistent styling

#### Phase 4: Enhancement
- Add dark mode support
- Implement accessibility features
- Optimize for performance

## Usage Examples

### School Branding Integration
```dart
// Update primary colors for a specific school
AppColors.updatePrimaryColors(
  newPrimary: Color(0xFF4CAF50), // School's brand color
);
```

### Responsive Typography
```dart
// Scale typography based on screen size
Text(
  'Title',
  style: AppTypography.responsive(
    baseStyle: AppTypography.headlineMedium,
    scaleFactor: MediaQuery.of(context).textScaleFactor,
  ),
)
```

### Accessibility Validation
```dart
// Check color contrast before using
if (AppColors.isAccessibleContrast(textColor, backgroundColor)) {
  // Use the color combination
} else {
  // Use alternative colors
}
```

## Best Practices

### Do's ✅
- Always use design tokens instead of hardcoded values
- Follow the 8px spacing grid
- Ensure minimum touch target sizes
- Use semantic color names
- Test with different school branding colors
- Validate accessibility compliance

### Don'ts ❌
- Don't hardcode colors or spacing values
- Don't create one-off component styles
- Don't ignore accessibility requirements
- Don't break the established visual hierarchy
- Don't use colors without semantic meaning

## Testing

### Visual Consistency
- Ensure all components use design tokens
- Validate consistent spacing throughout app
- Check typography hierarchy compliance

### Accessibility
- Test with screen readers
- Validate color contrast ratios
- Ensure touch target accessibility

### Brand Flexibility
- Test with different primary color schemes
- Validate visual consistency across brand variations
- Ensure readability with all supported colors

## Maintenance

### Design Token Updates
- Update tokens in respective files
- Test changes across all components
- Document breaking changes

### Component Evolution
- Follow established patterns when creating new components
- Ensure backward compatibility when possible
- Update documentation with new additions

### Performance Monitoring
- Monitor app performance after design system changes
- Optimize heavy components
- Implement lazy loading where appropriate
