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

class EmailVerificationScreen extends StatefulWidget {
  LoggedInUserModel u;
  String task;

  EmailVerificationScreen(this.u, this.task, {Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _fKey = GlobalKey<FormBuilderState>();
  LoggedInUserModel item = LoggedInUserModel();
  String country = '+256';
  String phone_number = '+256';
  bool isTokenSent = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    item = widget.u;
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
                initialValue: item.email,
                keyboardType: TextInputType.emailAddress,
                name: "email",
                readOnly: isTokenSent,
                onChanged: (String? val) {
                  if (val == null) {
                    return;
                  }
                  item.email = val!.trim().toString();
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
                          name: "password",
                          onChanged: (String? val) {
                            if (val == null) {
                              return;
                            }
                            item.password = val!.trim().toString();
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
                        isTokenSent ? 'Verify Email' : 'Request Secret Code',
                        style: TextStyle(
                            fontSize: 20, height: 1, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              /*isTokenSent*/
              Row(
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
    error_message = "";
    success_message = "";
    setState(() {});
    //validate email
    if (item.email.isEmpty) {
      error_message = 'Email is required.';
      setState(() {});
      return;
    }

    //validate email address size
    if (item.email.length < 5) {
      error_message = 'Email is too short.';
      setState(() {});
      return;
    }

    Utils.showLoader(true);

    error_message = "";
    setState(() {});
    RespondModel resp =
        RespondModel(await Utils.http_post('email-verify-review-code', {
      'user_id': item.id.toString(),
      'email': item.email,
      'task': widget.task,
      'code': item.password,
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
    widget.u.verification = '1';
    await widget.u.save();
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
    if (item.email.isEmpty) {
      error_message = 'Email is required.';
      setState(() {});
      return;
    }

    //validate email address size
    if (item.email.length < 5) {
      error_message = 'Email is too short.';
      setState(() {});
      return;
    }

    Utils.showLoader(true);

    error_message = "";
    setState(() {});
    RespondModel resp =
        RespondModel(await Utils.http_post('email-verify-request-token', {
      'user_id': item.id.toString(),
      'email': item.email,
      'task': widget.task,
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
