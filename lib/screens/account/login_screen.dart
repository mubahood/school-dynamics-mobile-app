import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../utils/AppConfig.dart';
import '../../../utils/Utils.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/RespondModel.dart';
import '../../theme/custom_theme.dart';
import '../OnBoardingScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> submit_form() async {

    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please fix errors in the form.", color: Colors.red);
      return;
    }

    Map<String, dynamic> form_data_map = {};
    form_data_map = {
      'username': _formKey.currentState?.fields['username']?.value,
      'password': _formKey.currentState?.fields['password']?.value,
    };

    is_loading = true;
    error_message = "";
    setState(() {});
    print("start conn");
    RespondModel resp =
        RespondModel(await Utils.http_post('users/login', form_data_map));

    if (resp.code != 1) {
      is_loading = false;
      error_message = resp.message;
      setState(() {});
      return;
    }

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

    Utils.toast("Success!");

    is_loading = false;
    setState(() {});

    Get.off(OnBoardingScreen());
  }

  String error_message = "";
  bool is_loading = false;

  @override
  void initState() {
    Utils.init_theme();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(color: Colors.white)),
      body: Column(
        children: [
          Container(
            height: 50,
            color: Colors.white,
          ),
          Image(
            width: MediaQuery.of(context).size.width / 3,
            fit: BoxFit.cover,
            image: AssetImage(AppConfig.logo1),
          ),
          Expanded(
            child: ListView(
              children: [
                FxContainer(
                    borderRadiusAll: 0,
                    marginAll: 0,
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 50, bottom: 10),
                    color: Colors.white,
                    child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            /* SizedBox(
                              height: 20,
                            ),
                            FxText.titleLarge("Sign in"),*/
                            const SizedBox(
                              height: 10,
                            ),
                            Container(height: 25),
                            FormBuilderTextField(
                              name: 'username',
                              autofocus: false,
                              /*    initialValue: 'muhsin',*/
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "This field is required.",
                                ),
                              ]),
                              decoration: InputDecoration(
                                enabledBorder: CustomTheme.input_outline_border,
                                border:
                                    CustomTheme.input_outline_focused_border,
                                labelText:
                                    "Phone number",
                              ),
                            ),
                            Container(height: 25),
                            FormBuilderTextField(
                              name: 'password',
                              /*                   initialValue: '4321',*/
                              obscureText: true,
                              autofocus: false,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                enabledBorder: CustomTheme.input_outline_border,
                                border:
                                    CustomTheme.input_outline_focused_border,
                                labelText: "Password",
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Password is required.",
                                ),
                              ]),
                            ),
                            Container(height: 10),
                            error_message.isEmpty
                                ? const SizedBox()
                                : FxContainer(
                                    margin: EdgeInsets.only(bottom: 10),
                                    color: Colors.red.shade50,
                                    child: Text(
                                      error_message,
                                    ),
                                  ),
                            Container(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: is_loading
                                  ? Center(
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        padding: const EdgeInsets.all(15),
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.red),
                                        ),
                                      ),
                                    )
                                  : CupertinoButton(
                                  color: CustomTheme.primary,
                                      onPressed: () {
                                        submit_form();
                                      },
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50)),
                                      padding: FxSpacing.xy(32, 8),
                                      pressedOpacity: 0.5,
                                      child: FxText.bodyMedium("Sign In",
                                          color: Colors.white)),
                            ),
                          ],
                        ))),

              ],
            ),
          ),
          Divider(),
          Row(
            children: <Widget>[
              const Spacer(),
              Text(
                "Facing any problem?",
                style: TextStyle(color: Colors.red.shade500, fontSize: 14),
              ),
              TextButton(
                style: TextButton.styleFrom(primary: Colors.transparent),
                child: Text(
                  "Ask for help",
                  style: TextStyle(color: CustomTheme.primary, fontSize: 14),
                ),
                onPressed: () {
                  submit_form();
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
