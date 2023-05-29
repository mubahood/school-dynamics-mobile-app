/*
* File : Login
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:schooldynamics/models/RespondModel.dart';
import 'package:schooldynamics/models/ServiceSubscription.dart';
import 'package:schooldynamics/screens/finance/ServiceSubscriptionCreateScreen.dart';
import 'package:schooldynamics/sections/widgets.dart';

import '../../models/MyClasses.dart';
import '../../models/StreamModel.dart';
import '../../models/StudentVerificationModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';

class StudentsVerificationFormScreen extends StatefulWidget {
  final dynamic data;

  StudentsVerificationFormScreen({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  _StudentsVerificationFormScreenState createState() =>
      _StudentsVerificationFormScreenState(this.data);
}

class _StudentsVerificationFormScreenState
    extends State<StudentsVerificationFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool onLoading = false;
  String error_message = "";
  StudentVerificationModel item;

  _StudentsVerificationFormScreenState(this.item);

  @override
  void initState() {
    init();
    super.initState();
  }

  List<StreamModel> streams = [];

  bool classIsSet = false;

  init() async {
    if (Utils.int_parse(item.current_class_id) > 0) {
      classIsSet = true;
    }
    classes = await MyClasses.getItems();
    streams = await StreamModel.getItems();
    setState(() {});
  }

  Future<void> submit_form({
    bool announceChanges: false,
    bool askReset: false,
  }) async {
/*    print(item.toJson());
    return;*/
    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please first fix errors.", color: Colors.red);
      return;
    }

    if (item.sex != 'Male' && item.sex != 'Female') {
      Utils.toast("Select student's sex", color: Colors.red);
      return;
    }

    if (item.status == '1') {
      if (Utils.int_parse(item.stream_id) < 0) {
        Utils.toast("Please select stream.", color: Colors.red);
      }
    }

    await item.save();
    error_message = "";
    setState(() {
      onLoading = true;
    });

    RespondModel r = RespondModel(
        await Utils.http_post('verify-student/${item.id}', item.toJson()));

    setState(() {
      onLoading = false;
    });

    if (r.code != 1) {
      Utils.toast('Failed to update because ${r.message}.', color: Colors.red);
      error_message = r.message;
      setState(() {});
      return;
    }
/*
    item = UserModel.fromJson(r.data);
    await item.save();*/

    Utils.toast("Success!");
    setState(() {});
    Navigator.pop(context);
    StudentVerificationModel.getItems();
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
          "Verifying student",
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
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
                                name: 'name',
                                initialValue: item.name,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                readOnly: true,
                                onChanged: (x) {
                                  item.name = Utils.to_str(x, '');
                                },
                                keyboardType: TextInputType.name,
                                decoration: AppTheme.InputDecorationTheme1(
                                  label: "Name",
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "First name is required.",
                                  ),
                                ]),
                              ),
                            ),
                            FormBuilderRadioGroup(
                              decoration: AppTheme.InputDecorationTheme1(
                                  hasPadding: false, label: "Sex", isDense: true),
                              name: 'sex',
                              wrapRunSpacing: 0,
                              wrapSpacing: 0,
                              initialValue: item.sex,
                              onChanged: (val) {
                                item.sex = Utils.to_str(val, '');
                                setState(() {});
                              },
                              orientation: OptionsOrientation.horizontal,
                              validator: FormBuilderValidators.required(),
                              options: [
                                'Male',
                                'Female',
                              ]
                                  .map((lang) => FormBuilderFieldOption(
                                        value: lang,
                                      ))
                                  .toList(growable: false),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            FormBuilderRadioGroup(
                              decoration: AppTheme.InputDecorationTheme1(
                                  hasPadding: false, label: "Status", isDense: true),
                              name: 'status',
                              wrapRunSpacing: 0,
                              wrapSpacing: 0,
                              initialValue: item.status,
                              onChanged: (val) {
                                item.status = Utils.to_str(val, '2');
                                setState(() {});
                              },
                              orientation: OptionsOrientation.vertical,
                              validator: FormBuilderValidators.required(),
                              options: [
                                '1',
                                '2',
                                '0',
                              ]
                                  .map((lang) => FormBuilderFieldOption(
                                        value: lang,
                                        child: Text(lang == '1'
                                            ? 'Active'
                                            : lang == '2'
                                                ? 'Pending'
                                                : 'Not Active'),
                                      ))
                                  .toList(growable: false),
                            ),
                            item.status != '1'
                                ? SizedBox()
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      FormBuilderTextField(
                                        name: 'current_class_text',
                                        initialValue: item.current_class_text,
                                        textCapitalization: TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        readOnly: true,
                                        onTap: () {
                                          selectClass();
                                        },
                                        onChanged: (x) {
                                          item.name = Utils.to_str(x, '');
                                        },
                                        keyboardType: TextInputType.name,
                                        decoration: AppTheme.InputDecorationTheme1(
                                          label: "Class",
                                        ),
                                        validator: FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                            errorText: "First name is required.",
                                          ),
                                        ]),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      FormBuilderTextField(
                                        name: 'current_stream_text',
                                        initialValue: item.current_stream_text,
                                        textCapitalization: TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        readOnly: true,
                                        onTap: () {
                                          selectStream();
                                        },
                                        keyboardType: TextInputType.name,
                                        decoration: AppTheme.InputDecorationTheme1(
                                          label: "Stream",
                                        ),
                                        validator: FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                            errorText: "Stream is required.",
                                          ),
                                        ]),
                                      ),

                                      SizedBox(height: 10,),
                                      InkWell(
                                        onTap: (){
                                          Get.to(()=>ServiceSubscriptionCreateScreen({
                                            'id' : item.id
                                          }));
                                        },
                                        child: Column(
                                          children: [
                                            Divider(),
                                            SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: FxText.bodyLarge(
                                                      'Set service subscriptions',
                                                      fontWeight: 800,
                                                      fontSize: 18,
                                                      color: CustomTheme.primary,
                                                    )),
                                                FxSpacing.width(20),
                                                Icon(
                                                  FeatherIcons.chevronRight,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Divider(),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                            SizedBox(
                              height: 15,
                            ),
                            alertWidget(error_message, 'danger'),

                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
          onLoading
              ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                    CustomTheme.primary),
              ))
              : Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,bottom: 10
            ),
                child: FxButton.block(
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
                          "SAVE CHANGES",
                          color: Colors.white,
                          fontWeight: 700,
                        )),
                  ],
                )),
              )
        ],
      ),
    );
  }

  List<MyClasses> classes = [];

  Future<void> selectStream() async {
    if (item.current_class_id.isEmpty) {
      Utils.toast("First select class", color: Colors.red.shade600);
      return;
    }

    streams = await StreamModel.getItems(
        where: '  academic_class_id = ${item.current_class_id} ');

    if (streams.isEmpty) {
      Utils.toast("Selected class has no streams", color: Colors.red.shade600);
      return;
    }

    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(MySize.size16!),
                topRight: Radius.circular(MySize.size16!),
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FxText.titleMedium(
                          'Select class',
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            FeatherIcons.x,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: streams.length,
                        itemBuilder: (context, position) {
                          StreamModel c = streams[position];
                          return ListTile(
                            onTap: () {
                              item.stream_id = c.id.toString();
                              item.current_stream_text = c.name.toString();

                              _formKey.currentState!.patchValue({
                                'current_stream_text': c.name,
                              });

                              setState(() {});
                              Navigator.pop(context);
                            },
                            title: FxText.titleMedium(
                              c.name,
                              color: CustomTheme.primary,
                              maxLines: 1,
                              fontWeight: 700,
                            ),
                            /*  subtitle: FxText.bodySmall(
                              c.n,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),*/
                            visualDensity: VisualDensity.compact,
                            dense: true,
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> selectClass() async {
    if (classIsSet) {
      return;
    }

    if (classes.isEmpty) {
      classes = await MyClasses.getItems();
    }
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(MySize.size16!),
                topRight: Radius.circular(MySize.size16!),
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FxText.titleMedium(
                          'Select class',
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            FeatherIcons.x,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: classes.length,
                        itemBuilder: (context, position) {
                          MyClasses c = classes[position];
                          return ListTile(
                            onTap: () {
                              item.current_class_id = c.id.toString();
                              item.current_class_text = c.short_name.toString();

                              _formKey.currentState!.patchValue({
                                'current_class_text': item.current_class_text,
                              });

                              setState(() {});
                              Navigator.pop(context);
                            },
                            title: FxText.titleMedium(
                              c.name,
                              color: CustomTheme.primary,
                              maxLines: 1,
                              fontWeight: 700,
                            ),
                            subtitle: FxText.bodySmall(
                              c.short_name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            visualDensity: VisualDensity.compact,
                            dense: true,
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
