import 'package:flutter/cupertino.dart';
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

class StudentEditBioScreen extends StatefulWidget {
  final dynamic data;

  StudentEditBioScreen({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  _StudentEditBioScreenState createState() => _StudentEditBioScreenState();
}

class _StudentEditBioScreenState extends State<StudentEditBioScreen> {
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
    bool announceChanges = false,
    bool askReset = false,
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
        RespondModel(await Utils.http_post('update-bio/${item.id}', {
      'first_name': item.first_name,
      'last_name': item.last_name,
      'given_name	': item.given_name,
      'sex': item.sex,
      'nationality': item.nationality,
      'home_address': item.home_address,
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
          "Updating student's bio data",
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
                          name: 'first_name',
                          initialValue: item.first_name,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          onChanged: (x) {
                            item.first_name = Utils.to_str(x, '');
                          },
                          keyboardType: TextInputType.name,
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "First name",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "First name is required.",
                            ),
                          ]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20, top: 10),
                        child: FormBuilderTextField(
                          name: 'last_name',
                          initialValue: item.last_name,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          onTap: () {},
                          onChanged: (x) {
                            item.last_name = Utils.to_str(x, '');
                          },
                          keyboardType: TextInputType.name,
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "Last name",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Last name is required.",
                            ),
                          ]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20, top: 10),
                        child: FormBuilderTextField(
                          name: 'given_name	',
                          initialValue: item.given_name,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          onTap: () {},
                          onChanged: (x) {
                            item.given_name = Utils.to_str(x, '');
                          },
                          keyboardType: TextInputType.name,
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "Middle name",
                          ),
                        ),
                      ),
                      FormBuilderChoiceChip<String>(
                        decoration: AppTheme.InputDecorationTheme1(
                            label: "Sex", isDense: true),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'sex',
                        padding: EdgeInsets.all(0),
                        elevation: 1,
                        initialValue: item.sex,
                        onChanged: (x) {
                          item.sex = Utils.to_str(x, '');
                          setState(() {});
                        },
                        backgroundColor: CupertinoColors.lightBackgroundGray,
                        labelPadding: EdgeInsets.only(left: 6, right: 6),
                        alignment: WrapAlignment.spaceEvenly,
                        selectedColor: (item.sex == 'Male')
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        options: [
                          FormBuilderChipOption(
                            value: 'Male',
                            child: FxText(
                              "Male",
                              color: item.sex == 'Male'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'Female',
                            child: FxText(
                              "Female",
                              color: item.sex == 'Female'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 20),
                        child: FormBuilderTextField(
                          name: 'nationality',
                          initialValue: item.nationality,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          onChanged: (x) {
                            item.nationality = Utils.to_str(x, '');
                          },
                          keyboardType: TextInputType.name,
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "Nationality",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Nationality is required.",
                            ),
                          ]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20, top: 10),
                        child: FormBuilderTextField(
                          name: 'home_address',
                          initialValue: item.home_address,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.done,
                          onChanged: (x) {
                            item.home_address = Utils.to_str(x, '');
                          },
                          keyboardType: TextInputType.name,
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "Home address",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Home address is required.",
                            ),
                          ]),
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
