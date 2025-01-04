import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

import '../../../utils/Utils.dart';
import '../../controllers/MainController.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/RespondModel.dart';
import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';
import '../OnBoardingScreen.dart';
import 'PasswordResetScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
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
      print(e);
    }
  }).catchError((e) {});
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> submit_form() async {
    /*print("=================");
    RespondModel resp2 = RespondModel(await Utils.http_post('users/login', {
      'username': '0783204665',
      'password': '4321',
    }));
    print(resp2.code);*/

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

    await Utils.setPref('token', lu.remember_token);

    String token = await Utils.getToken();
    if (token.isEmpty) {
      is_loading = false;
      error_message = 'Failed to save token.';
      Utils.toast("Failed to save token.");
      setState(() {});
      return;
    }

    is_loading = false;
    setState(() {});

    Get.off(OnBoardingScreen());
  }

  String error_message = "";
  bool is_loading = false;
  final MainController main = Get.find<MainController>();

  @override
  void initState() {
    Utils.init_theme();
    myInit();
  }

  myInit() async {
    checkForUpdate();
    await main.getEnt();
    await main.getEnt();

    /// = await EnterpriseModel.getEnt();
    setState(() {});
  }

  void showImagePicker(context) {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: FxSpacing.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FxText.bodyLarge(
                      "Contact Support Team",
                      color: CustomTheme.primary,
                      fontWeight: 800,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Utils.launchURL(
                            "https://wa.me/+256783204665?text=Hello%20I%20need%20help%20with%20my%20account.\n");
                      },
                      dense: false,
                      leading: Icon(FeatherIcons.messageSquare,
                          size: 30, color: CustomTheme.primary),
                      title: FxText(
                        "WhatsApp",
                        fontWeight: 500,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    ListTile(
                        dense: false,
                        onTap: () {
                          Navigator.pop(context);
                          Utils.launchURL("tel:+256783204665");
                        },
                        leading: Icon(FeatherIcons.phoneCall,
                            size: 28, color: CustomTheme.primary),
                        title: FxText(
                          "Call",
                          fontWeight: 500,
                          color: Colors.black,
                          fontSize: 18,
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(color: Colors.white)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 40,
              color: Colors.white,
            ),
            Container(
                padding: const EdgeInsets.only(
                  left: 25,
                  top: 0,
                  right: 25,
                ),
                child: FxText.titleLarge(
                  "Welcome To ${main.ent.name}",
                  textAlign: TextAlign.center,
                )),
            const SizedBox(
              height: 0,
            ),
            CachedNetworkImage(
              fit: BoxFit.contain,
              imageUrl: main.ent.getLogo(),
              width: 100,
              height: 100,
              placeholder: (context, url) => ShimmerLoadingWidget(
                height: 400,
              ),
              errorWidget: (context, url, error) => Image(
                image: const AssetImage('assets/images/logo.png'),
                fit: BoxFit.contain,
                width: (Get.width / 5),
                height: (Get.width / 5),
              ),
            ),
            Divider(
              endIndent: Get.width / 3.0,
              indent: Get.width / 3.0,
              thickness: 4,
              color: Colors.grey.shade400,
            ),
            FxText.bodyLarge("Sign in to continue",
                textAlign: TextAlign.center,
                fontWeight: 500,
                color: Colors.black),
            FxContainer(
                borderRadiusAll: 0,
                marginAll: 0,
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 0, bottom: 10),
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
                        Container(height: 15),
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
                            border: CustomTheme.input_outline_focused_border,
                            labelText: "Phone number",
                          ),
                        ),
                        Container(height: 15),
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
                            border: CustomTheme.input_outline_focused_border,
                            labelText: "Password",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Password is required.",
                            ),
                          ]),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Forgot password?",
                              style: TextStyle(
                                  color: Colors.red.shade500,
                                  fontSize: 14,
                                  height: 1),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(),
                              child: Text(
                                "Reset Password",
                                style: TextStyle(
                                  color: CustomTheme.primary,
                                  fontSize: 14,
                                  height: 1,
                                ),
                              ),
                              onPressed: () {
                                Get.to(()=>PasswordResetScreen());
                              },
                            )
                          ],
                        ),
                        Container(height: 0),
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
                            top: 0,
                          ),
                          child: is_loading
                              ? Center(
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    padding: const EdgeInsets.all(15),
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
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
            const Divider(),
            Row(
              children: <Widget>[
                const Spacer(),
                Text(
                  "Facing any problem?",
                  style: TextStyle(color: Colors.red.shade500, fontSize: 14),
                ),
                TextButton(
                  style: TextButton.styleFrom(),
                  child: Text(
                    "Ask for help",
                    style: TextStyle(color: CustomTheme.primary, fontSize: 14),
                  ),
                  onPressed: () {
                    showImagePicker(context);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
