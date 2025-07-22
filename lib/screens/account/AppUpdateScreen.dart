import 'dart:ui'; // For ImageFilter

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart'; // For icons
import 'package:flutx/flutx.dart'; // Assuming FxText, FxButton are used
import 'package:get/get.dart';
import 'package:schooldynamics/models/EnterpriseModel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/custom_theme.dart';
import '../../utils/AppConfig.dart'; // For launching URLs

class AppUpdateScreen extends StatefulWidget {
  EnterpriseModel ent = EnterpriseModel();

  AppUpdateScreen(this.ent, {super.key});

  @override
  State<AppUpdateScreen> createState() => _AppUpdateScreenState();
}

class _AppUpdateScreenState extends State<AppUpdateScreen> {
  String? _error;

  // --- Colors ---
  late Color _accentColor;
  late Color _primaryColor;
  late Color _textColor;
  late Color _textMutedColor;

  @override
  void initState() {
    super.initState();
    _setupColors();
    _fetchManifest();
  }

  void _setupColors() {
    _accentColor = CustomTheme.accent;
    _primaryColor = CustomTheme.primary;
    _textColor = Colors.white; // Default text color
    _textMutedColor = Colors.white70;
  }

  Future<void> _fetchManifest() async {
    // Ensure state is updated within setState
    setState(() {
      _error = null;
    });
    try {
      final data = widget.ent;
    } catch (e) {
      print("Error fetching manifest: $e"); // Log error
      if (mounted) {
        setState(() {
          _error = 'Failed to check for updates.';
        });
      }
    }
  }

  Future<void> _launchUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      _showSnackbar('Error', 'Download link is not available.');
      return;
    }
    final Uri? url = Uri.tryParse(urlString);
    if (url == null) {
      _showSnackbar('Error', 'Invalid download link format.');
      return;
    }

    try {
      // Use canLaunchUrl and launchUrl (newer methods)
      if (await canLaunchUrl(url)) {
        // mode: LaunchMode.externalApplication is often preferred for store/whatsapp links
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showSnackbar('Error', 'Could not open the link.');
      }
    } catch (e) {
      print("Error launching URL: $e");
      _showSnackbar('Error', 'Could not open the link.');
    }
  }

  void _showSnackbar(String title, String message, {bool isError = true}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError
          ? Colors.redAccent.withOpacity(0.9)
          : Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(12),
      icon: Icon(isError ? FeatherIcons.alertCircle : FeatherIcons.checkCircle,
          color: Colors.white, size: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true, // Allow body to draw behind AppBar
      backgroundColor: _primaryColor, // Base background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // Make AppBar transparent
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          // Light status bar icons
          statusBarColor: Colors.transparent, // Transparent status bar
          systemNavigationBarColor: _primaryColor.withOpacity(0.8),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: Icon(FeatherIcons.arrowLeft, color: _accentColor),
          // Use Feather icon
          tooltip: "Back",
          onPressed: () => Get.back(),
        ),
        title: FxText.titleLarge('Update Available',
            color: _accentColor, fontWeight: 700),
      ),
      body: Stack(
        // Use Stack for background and foreground content
        children: [
          // _buildBackground(),  // Background Image
          _buildGradientOverlay(), // Darkening Gradient Overlay
          // Center the main content, handling loading/error states
          Center(
            child: false
                ? CircularProgressIndicator(color: _accentColor)
                : _error != null
                    ? _buildErrorView(textTheme, _error!)
                    : _buildGlassContent(
                        textTheme), // Build glass UI when loaded
          ),
        ],
      ),
    );
  }

  // --- Background and Overlay ---

  Widget _buildBackground() {
    // Consistent background with other screens (e.g., Login)
    return Positioned.fill(
      child: Image.asset(
        'assets/images/bg.jpg', // Ensure this path is correct
        fit: BoxFit.cover,
        color: Colors.black.withOpacity(0.1), // Optional darkening
        colorBlendMode: BlendMode.darken,
      ),
    );
  }

  Widget _buildGradientOverlay() {
    // Consistent gradient overlay
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: const [0.0, 0.7, 1.0],
            colors: [
              _primaryColor.withOpacity(0.95),
              _primaryColor.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  // --- Main Content Area (Glass) ---

  Widget _buildGlassContent(TextTheme textTheme) {
    EnterpriseModel m = widget.ent;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: _buildGlassContainer(
        // Wrap content in glass effect
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min, // Prevent column stretching
          children: [
            // App Logo
            Center(
              child: Image.asset(
                AppConfig.logo_1, // Ensure AppConfig.logo_1 path is correct
                height: 80, // Adjust size as needed
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),

            // Update Banner Text
            Center(
              child: FxText(
                'New Version Available!',
                style: textTheme.headlineSmall?.copyWith(
                  color: _accentColor, // Use accent color
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: FxText(
                'Version ${m.update_version}', // Display version number
                style: textTheme.titleMedium?.copyWith(
                  color: _textColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 28),

            // Release Notes Section
            FxText('What’s New:',
                style: textTheme.titleMedium?.copyWith(
                    color: _textMutedColor, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                // Darker background inside glass
                borderRadius: BorderRadius.circular(12),
              ),
              child: FxText(
                'Bug fixes and performance improvements.',
                style: textTheme.bodyMedium
                    ?.copyWith(color: _textMutedColor, height: 1.5),
              ),
            ),
            const SizedBox(height: 32),

            // Download Buttons
            _buildDownloadButton(
              label: 'Download for Android',
              icon: Icons.android,
              // Standard Android icon
              color: Colors.green.shade600,
              // Android green
              onPressed: () => _launchUrl(m.ANDROID_LINK),
              textTheme: textTheme,
            ),
            const SizedBox(height: 16),
            _buildDownloadButton(
              label: 'Download for iOS',
              icon: Icons.apple,
              // Standard Apple icon
              color: Colors.blue.shade600,
              // Apple blue
              onPressed: () => _launchUrl(m.IOS_LINK),
              textTheme: textTheme,
            ),
            const SizedBox(height: 16),
            _buildDownloadButton(
              label: 'Need Help? WhatsApp Us',
              icon: FeatherIcons.messageCircle,
              // WhatsApp style icon
              color: Colors.teal.shade600,
              // WhatsApp teal
              onPressed: () {
                // Ensure number format is correct (e.g., includes country code without +)
                final number = '+256783204665'.replaceAll('+', '');
                final waUrl = 'https://wa.me/$number';
                _launchUrl(waUrl);
              },
              textTheme: textTheme,
            ),
          ],
        ),
      ),
    );
  }

  /// Helper to build the glass container effect.
  Widget _buildGlassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1), // Glass background color
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                color: Colors.white.withOpacity(0.15)), // Glass border
          ),
          child: child,
        ),
      ),
    );
  }

  /// Helper to build styled download buttons.
  Widget _buildDownloadButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required TextTheme textTheme,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white, size: 22),
      label: FxText(label,
          style: textTheme.bodyLarge
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        // Button specific color
        foregroundColor: Colors.white,
        // Icon/Text color
        padding: const EdgeInsets.symmetric(vertical: 16),
        // Button padding
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        shadowColor: color.withOpacity(0.4),
      ),
    );
  }

  // --- Loading / Error Views ---

  Widget _buildErrorView(TextTheme textTheme, String errorMessage) {
    // Simple centered error display
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FeatherIcons.alertCircle, color: Colors.redAccent, size: 40),
            const SizedBox(height: 16),
            FxText(errorMessage,
                style: textTheme.bodyLarge?.copyWith(color: _textMutedColor),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FxButton.outlined(
              onPressed: _fetchManifest,
              borderColor: _accentColor,
              borderRadiusAll: 8,
              child: FxText('Retry', color: _accentColor),
            )
          ],
        ),
      ),
    );
  }
}
