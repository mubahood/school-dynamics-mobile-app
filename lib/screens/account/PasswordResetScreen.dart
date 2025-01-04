import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/RespondModel.dart';

import '../../models/LoggedInUserModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/Utils.dart';
import '../OnBoardingScreen.dart';

class PasswordResetScreen extends StatefulWidget {
  PasswordResetScreen({Key? key}) : super(key: key);

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _fKey = GlobalKey<FormBuilderState>();
  String country = '+256';
  String phone_number = '+256';
  bool isTokenSent = false;
  String password_1 = '';
  String password_2 = '';
  String reset_code = '';
  String email = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: FormBuilder(
        key: _fKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              //email
              FormBuilderTextField(
                decoration: CustomTheme.in_4(
                  label: "Email Address",
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: "Email is required.",
                  ),
                  FormBuilderValidators.email(
                    errorText: "Invalid email address.",
                  ),
                ]),
                keyboardType: TextInputType.emailAddress,
                name: "email",
                readOnly: isTokenSent,
                onChanged: (String? val) {
                  if (val == null) {
                    return;
                  }
                  email = val!.trim().toString();
                  setState(() {});
                },
                textInputAction: TextInputAction.next,
              ),
              !isTokenSent
                  ? SizedBox()
                  : Column(
                      children: [
                        const SizedBox(height: 15),
                        //password
                        FormBuilderTextField(
                          decoration: CustomTheme.in_4(
                            label: "Secret Code",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Token is required.",
                            ),
                            //min 4
                            FormBuilderValidators.minLength(4,
                                errorText: "Token is too short."),
                            //max 30
                            FormBuilderValidators.maxLength(30,
                                errorText: "Token is too long."),
                          ]),
                          keyboardType: TextInputType.number,
                          name: "reset_code",
                          onChanged: (String? val) {
                            if (val == null) {
                              return;
                            }

                            reset_code = val!.trim().toString();
                          },
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: 15),
                        //password
                        FormBuilderTextField(
                          decoration: CustomTheme.in_4(
                            label: "Enter new password",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Password is required.",
                            ),
                            //min 4
                            FormBuilderValidators.minLength(4,
                                errorText: "Password is too short."),
                            //max 30
                            FormBuilderValidators.maxLength(30,
                                errorText: "Password is too long."),
                          ]),
                          keyboardType: TextInputType.number,
                          name: "password_1",
                          obscureText: true,
                          obscuringCharacter: "*",
                          onChanged: (String? val) {
                            if (val == null) {
                              return;
                            }
                            password_1 = val!.trim().toString();
                          },
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: 15),
                        //password
                        FormBuilderTextField(
                          decoration: CustomTheme.in_4(
                            label: "Re-Enter password",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Password is required.",
                            ),
                            //min 4
                            FormBuilderValidators.minLength(4,
                                errorText: "Password is too short."),
                            //max 30
                            FormBuilderValidators.maxLength(30,
                                errorText: "Password is too long."),
                          ]),
                          keyboardType: TextInputType.number,
                          name: "password_2",
                          obscureText: true,
                          obscuringCharacter: "*",
                          onChanged: (String? val) {
                            if (val == null) {
                              return;
                            }
                            password_2 = val!.trim().toString();
                          },
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
              const SizedBox(height: 15),
              //confirm password

              error_message.isEmpty
                  ? const SizedBox()
                  : FxContainer(
                      width: double.infinity,
                      borderColor: Colors.red.shade900,
                      bordered: true,
                      margin: EdgeInsets.only(bottom: 10),
                      color: Colors.red.shade50,
                      child: FxText.bodySmall(
                        error_message,
                        color: Colors.black,
                      ),
                    ),
              success_message == ""
                  ? const SizedBox()
                  : FxContainer(
                      width: double.infinity,
                      borderColor: Colors.green.shade900,
                      bordered: true,
                      margin: EdgeInsets.only(bottom: 10),
                      color: Colors.green.shade50,
                      child: FxText.bodySmall(
                        success_message,
                        color: Colors.black,
                      ),
                    ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (!isTokenSent) {
                          request_token();
                        } else {
                          verify_email();
                        }
                      },
                      child: Text(
                        isTokenSent ? 'Reset Password' : 'Request Secret Code',
                        style: const TextStyle(
                            fontSize: 20, height: 1, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              /*isTokenSent*/

              (email.trim().length < 6)
                  ? const SizedBox()
                  : Row(
                      children: [
                        Expanded(
                          child: FxButton.text(
                            onPressed: () {
                              setState(() {
                                isTokenSent = !isTokenSent;
                              });
                            },
                            child: Text(
                              !isTokenSent
                                  ? 'I already have secret code'
                                  : 'Request Another Secret Code',
                              style: TextStyle(
                                fontSize: 20,
                                height: 1,
                                color: CustomTheme.accent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verify_email() async {
    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color: Colors.red.shade700);
      return;
    }
    if (password_2 != password_1) {
      Utils.toast("Passwords didn't match.", color: Colors.red);
      return;
    }
    if (password_1.length < 4) {
      Utils.toast("Passwords didn't match.", color: Colors.red);
      return;
    }
    error_message = "";
    success_message = "";
    setState(() {});
    //validate email
    if (email.isEmpty) {
      error_message = 'Email is required.';
      setState(() {});
      return;
    }

    //validate email address size
    if (email.length < 5) {
      error_message = 'Email is too short.';
      setState(() {});
      return;
    }

    Utils.showLoader(true);

    error_message = "";
    setState(() {});
    RespondModel resp =
        RespondModel(await Utils.http_post('forget-password-reset', {
      'password': password_1.toString(),
      'email': email,
      'task': 'PASSWORD_RESET',
      'code': reset_code,
    }));
    Utils.hideLoader();

    if (resp.code != 1) {
      is_loading = false;
      error_message = resp.message;
      Utils.toast("Failed because ${resp.message}");
      setState(() {});
      return;
    }

    success_message = resp.message;

    setState(() {});

    LoggedInUserModel u = LoggedInUserModel.fromJson(resp.data);

    if (!(await u.save())) {
      is_loading = false;
      error_message = 'Failed to log you in.';
      setState(() {});
      return;
    }

    LoggedInUserModel lu = await LoggedInUserModel.getLoggedInUser();

    if (lu.id < 1) {
      is_loading = false;
      error_message = 'Failed to retrieve you in.';
      setState(() {});
      return;
    }

    await Utils.setPref('token', lu.remember_token);

    String token = await Utils.getToken();
    if (token.isEmpty) {
      is_loading = false;
      error_message = 'Failed to save token.';
      Utils.toast("Failed to save token.");
      setState(() {});
      return;
    }
    Utils.toast(resp.message);
    Get.off(OnBoardingScreen());
    return;
    success_message = resp.message;
    Utils.toast(resp.message);
    isTokenSent = true;
    setState(() {});

    Get.offAll(() => OnBoardingScreen());
  }

  Future<void> request_token() async {
    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color: Colors.red.shade700);
      return;
    }
    error_message = "";
    success_message = "";
    setState(() {});
    //validate email
    if (email.isEmpty) {
      error_message = 'Email is required.';
      setState(() {});
      return;
    }

    //validate email address size
    if (email.length < 5) {
      error_message = 'Email is too short.';
      setState(() {});
      return;
    }

    Utils.showLoader(true);

    error_message = "";
    setState(() {});
    RespondModel resp =
        RespondModel(await Utils.http_post('forget-password-request', {
      'email': email,
    }));
    Utils.hideLoader();

    if (resp.code != 1) {
      is_loading = false;
      error_message = resp.message;
      Utils.toast("Failed because ${resp.message}");
      setState(() {});
      return;
    }

    success_message = resp.message;
    Utils.toast(resp.message);
    isTokenSent = true;
    setState(() {});
  }

  bool is_loading = false;
  String error_message = "";
  String success_message = "";
}
