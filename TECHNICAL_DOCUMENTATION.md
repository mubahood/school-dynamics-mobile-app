# School Dynamics - Flutter Mobile Application Documentation

## Project Overview

**School Dynamics Mobile App** is a cross-platform Flutter application that serves as the mobile client for the School Dynamics School Management System. It provides a comprehensive mobile interface for students, teachers, parents, and school administrators to access and manage academic information, attendance, finances, and communication.

## Architecture & Technology Stack

### Core Technologies

- **Framework**: Flutter SDK >=3.1.2 <4.0.0
- **Language**: Dart
- **Version**: 3.0.23+23
- **State Management**: GetX (get: ^4.7.2)
- **Local Database**: SQLite (sqflite: ^2.4.2)
- **HTTP Client**: Dio (dio: ^4.0.4)
- **UI Framework**: FlutX (flutx: ^0.2.0-rc.4)

### Key Dependencies

#### Core Functionality
- **Navigation & State Management**: GetX for routing, state management, and dependency injection
- **Local Storage**: sqflite for local database, shared_preferences for app settings
- **Network**: dio for HTTP requests, internet_connection_checker_plus for connectivity
- **Forms**: flutter_form_builder with form_builder_validators

#### UI & UX
- **Design System**: FlutX for consistent UI components
- **Icons**: flutter_feather_icons, material_design_icons_flutter
- **Images**: cached_network_image for efficient image caching
- **Fonts**: google_fonts for typography
- **Loading States**: shimmer for skeleton loading, flutter_easyloading for overlays

#### Features & Integrations
- **PDF Viewing**: syncfusion_flutter_pdfviewer for report cards and documents
- **QR Code**: mobile_scanner, qr_code_scanner_plus for attendance and identification
- **Push Notifications**: onesignal_flutter for real-time notifications
- **File Operations**: image_picker, path_provider for media handling
- **Authentication**: google_sign_in for social login
- **Sharing**: share_plus for content sharing

## Application Architecture

### MVVM Pattern with GetX

The app follows a clean architecture pattern using GetX:

```
lib/
├── main.dart                 # App entry point
├── controllers/             # Business logic & state management
├── models/                  # Data models
├── screens/                 # UI screens
├── sections/                # Reusable UI components  
├── theme/                   # App theming
├── utils/                   # Utilities & helpers
└── windows/                 # Platform-specific code
```

### State Management

#### GetX Controllers
- **MainController**: Central app state and data management
- **FullAppController**: Navigation and tab management
- **SectionDashboardController**: Dashboard state management

#### Reactive Programming
- Uses GetX reactive variables (RxList, Rx) for automatic UI updates
- Dependency injection for service management
- Route management through GetX navigation

## Core Modules & Features

### 1. Authentication & User Management

#### Login System
- **Screens**: `OnBoardingScreen`, `LoginScreen`
- **Features**:
  - Google Sign-In integration
  - JWT token management
  - Offline login capability
  - Multi-tenant support (enterprise selection)

#### User Profiles
- **Models**: `LoggedInUserModel`, `UserModel`
- **Features**:
  - Role-based access (student, teacher, parent, admin)
  - Profile management and editing
  - Bio-data management with guardian information

### 2. Dashboard & Navigation

#### Main Dashboard
- **Screen**: `SectionDashboard`
- **Features**:
  - Role-based menu items
  - Quick access to key features
  - Statistics and overview widgets
  - Dynamic menu based on user permissions

#### Navigation System
- **Implementation**: Bottom tab navigation with `FullApp`
- **Tabs**: Dashboard, Cases, Transactions, Exhibits, Account
- **Features**: 
  - Persistent navigation state
  - Badge notifications for pending items

### 3. Student Management

#### Student Profiles
- **Screens**: `StudentScreen`, `StudentsScreen`
- **Features**:
  - Comprehensive student information display
  - Photo management and updates
  - Guardian information editing
  - Academic class and stream information

#### Student Operations
- **Screens**: 
  - `StudentEditBioScreen` - Edit biographical information
  - `StudentEditGuardianScreen` - Manage guardian details
  - `StudentEditPhotoScreen` - Update profile photos
- **Features**:
  - Form validation and submission
  - Image capture and upload
  - Real-time updates

### 4. Academic Management

#### Class Management
- **Screens**: `ClassScreen`, `ClassesScreen`
- **Models**: `MyClasses`, `StudentHasClassModel`
- **Features**:
  - Class information display
  - Student lists per class
  - Teacher assignments
  - Stream management

#### Subject Management
- **Models**: `MySubjects`, `ExamAndSubjectModel`
- **Features**:
  - Subject listing and details
  - Teacher assignments
  - Exam scheduling and marks

### 5. Attendance System

#### Digital Attendance
- **Screens**: 
  - `AttendanceScreen` - Main attendance interface
  - `SessionCreateNewScreen` - Create new attendance sessions
  - `SessionRollCallingScreen` - Conduct roll calls
  - `QRCodeScannerScreen` - QR code-based attendance

#### Session Management
- **Models**: `SessionLocal`, `Participant`
- **Features**:
  - Multiple attendance types (class, theology, reports)
  - QR code scanning for quick attendance
  - Offline attendance with sync capability
  - Real-time attendance tracking

### 6. Financial Management

#### School Fees
- **Screens**: 
  - `FinancialAccountsScreen` - Account management
  - `FinanceHomeScreen` - Financial dashboard
  - `ServiceSubscriptionCreateScreen` - Service management
- **Features**:
  - Fee balance tracking
  - Payment history
  - Service subscriptions
  - Financial statements

#### Verification System
- **Screens**: `StudentsVerificationScreen`, `StudentsVerificationFormScreen`
- **Models**: `StudentVerificationModel`
- **Features**:
  - Student account verification
  - Financial status verification
  - Batch processing capabilities

### 7. Examination & Assessment

#### Report Cards
- **Models**: `StudentReportCard`
- **Screens**: `PdfViewerScreen` for report viewing
- **Features**:
  - Digital report card generation
  - PDF viewing and sharing
  - Grade tracking and analytics
  - Termly and annual reports

#### Marks Management
- **Screens**: `MarksScreen`
- **Features**:
  - Mark entry and editing
  - Grade calculations
  - Subject-wise performance tracking

### 8. Communication & News

#### School News
- **Screens**: `NewsHomeScreen`
- **Models**: Post models for content management
- **Features**:
  - School announcements
  - News feed
  - Push notifications for important updates

#### Messaging System
- **Features**:
  - Direct messaging between stakeholders
  - Group communications
  - File and media sharing

### 9. Transport Management

#### Transport System
- **Screens**: `TransportHomeScreen`
- **Features**:
  - Route management
  - Vehicle tracking
  - Student transport subscriptions
  - Driver communications

### 10. Employee Management

#### Staff Operations
- **Screens**: `EmployeeCreateScreen`
- **Features**:
  - Employee registration and management
  - Educational background tracking
  - Professional information management
  - Document management

## Data Management

### Local Database (SQLite)

#### Data Models
- **Base Structure**: All models extend base classes with common methods
- **Synchronization**: Automatic sync between local and remote data
- **Offline Support**: Full offline functionality with sync on connectivity

#### Key Tables
```dart
UserModel.tableName = "my_students_10"
MyClasses.tableName = "academic_classes"
SessionLocal.tableName = "sessions_local"
Participant.tableName = "participants"
```

### API Integration

#### HTTP Client Configuration
- **Base URL**: Configurable API endpoint
- **Authentication**: JWT token-based authentication
- **Error Handling**: Comprehensive error handling and retry logic
- **Caching**: Request caching for offline support

#### Data Synchronization
- **Bidirectional Sync**: Local changes sync to server
- **Conflict Resolution**: Smart conflict resolution for concurrent edits
- **Background Sync**: Automatic syncing when connectivity is restored

## Security Features

### Authentication Security
- **JWT Tokens**: Secure token-based authentication
- **Token Refresh**: Automatic token renewal
- **Biometric Support**: Device biometric authentication (planned)
- **Session Management**: Secure session handling

### Data Protection
- **Local Encryption**: SQLite database encryption
- **Network Security**: HTTPS-only communication
- **Input Validation**: Comprehensive form validation
- **XSS Prevention**: Input sanitization

## UI/UX Design

### Design System

#### Theme Management
- **Custom Themes**: `CustomTheme` class for consistent styling
- **Color Schemes**: Primary, secondary, and accent colors
- **Typography**: Google Fonts integration
- **Dark Mode**: Support for light/dark themes

#### Component Library
- **Reusable Widgets**: Comprehensive widget library in `sections/widgets.dart`
- **Form Components**: Standardized form inputs and validation
- **Navigation Components**: Consistent navigation patterns
- **Loading States**: Skeleton loading and progress indicators

### Responsive Design
- **Adaptive Layout**: Responsive design for different screen sizes
- **Platform Optimization**: iOS and Android-specific optimizations
- **Accessibility**: Built-in accessibility support

## Platform Support

### Multi-Platform Architecture
```
platforms/
├── android/          # Android-specific configurations
├── ios/              # iOS-specific configurations  
├── linux/            # Linux desktop support
├── macos/            # macOS desktop support
├── web/              # Web platform support
└── windows/          # Windows desktop support
```

### Platform Features
- **Android**: Material Design, Android Auto support
- **iOS**: Cupertino design, iOS integration
- **Desktop**: Native desktop app experience
- **Web**: PWA capabilities for web deployment

## Performance Optimizations

### App Performance
- **Lazy Loading**: On-demand loading of heavy components
- **Image Caching**: Efficient image caching with `cached_network_image`
- **Memory Management**: Proper disposal of controllers and streams
- **Build Optimization**: Code splitting and tree shaking

### Network Optimization
- **Request Batching**: Batch API requests for efficiency
- **Compression**: Request/response compression
- **Caching Strategy**: Multi-level caching (memory, disk, network)
- **Offline Support**: Full offline capability with smart sync

## Development & Deployment

### Build Configuration
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/
    - assets/images/
    - assets/icons/
```

### Development Workflow
- **Hot Reload**: Fast development iteration
- **Debugging**: Comprehensive debugging tools
- **Testing**: Unit and widget testing support
- **CI/CD**: Automated build and deployment pipeline

### Distribution
- **Android**: Google Play Store distribution
- **iOS**: App Store distribution  
- **Web**: Progressive Web App deployment
- **Desktop**: Native desktop app distribution

## Integration Capabilities

### External Services
- **OneSignal**: Push notification service
- **Google Services**: Sign-in and Firebase integration
- **Payment Gateways**: Integration with school payment systems
- **Cloud Storage**: File storage and synchronization

### API Integration
- **RESTful APIs**: Full REST API integration
- **Real-time Updates**: WebSocket support for live updates
- **Webhook Support**: Handling server-side events
- **Third-party APIs**: Integration with external education platforms

## Quality Assurance

### Testing Strategy
- **Unit Tests**: Business logic testing
- **Widget Tests**: UI component testing  
- **Integration Tests**: End-to-end testing
- **Performance Testing**: App performance benchmarking

### Code Quality
- **Linting**: Dart analysis and linting
- **Code Formatting**: Consistent code formatting
- **Documentation**: Comprehensive inline documentation
- **Best Practices**: Following Flutter best practices

## Future Enhancements

### Planned Features
- **AI Integration**: Smart recommendations and insights
- **Advanced Analytics**: Detailed performance analytics
- **Multi-language Support**: Localization for global markets
- **Voice Commands**: Voice-controlled navigation
- **Augmented Reality**: AR features for enhanced learning

### Scalability
- **Microservices**: Modular architecture for easy scaling
- **Cloud Integration**: Enhanced cloud service integration
- **Performance Monitoring**: Real-time performance tracking
- **A/B Testing**: Feature testing and optimization

This Flutter mobile application provides a comprehensive, user-friendly interface for the School Dynamics ecosystem, enabling seamless access to school management features across all stakeholders while maintaining high performance and security standards.
