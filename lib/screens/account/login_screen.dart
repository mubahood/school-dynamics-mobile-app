import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

import '../../../utils/Utils.dart';
import '../../controllers/MainController.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/RespondModel.dart';
import '../../theme/custom_theme.dart';
import '../OnBoardingScreen.dart';
import 'PasswordResetScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

Future<void> checkForUpdate() async {
  InAppUpdate.checkForUpdate().then((info) {
    try {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().catchError((e) {
          return AppUpdateResult.inAppUpdateFailed;
        });
      }
    } catch (e) {
      // ignore update check errors in production
    }
  }).catchError((e) {});
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  String errorMessage = '';
  bool isLoading = false;
  final MainController main = Get.find<MainController>();

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(Utils.get_theme());
    _myInit();
  }

  Future<void> _myInit() async {
    checkForUpdate();
    await main.getEnt();
    if (mounted) setState(() {});
  }

  // ── Form submission ──────────────────────────────────────────────────────

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) {
      Utils.toast('Please fix errors in the form.', color: Colors.red);
      return;
    }

    final formData = {
      'username': _formKey.currentState?.fields['username']?.value,
      'password': _formKey.currentState?.fields['password']?.value,
    };

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final RespondModel resp =
        RespondModel(await Utils.http_post('users/login', formData));

    // Default password — user must contact admin before they can log in.
    if (resp.rawCode == 'DEFAULT_PASSWORD') {
      setState(() => isLoading = false);
      _showDefaultPasswordDialog(resp.message);
      return;
    }

    if (resp.code != 1) {
      setState(() {
        isLoading = false;
        errorMessage = resp.message;
      });
      return;
    }

    final LoggedInUserModel u = LoggedInUserModel.fromJson(resp.data);
    if (!(await u.save())) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to log you in.';
      });
      return;
    }

    final LoggedInUserModel lu = await LoggedInUserModel.getLoggedInUser();
    if (lu.id < 1) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to retrieve your account.';
      });
      return;
    }

    await Utils.setPref('token', lu.remember_token);

    final String token = await Utils.getToken();
    if (token.isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to save token.';
      });
      return;
    }

    setState(() => isLoading = false);
    Get.off(const OnBoardingScreen());
  }

  // ── Dialogs ──────────────────────────────────────────────────────────────

  void _showDefaultPasswordDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        title: Row(
          children: [
            Icon(Icons.lock_outline,
                color: CustomTheme.primary, size: 22),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Password Reset Required',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        content: Text(
          message.isNotEmpty
              ? message
              : 'You are using the default password. Please contact your administrator to reset your password before signing in.',
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomTheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero),
            ),
            icon: const Icon(FeatherIcons.messageSquare, size: 16),
            label: const Text('Contact Admin on WhatsApp'),
            onPressed: () {
              Navigator.pop(ctx);
              Utils.launchURL(
                'https://wa.me/+256783204665?text=Hello%2C%20I%20need%20my%20School%20Dynamics%20password%20reset.',
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSupportSheet() {
    showModalBottomSheet(
      context: context,
      barrierColor: CustomTheme.primary.withValues(alpha: 0.5),
      builder: (BuildContext ctx) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contact Support Team',
              style: TextStyle(
                color: CustomTheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                Navigator.pop(ctx);
                Utils.launchURL(
                    'https://wa.me/+256783204665?text=Hello%20I%20need%20help%20with%20my%20account.');
              },
              dense: false,
              leading: Icon(FeatherIcons.messageSquare,
                  size: 28, color: CustomTheme.primary),
              title: const Text('WhatsApp',
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(ctx);
                Utils.launchURL('tel:+256783204665');
              },
              dense: false,
              leading: Icon(FeatherIcons.phoneCall,
                  size: 26, color: CustomTheme.primary),
              title: const Text('Call',
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final Color primary = CustomTheme.primary;
    final double screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      // Primary colour fills the area behind the status bar.
      backgroundColor: primary,
      // Zero-height AppBar purely for systemOverlayStyle — no visual presence.
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: Utils.get_theme(),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Primary header ───────────────────────────────────────────
            SizedBox(
              height: screenH * 0.38,
              child: Container(
                color: primary,
                child: CustomPaint(
                  painter: _DotPatternPainter(
                      Colors.white.withValues(alpha: 0.09)),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // School logo (network, fallback to asset)
                        CachedNetworkImage(
                          imageUrl: main.ent.getLogo(),
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                          placeholder: (_, __) => Image.asset(
                            'assets/images/logo.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          errorWidget: (_, __, ___) => Image.asset(
                            'assets/images/logo.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Welcome to ${main.ent.name.isEmpty ? 'School Dynamics' : main.ent.name}',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Sign in to continue',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── White form section ───────────────────────────────────────
            Container(
              color: Colors.white,
              constraints: BoxConstraints(minHeight: screenH * 0.62),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Phone / username field
                    FormBuilderTextField(
                      name: 'username',
                      autofocus: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'This field is required.'),
                      ]),
                      decoration: InputDecoration(
                        enabledBorder: CustomTheme.input_outline_border,
                        border:
                            CustomTheme.input_outline_focused_border,
                        labelText: 'Phone number or username',
                        prefixIcon: Icon(Icons.person_outline,
                            color: primary, size: 20),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Password field
                    FormBuilderTextField(
                      name: 'password',
                      obscureText: true,
                      autofocus: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => submitForm(),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Password is required.'),
                      ]),
                      decoration: InputDecoration(
                        enabledBorder: CustomTheme.input_outline_border,
                        border:
                            CustomTheme.input_outline_focused_border,
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline,
                            color: primary, size: 20),
                      ),
                    ),

                    // Forgot password row
                    Row(
                      children: [
                        Text(
                          'Forgot password?',
                          style: TextStyle(
                              color: Colors.red.shade500, fontSize: 13),
                        ),
                        TextButton(
                          child: Text(
                            'Reset Password',
                            style: TextStyle(
                                color: primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () =>
                              Get.to(() => const PasswordResetScreen()),
                        ),
                      ],
                    ),

                    // Error message
                    if (errorMessage.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.red.shade50,
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                              color: Colors.red.shade700, fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Sign-in button / spinner
                    SizedBox(
                      height: 50,
                      child: isLoading
                          ? Center(
                              child: SizedBox(
                                width: 26,
                                height: 26,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: primary,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                              ),
                              onPressed: submitForm,
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),
                    const SizedBox(height: 8),

                    // Help row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Facing any problem? ',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                        TextButton(
                          child: Text(
                            'Ask for help',
                            style: TextStyle(
                                color: primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () => _showSupportSheet(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dot-grid background painter (same pattern used on splash & onboarding)
// ---------------------------------------------------------------------------
class _DotPatternPainter extends CustomPainter {
  final Color dotColor;
  _DotPatternPainter(this.dotColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;
    const double spacing = 22;
    const double radius = 1.5;
    for (double x = 0; x <= size.width; x += spacing) {
      for (double y = 0; y <= size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotPatternPainter old) => old.dotColor != dotColor;
}
