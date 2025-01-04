import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:schooldynamics/screens/OnBoardingScreen.dart';

import '../../models/EnterpriseModel.dart';
import '../../models/RespondModel.dart';
import '../../sections/ImagePickerWisget.dart';
import '../../theme/app_theme.dart';
import '../../utils/Utils.dart';

class EnterpriseModelEditScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  EnterpriseModelEditScreen(
    this.params, {
    Key? key,
  }) : super(key: key);

  @override
  EnterpriseModelEditScreenState createState() =>
      EnterpriseModelEditScreenState();
}

class EnterpriseModelEditScreenState extends State<EnterpriseModelEditScreen>
    with SingleTickerProviderStateMixin {
  var initFuture;
  final _fKey = GlobalKey<FormBuilderState>();
  bool is_loading = false;
  String error_message = "";
  EnterpriseModel item = EnterpriseModel();
  String logo_path = "";

  Future<bool> init_form() async {
    if (widget.params['item'].runtimeType == item.runtimeType) {
      item = widget.params['item'];
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    initFuture = init_form();
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        title: FxText.titleMedium(
          "Creating School",
          color: Colors.white,
          fontSize: 20,
          fontWeight: 700,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CustomTheme.primary,
        actions: [
          is_loading
              ? Padding(
                  padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(CustomTheme.primary),
                    ),
                  ),
                )
              : FxButton.text(
                  onPressed: () {
                    submit_form();
                  },
                  backgroundColor: Colors.white,
                  child: Icon(
                    FeatherIcons.check,
                    color: Colors.white,
                    size: 35,
                  ))
        ],
      ),
      body: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return FormBuilder(
              key: _fKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 10,
                          right: 15,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            error_message.isEmpty
                                ? const SizedBox()
                                : FxContainer(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    color: Colors.red.shade50,
                                    child: Text(
                                      error_message,
                                    ),
                                  ),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("School Full name")
                                    .capitalize!,
                              ),
                              initialValue: item.name,
                              textCapitalization: TextCapitalization.sentences,
                              name: "name",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.name = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "name is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "name is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(300,
                                    errorText: "name is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("School short name")
                                    .capitalize!,
                              ),
                              initialValue: item.short_name,
                              textCapitalization: TextCapitalization.sentences,
                              name: "short_name",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.short_name = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "short_name is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "short_name is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(300,
                                    errorText: "short_name is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label:
                                    GetStringUtils("School motto").capitalize!,
                              ),
                              initialValue: item.motto,
                              textCapitalization: TextCapitalization.sentences,
                              name: "motto",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.motto = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "motto is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "motto is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(300,
                                    errorText: "motto is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),
                            FormBuilderRadioGroup(
                                decoration: AppTheme.InputDecorationTheme1(
                                    hasPadding: false,
                                    label: "School Type",
                                    isDense: true),
                                name: 'type',
                                wrapRunSpacing: 0,
                                wrapSpacing: 0,
                                initialValue: item.type,
                                onChanged: (val) {
                                  item.type = Utils.to_str(val, '');
                                  setState(() {});
                                },
                                orientation: OptionsOrientation.vertical,
                                validator: FormBuilderValidators.required(),
                                options: const [
                                  FormBuilderFieldOption(
                                    value: 'Primary',
                                    child: Text("Primary School"),
                                  ),
                                  FormBuilderFieldOption(
                                    value: 'Secondary',
                                    child: Text(
                                        "Secondary School (O\'level school)"),
                                  ),
                                  FormBuilderFieldOption(
                                    value: 'Advanced',
                                    child: Text(
                                        "Advanced Secondary School (Both O\'level and A\'level)"),
                                  ),
                                ]),
                            const SizedBox(height: 20),
                            FormBuilderRadioGroup(
                                decoration: AppTheme.InputDecorationTheme1(
                                    hasPadding: false,
                                    label:
                                        "Does school offer Islamic theology studies? (Arabic)",
                                    isDense: true),
                                name: 'has_theology',
                                wrapRunSpacing: 0,
                                wrapSpacing: 0,
                                initialValue: item.has_theology,
                                onChanged: (val) {
                                  item.has_theology = Utils.to_str(val, '');
                                  setState(() {});
                                },
                                orientation: OptionsOrientation.vertical,
                                validator: FormBuilderValidators.required(),
                                options: const [
                                  FormBuilderFieldOption(
                                    value: 'Yes',
                                    child:
                                        Text("Yes (We teach Arabic Studies)"),
                                  ),
                                  FormBuilderFieldOption(
                                    value: 'No',
                                    child: Text(
                                        "No (We don't teach Arabic Studies)"),
                                  ),
                                ]),
                            const SizedBox(height: 15),
                            ImagePickerWidget(
                              logo_path,
                              logo_path,
                              'School Badge Photo',
                              (x) {
                                logo_path = x.toString();
                                Utils.toast("Select $logo_path");
                                setState(() {});
                              },
                            ),
                            const SizedBox(height: 15),
                            FxContainer(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Pick a color!'),
                                      content: SingleChildScrollView(
                                        child: MaterialPicker(
                                          pickerColor: CustomTheme.primary,
                                          onColorChanged: (Color color) {
                                            item.color =
                                                "#${color.value.toRadixString(16)}";
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text('Done'),
                                          onPressed: () {
                                            setState(() => CustomTheme.primary);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              border: Border.all(
                                color: CustomTheme.primary,
                                width: 1,
                              ),
                              bordered: true,
                              height: 80,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: item.color.length < 4
                                          ? CustomTheme.primary
                                          : Utils.getColor(item.color),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: FxText.bodyLarge(
                                      'Select School Main Color',
                                      color: CustomTheme.primary,
                                      fontWeight: 900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("School phone number")
                                    .capitalize!,
                              ),
                              initialValue: item.phone_number,
                              textCapitalization: TextCapitalization.sentences,
                              name: "phone_number",
                              enableSuggestions: true,
                              keyboardType: TextInputType.phone,
                              onChanged: (x) {
                                item.phone_number = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "phone_number is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "phone_number is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(300,
                                    errorText: "phone_number is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label:
                                    GetStringUtils("Alternative phone number")
                                        .capitalize!,
                              ),
                              initialValue: item.phone_number_2,
                              textCapitalization: TextCapitalization.sentences,
                              name: "phone_number_2",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.phone_number_2 = x.toString();
                              },
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("School email address")
                                    .capitalize!,
                              ),
                              initialValue: item.email,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.sentences,
                              name: "email",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.email = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "email is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "email is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(300,
                                    errorText: "email is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("School address")
                                    .capitalize!,
                              ),
                              keyboardType: TextInputType.streetAddress,
                              initialValue: item.address,
                              textCapitalization: TextCapitalization.sentences,
                              name: "address",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.address = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "address is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "address is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(300,
                                    errorText: "address is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("System welcome message")
                                    .capitalize!,
                              ),
                              initialValue: item.welcome_message,
                              textCapitalization: TextCapitalization.sentences,
                              name: "welcome_message",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.welcome_message = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("School P.O.Box")
                                    .capitalize!,
                              ),
                              initialValue: item.p_o_box,
                              textCapitalization: TextCapitalization.sentences,
                              name: "p_o_box",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.p_o_box = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("School website")
                                    .capitalize!,
                              ),
                              initialValue: item.website,
                              textCapitalization: TextCapitalization.sentences,
                              name: "website",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.website = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils(
                                        "School Details (About school)")
                                    .capitalize!,
                              ),
                              initialValue: item.details,
                              textCapitalization: TextCapitalization.sentences,
                              name: "details",
                              enableSuggestions: true,
                              minLines: 3,
                              maxLines: 5,
                              onChanged: (x) {
                                item.details = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "details is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "details is too short."),
                              ]),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _keyboardVisible
                      ? SizedBox()
                      : FxContainer(
                          color: Colors.white,
                          borderRadiusAll: 0,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: FxButton.block(
                              onPressed: () {
                                submit_form();
                              },
                              backgroundColor: CustomTheme.primary,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FxText.titleLarge(
                                    'SUBMIT',
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    FeatherIcons.check,
                                    color: Colors.white,
                                    size: 35,
                                  )
                                ],
                              )))
                ],
              ),
            );
          }),
    );
  }

  bool _keyboardVisible = false;

  submit_form() async {
    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color: Colors.red.shade700);
      return;
    }
    setState(() {
      error_message = "";
      is_loading = true;
    });

    RespondModel resp =
        RespondModel(await Utils.http_post('enterprise-create', item.toJson()));

    setState(() {
      error_message = "";
      is_loading = false;
    });

    if (resp.code != 1) {
      is_loading = false;
      error_message = resp.message;
      setState(() {});
      Utils.toast('Failed', color: Colors.red.shade700);
      return;
    }

    EnterpriseModel ent = EnterpriseModel.fromJson(resp.data);
    if (ent.id < 2) {
      Utils.toast('Failed', color: Colors.red.shade700);
      return;
    }

    await ent.save();
    LoggedInUserModel u = await LoggedInUserModel.getLoggedInUser();
    u.enterprise_id = ent.id.toString();
    await u.save();

    Utils.toast(resp.message, color: Colors.green.shade700);
    Get.off(OnBoardingScreen());
    return;
  }
}
