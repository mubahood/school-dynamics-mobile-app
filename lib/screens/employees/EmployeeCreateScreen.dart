import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/RoleModel.dart';
import 'package:schooldynamics/sections/widgets.dart';

import '../../models/EmployeeModel.dart';
import '../../models/RespondModel.dart';
import '../../sections/ImagePickerWisget.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';

class EmployeeCreateScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  EmployeeCreateScreen(
    this.params, {
    Key? key,
  }) : super(key: key);

  @override
  EmployeeCreateScreenState createState() => EmployeeCreateScreenState();
}

class EmployeeCreateScreenState extends State<EmployeeCreateScreen>
    with SingleTickerProviderStateMixin {
  var initFuture;
  final _fKey = GlobalKey<FormBuilderState>();
  bool is_loading = false;
  String add_more_info = 'No';
  String error_message = "";
  String avatar_path = "";
  EmployeeModel item = EmployeeModel();
  List<RoleModel> roles = [];
  List<String> user_roles = [];

  Future<bool> init_form() async {
    roles = await RoleModel.get_items();
    if (roles.isEmpty) {
      await RoleModel.getOnlineItems();
      roles = await RoleModel.get_items();
    }
    setState(() {});

    if (widget.params['item'].runtimeType == item.runtimeType) {
      item = widget.params['item'];
      if (item.id > 0) {
        isEditing = true;
      } else {
        isEditing = false;
        item = EmployeeModel();
      }
    }
    if (item.passport_number.isEmpty) {
      item.passport_number = '+256';
      item.nationality = 'Uganda';
    }

    if (item.roles_text.toString().length > 2) {
      user_roles = [];
      try {
        var x = jsonDecode(item.roles_text.toString());
        for (var y in x) {
          user_roles.add(y.toString());
        }
      } catch (e) {
        user_roles = [];
      }
    }

    setState(() {});

    return true;
  }

  bool isEditing = false;

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
          "${isEditing ? 'Update' : 'Create'} Employee",
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                            error_message.isEmpty
                                ? const SizedBox()
                                : FxContainer(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    color: Colors.red.shade50,
                                    child: Text(
                                      error_message,
                                    ),
                                  ),
                            title_widget("Basic Information".toUpperCase()),


                            const SizedBox(height: 10),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label:
                                    GetStringUtils("first name *").capitalize!,
                              ),
                              initialValue: item.first_name,
                              textCapitalization: TextCapitalization.sentences,
                              name: "first_name",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.first_name = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "first_name is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "first_name is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText: "first_name is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 10),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label:
                                    GetStringUtils("last name *").capitalize!,
                              ),
                              initialValue: item.last_name,
                              textCapitalization: TextCapitalization.sentences,
                              name: "last_name",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.last_name = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "last_name is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "last_name is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText: "last_name is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: FormBuilderTextField(
                                    decoration: InputDecoration(
                                      labelText: "Phone Number",
                                      hintText: "e.g 783204665",
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      prefixIcon: CountryCodePicker(
                                        initialSelection:
                                            item.nationality.isEmpty
                                                ? 'UG'
                                                : item.nationality,
                                        onChanged: (CountryCode? code) {
                                          if (code == null) {
                                            return;
                                          }
                                          item.passport_number =
                                              code.dialCode!.toString();

                                          _fKey.currentState!.patchValue({
                                            'phone_number': '',
                                          });
                                          item.nationality =
                                              code.name!.toString();
                                        },
                                        favorite: const [
                                          '+256',
                                        ],
                                        showFlagDialog: false,
                                        showFlag: true,
                                        showCountryOnly: false,
                                        padding: const EdgeInsets.all(0),
                                        backgroundColor: Colors.transparent,
                                        barrierColor:
                                            CustomTheme.primary.withAlpha(50),
                                        searchDecoration: const InputDecoration(
                                          hintText: 'Search',
                                          hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),

                                        //You can set the margin between the flag and the country name to your taste.
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        comparator: (a, b) =>
                                            b.name!.compareTo(a.name!),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 10,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                        errorText: "Phone number is required.",
                                      ),
                                      FormBuilderValidators.numeric(
                                        errorText: "Invalid phone number.",
                                      ),
                                      //max
                                      FormBuilderValidators.maxLength(12,
                                          errorText: "Invalid phone number."),
                                      //min
                                      FormBuilderValidators.minLength(6,
                                          errorText: "Invalid phone number."),
                                    ]),
                                    keyboardType: TextInputType.phone,
                                    name: "phone_number",
                                    initialValue: item.phone_number_1
                                        .replaceAll(item.passport_number, ''),
                                    onChanged: (String? val) {
                                      if (val == null) {
                                        return;
                                      }
                                      //must not start with 0
                                      if (val.startsWith('0')) {
                                        item.phone_number_1 = '';
                                        _fKey.currentState!.patchValue({
                                          'phone_number': val.substring(1),
                                        });
                                        Utils.toast(
                                            "Phone number must not start with 0.",
                                            color: Colors.red);
                                        return;
                                      }
                                      item.phone_number_1 =
                                          val.trim().toString();
                                    },
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            FormBuilderRadioGroup(
                              name: 'sex',
                              initialValue: item.sex,
                              onChanged: (x) {
                                item.sex = x.toString();
                              },
                              decoration: CustomTheme.in_4(
                                label: "Gender *",
                                vPadding: 0,
                                hPadding: 0,
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Gender is required.",
                                ),
                              ]),
                              options: const [
                                FormBuilderFieldOption(
                                  value: 'Male',
                                ),
                                FormBuilderFieldOption(
                                  value: 'Female',
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            ImagePickerWidget(
                              avatar_path,
                              item.avatar,
                              'Employee Photo',
                              (x) {
                                avatar_path = x.toString();
                                setState(() {});
                              },
                            ),
                            const SizedBox(height: 15),
                            FormBuilderRadioGroup(
                              name: 'add_more_info',
                              initialValue: add_more_info,
                              onChanged: (x) {
                                add_more_info = x.toString();
                                setState(() {});
                              },
                              decoration: CustomTheme.in_4(
                                label: "Add more information",
                                vPadding: 0,
                                hPadding: 0,
                              ),
                              options: const [
                                FormBuilderFieldOption(
                                  value: 'Yes',
                                ),
                                FormBuilderFieldOption(
                                  value: 'No',
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            add_more_info != 'Yes'
                                ? const SizedBox()
                                : Column(
                                    children: [

                                      title_widget("Roles Assignment".toUpperCase()),

                                      //slect roles using checkbox
                                      FormBuilderCheckboxGroup(
                                        name: 'roles_text',
                                        onChanged: (x) {
                                          new_roles = x.toString();
                                        },
                                        initialValue: user_roles,
                                        options: roles.map((role) {
                                          return FormBuilderFieldOption(
                                            value: role.id.toString(),
                                            child: Text(role.name),
                                          );
                                        }).toList(),
                                      ),

                                      title_widget("Bio Data".toUpperCase()),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      FormBuilderDateTimePicker(
                                        decoration: CustomTheme.in_4(
                                          label: "Date of birth",
                                        ),
                                        enabled: true,
                                        initialValue:
                                            Utils.toDate(item.date_of_birth),
                                        lastDate: DateTime.now(),
                                        inputType: InputType.date,
                                        initialDatePickerMode:
                                            DatePickerMode.year,
                                        initialDate:
                                            DateTime(DateTime.now().year - 24),
                                        onChanged: (value) {
                                          if (value == null) {
                                            return;
                                          }
                                          item.date_of_birth =
                                              "${value.day}/${value.month}/${value.year}";
                                        },
                                        name: "date_of_birth",
                                        textInputAction: TextInputAction.done,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label:
                                              GetStringUtils("phone number 2")
                                                  .capitalize!,
                                        ),
                                        initialValue: item.phone_number_2,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "phone_number_2",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.phone_number_2 = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label:
                                              GetStringUtils("place of birth")
                                                  .capitalize!,
                                        ),
                                        initialValue: item.place_of_birth,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "place_of_birth",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.place_of_birth = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label:
                                              GetStringUtils("Current address")
                                                  .capitalize!,
                                        ),
                                        initialValue: item.current_address,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "current_address",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.current_address = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils("Email Address")
                                              .capitalize!,
                                        ),
                                        initialValue: item.email,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "email",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.email = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils("religion")
                                              .capitalize!,
                                        ),
                                        initialValue: item.religion,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "religion",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.religion = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils("spouse name")
                                              .capitalize!,
                                        ),
                                        initialValue: item.spouse_name,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "spouse_name",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.spouse_name = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label:
                                              GetStringUtils("Spouse Contact")
                                                  .capitalize!,
                                        ),
                                        initialValue: item.spouse_phone,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "spouse_phone",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.spouse_phone = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils("Father's name")
                                              .capitalize!,
                                        ),
                                        initialValue: item.father_name,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "father_name",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.father_name = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label:
                                              GetStringUtils("Father's contact")
                                                  .capitalize!,
                                        ),
                                        initialValue: item.father_phone,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "father_phone",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.father_phone = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils("Mother's name")
                                              .capitalize!,
                                        ),
                                        initialValue: item.mother_name,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "mother_name",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.mother_name = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label:
                                              GetStringUtils("Mother's phone")
                                                  .capitalize!,
                                        ),
                                        initialValue: item.mother_phone,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "mother_phone",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.mother_phone = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "emergency person name")
                                              .capitalize!,
                                        ),
                                        initialValue:
                                            item.emergency_person_name,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "emergency_person_name",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.emergency_person_name =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "Emergency person's contact")
                                              .capitalize!,
                                        ),
                                        initialValue:
                                            item.emergency_person_phone,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "emergency_person_phone",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.emergency_person_phone =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      title_widget(
                                          "ACCOUNT NUMBERS".toUpperCase()),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "national ID number")
                                              .capitalize!,
                                        ),
                                        initialValue: item.national_id_number,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "national_id_number",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.national_id_number =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label:
                                              GetStringUtils("TIN").capitalize!,
                                        ),
                                        initialValue: item.tin,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "tin",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.tin = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils("nssf number")
                                              .capitalize!,
                                        ),
                                        initialValue: item.nssf_number,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "nssf_number",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.nssf_number = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils("bank name")
                                              .capitalize!,
                                        ),
                                        initialValue: item.bank_name,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "bank_name",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.bank_name = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "bank account number")
                                              .capitalize!,
                                        ),
                                        initialValue: item.bank_account_number,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "bank_account_number",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.bank_account_number =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      title_widget("Academics".toUpperCase()),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "primary school name")
                                              .capitalize!,
                                        ),
                                        initialValue: item.primary_school_name,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "primary_school_name",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.primary_school_name =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "primary school year graduated")
                                              .capitalize!,
                                        ),
                                        initialValue:
                                            item.primary_school_year_graduated,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "primary_school_year_graduated",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.primary_school_year_graduated =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "Secondary school name")
                                              .capitalize!,
                                        ),
                                        initialValue: item.seconday_school_name,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "seconday_school_name",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.seconday_school_name =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "Secondary school year graduated")
                                              .capitalize!,
                                        ),
                                        initialValue:
                                            item.seconday_school_year_graduated,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "seconday_school_year_graduated",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.seconday_school_year_graduated =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label:
                                              GetStringUtils("high school name")
                                                  .capitalize!,
                                        ),
                                        initialValue: item.high_school_name,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "high_school_name",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.high_school_name = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "high school year graduated")
                                              .capitalize!,
                                        ),
                                        initialValue:
                                            item.high_school_year_graduated,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "high_school_year_graduated",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.high_school_year_graduated =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "degree university name")
                                              .capitalize!,
                                        ),
                                        initialValue:
                                            item.degree_university_name,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "degree_university_name",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.degree_university_name =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "degree university year graduated")
                                              .capitalize!,
                                        ),
                                        initialValue: item
                                            .degree_university_year_graduated,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name:
                                            "degree_university_year_graduated",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.degree_university_year_graduated =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "masters university name")
                                              .capitalize!,
                                        ),
                                        initialValue:
                                            item.masters_university_name,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "masters_university_name",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.masters_university_name =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "masters university year graduated")
                                              .capitalize!,
                                        ),
                                        initialValue: item
                                            .masters_university_year_graduated,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name:
                                            "masters_university_year_graduated",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.masters_university_year_graduated =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "phd university name")
                                              .capitalize!,
                                        ),
                                        initialValue: item.phd_university_name,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "phd_university_name",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.phd_university_name =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "phd university year graduated")
                                              .capitalize!,
                                        ),
                                        initialValue:
                                            item.phd_university_year_graduated,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "phd_university_year_graduated",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.phd_university_year_graduated =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label:
                                              GetStringUtils("marital status")
                                                  .capitalize!,
                                        ),
                                        initialValue: item.marital_status,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "marital_status",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.marital_status = x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "diploma school name")
                                              .capitalize!,
                                        ),
                                        initialValue: item.diploma_school_name,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "diploma_school_name",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.diploma_school_name =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "diploma year graduated")
                                              .capitalize!,
                                        ),
                                        initialValue:
                                            item.diploma_year_graduated,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "diploma_year_graduated",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.diploma_year_graduated =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "certificate school name")
                                              .capitalize!,
                                        ),
                                        initialValue:
                                            item.certificate_school_name,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "certificate_school_name",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.certificate_school_name =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_4(
                                          label: GetStringUtils(
                                                  "certificate year graduated")
                                              .capitalize!,
                                        ),
                                        initialValue:
                                            item.certificate_year_graduated,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "certificate_year_graduated",
                                        enableSuggestions: true,
                                        onChanged: (x) {
                                          item.certificate_year_graduated =
                                              x.toString();
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _keyboardVisible
                      ? SizedBox()
                      : is_loading
                          ? Container(
                              height: 50,
                              color: Colors.white,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                              ),
                            )
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

  String new_roles = '';

  submit_form() async {
    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color: Colors.red.shade700);
      return;
    }

    item.phone_number_1 =
        "${item.passport_number}${item.phone_number_1.replaceAll(item.passport_number, '')}";

    setState(() {
      error_message = "";
      is_loading = true;
    });
    Map<String, dynamic> data = item.toJson();

    if (avatar_path.isNotEmpty) {
      data['avatar_path'] =
          await DIO.MultipartFile.fromFile(avatar_path, filename: avatar_path);
    }

    if (new_roles.length > 1) {
      data['new_roles'] = new_roles;
    }

    RespondModel resp =
        RespondModel(await Utils.http_post('employee-create', data));

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

    EmployeeModel e = EmployeeModel.fromJson(resp.data);
    if (e.id < 1) {
      Utils.toast('Failed to parse data.', color: Colors.red.shade700);
      return;
    }
    await e.save();
    widget.params['item'] = e;
    item = e;
    setState(() {});

    Utils.toast(resp.message);

    Navigator.pop(context);
    return;
  }
}
