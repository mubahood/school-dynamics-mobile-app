import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/MenuModel.dart';

import '../../controllers/MainController.dart';
import '../../theme/app_theme.dart';
import '../../utils/Utils.dart';

class MenuCreateScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  MenuCreateScreen(
    this.params, {
    Key? key,
  }) : super(key: key);

  @override
  MenuCreateScreenState createState() => MenuCreateScreenState();
}

class MenuCreateScreenState extends State<MenuCreateScreen>
    with SingleTickerProviderStateMixin {
  var initFuture;
  final _fKey = GlobalKey<FormBuilderState>();
  bool is_loading = false;
  String error_message = "";
  MenuModel item = MenuModel(
    id: 0,
    menu_order: 0,
    title: '',
    subTitle: '',
    img: '',
    fav: '',
    is_main: '',
    parent_id: 0,
  );
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
    return Scaffold(
      appBar: AppBar(
        title: FxText.titleMedium(
          "Updating school info",
          color: Colors.white,
          fontSize: 20,
          fontWeight: 700,
        ),
        systemOverlayStyle: Utils.overlay(),
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
                                label: GetStringUtils("Title").capitalize!,
                              ),
                              initialValue: item.title,
                              textCapitalization: TextCapitalization.sentences,
                              name: "title",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.title = x.toString();
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
                                label: GetStringUtils("Sub Title").capitalize!,
                              ),
                              initialValue: item.subTitle,
                              textCapitalization: TextCapitalization.sentences,
                              name: "subTitle",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.subTitle = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "subTitle is required.",
                                ),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            //menu_order
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("Menu Order").capitalize!,
                              ),
                              initialValue: item.menu_order == 0
                                  ? null
                                  : item.menu_order.toString(),
                              textCapitalization: TextCapitalization.sentences,
                              name: "menu_order",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.menu_order = int.parse(x.toString());
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "menu_order is required.",
                                ),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            //img
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("Img").capitalize!,
                              ),
                              initialValue: item.img,
                              textCapitalization: TextCapitalization.sentences,
                              name: "img",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.img = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "img is required.",
                                ),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            //fav
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("Fav").capitalize!,
                              ),
                              initialValue: item.fav,
                              textCapitalization: TextCapitalization.sentences,
                              name: "fav",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.fav = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "fav is required.",
                                ),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            //is_main
                            const SizedBox(height: 15),

                            FormBuilderRadioGroup(
                              decoration: AppTheme.InputDecorationTheme1(
                                  hasPadding: false,
                                  label: "Main Menu",
                                  isDense: true),
                              name: 'is_main',
                              wrapRunSpacing: 0,
                              wrapSpacing: 0,
                              initialValue: item.is_main,
                              onChanged: (val) {
                                item.is_main = Utils.to_str(val, '');
                                setState(() {});
                              },
                              orientation: OptionsOrientation.horizontal,
                              validator: FormBuilderValidators.required(),
                              options: [
                                'Yes',
                                'No',
                              ]
                                  .map((lang) => FormBuilderFieldOption(
                                        value: lang,
                                      ))
                                  .toList(growable: false),
                            ),

                            //parent_id
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("Parent Id").capitalize!,
                              ),
                              initialValue: item.parent_id.toString(),
                              textCapitalization: TextCapitalization.sentences,
                              name: "parent_id",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.parent_id = int.parse(x.toString());
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "parent_id is required.",
                                ),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FxContainer(
                      color: Colors.white,
                      borderRadiusAll: 0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: is_loading
                          ? SizedBox(
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      CustomTheme.primary),
                                ),
                              ),
                            )
                          : FxButton.block(
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

  submit_form() async {
    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color: Colors.red.shade700);
      return;
    }
    setState(() {
      error_message = "";
      is_loading = true;
    });

    await item.save();
    Utils.toast('Saved successfully.', color: Colors.green.shade700);
    // Get.back();

    setState(() {
      error_message = "";
      is_loading = false;
    });
    return;
  }

  final MainController main = Get.find<MainController>();
}
