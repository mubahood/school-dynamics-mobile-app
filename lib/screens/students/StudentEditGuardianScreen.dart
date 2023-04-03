/*
  String  = "";
  String father_phone = "";
  String mother_name = "";
  String mother_phone = "";

 */

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:schooldynamics/models/RespondModel.dart';
import 'package:schooldynamics/models/UserModel.dart';
import 'package:schooldynamics/sections/widgets.dart';

import '../../theme/app_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';

class StudentEditGuardianScreen extends StatefulWidget {
  final dynamic data;

  StudentEditGuardianScreen({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  _StudentEditGuardianScreenState createState() =>
      _StudentEditGuardianScreenState();
}

class _StudentEditGuardianScreenState extends State<StudentEditGuardianScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool onLoading = false;
  String error_message = "";
  UserModel item = UserModel();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    setState(() {});
    item = widget.data;
    item = await UserModel.getItemById(item.id.toString());
  }

  Future<void> submit_form({
    bool announceChanges: false,
    bool askReset: false,
  }) async {
    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please first fix errors.");
      return;
    }
    error_message = "";
    setState(() {
      onLoading = true;
    });

    RespondModel r =
        RespondModel(await Utils.http_post('update-guardian/${item.id}', {
      'father_name': item.father_name,
      'mother_name': item.mother_name,
      'phone_number_1': item.phone_number_1,
      'phone_number_2': item.phone_number_2,
      'email': item.email,
    }));

    setState(() {
      onLoading = false;
    });

    if (r.code != 1) {
      Utils.toast('Failed to update because ${r.message}.', color: Colors.red);
      error_message = r.message;
      setState(() {});
      return;
    }

    item = UserModel.fromJson(r.data);
    await item.save();

    Utils.toast("Success!");
    setState(() {});
    Navigator.pop(context);
    return;
  }

  void resetForm() {
    setState(() {});

    _formKey.currentState!.patchValue({
      'finance_category_text': '',
      'amount': '',
      'description': '',
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          "Updating student's guardian data",
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: [
          Container(
              color: Colors.white,
              padding:
                  EdgeInsets.only(left: MySize.size16!, right: MySize.size16!),
              child: FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MySize.size10!,
                      left: MySize.size5!,
                      right: MySize.size5!,
                      bottom: MySize.size10!),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 10),
                        child: FormBuilderTextField(
                          name: 'father_name',
                          initialValue: item.father_name,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          onChanged: (x) {
                            item.father_name = Utils.to_str(x, '');
                          },
                          keyboardType: TextInputType.name,
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "Father's name",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Father's name is required.",
                            ),
                          ]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20, top: 10),
                        child: FormBuilderTextField(
                          name: 'mother_name',
                          initialValue: item.mother_name,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          onTap: () {},
                          onChanged: (x) {
                            item.mother_name = Utils.to_str(x, '');
                          },
                          keyboardType: TextInputType.name,
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "Mother's name",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Mother's is required.",
                            ),
                          ]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20, top: 10),
                        child: FormBuilderTextField(
                          name: 'phone_number_1',
                          initialValue: item.phone_number_1,
                          textInputAction: TextInputAction.next,
                          onTap: () {},
                          onChanged: (x) {
                            item.phone_number_1 = Utils.to_str(x, '');
                          },
                          keyboardType: TextInputType.phone,
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "Guardian's phone number",
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20, top: 10),
                        child: FormBuilderTextField(
                          name: 'phone_number_2',
                          initialValue: item.phone_number_2,
                          textInputAction: TextInputAction.next,
                          onTap: () {},
                          onChanged: (x) {
                            item.phone_number_2 = Utils.to_str(x, '');
                          },
                          keyboardType: TextInputType.phone,
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "Guardian's alternative phone number",
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20, top: 10),
                        child: FormBuilderTextField(
                          name: 'email',
                          initialValue: item.email,
                          textInputAction: TextInputAction.done,
                          onTap: () {},
                          onChanged: (x) {
                            item.email = Utils.to_str(x, '');
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "Guardian's alternative phone number",
                          ),
                        ),
                      ),
                      alertWidget(error_message, 'success'),
                      onLoading
                          ? Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    CustomTheme.primary),
                              ))
                          : FxButton.block(
                              onPressed: () {
                                submit_form();
                              },
                              borderRadiusAll: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Center(
                                      child: FxText.titleLarge(
                                    "SUBMIT CHANGES",
                                    color: Colors.white,
                                    fontWeight: 700,
                                  )),
                                ],
                              ))
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
