import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/RespondModel.dart';
import 'package:schooldynamics/models/UserModel.dart';

import '../../models/LoggedInUserModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/Utils.dart';
import '../OnBoardingScreen.dart';

class UserAccountCreateScreen extends StatefulWidget {
  UserModel u;
  String task;

  UserAccountCreateScreen(this.u, this.task, {super.key});

  @override
  State<UserAccountCreateScreen> createState() =>
      _UserAccountCreateScreenState();
}

class _UserAccountCreateScreenState extends State<UserAccountCreateScreen> {
  final _fKey = GlobalKey<FormBuilderState>();
  UserModel item = UserModel();
  String country = '+256';
  String phone_number = '+256';

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
              const SizedBox(height: 0),
              FormBuilderTextField(
                decoration: CustomTheme.in_4(
                  label: "First Name",
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: "First name is required.",
                  ),
                ]),
                initialValue: item.first_name,
                textCapitalization: TextCapitalization.words,
                name: "first_name",
                onChanged: (String? val) {
                  if (val == null) {
                    return;
                  }
                  item.first_name = val.trim().toString();
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              FormBuilderTextField(
                decoration: CustomTheme.in_4(
                  label: "Last Name",
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: "Last name is required.",
                  ),
                ]),
                initialValue: item.last_name,
                textCapitalization: TextCapitalization.words,
                name: "last_name",
                onChanged: (String? val) {
                  if (val == null) {
                    return;
                  }
                  item.last_name = val.trim().toString();
                },
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 15),
              FormBuilderRadioGroup(
                decoration: AppTheme.InputDecorationTheme1(
                    hasPadding: false, label: "Gender", isDense: true),
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

              const SizedBox(height: 15),
              //phone_number_1
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
                          onChanged: (CountryCode? code) {
                            if (code == null) {
                              return;
                            }
                            country = code.dialCode!.toString();

                            _fKey.currentState!.patchValue({
                              'phone_number': '',
                            });
                            item.nationality = code.name!.toString();
                          },
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: 'UG',
                          favorite: const [
                            '+256',
                          ],
                          showFlagDialog: false,
                          showFlag: true,
                          showCountryOnly: false,
                          padding: const EdgeInsets.all(0),
                          backgroundColor: Colors.transparent,
                          barrierColor: CustomTheme.primary.withAlpha(50),
                          searchDecoration: const InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),

                          //You can set the margin between the flag and the country name to your taste.
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          comparator: (a, b) => b.name!.compareTo(a.name!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
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
                      onChanged: (String? val) {
                        if (val == null) {
                          return;
                        }
                        //must not start with 0
                        if (val.startsWith('0')) {
                          phone_number = '';
                          _fKey.currentState!.patchValue({
                            'phone_number': val.substring(1),
                          });
                          Utils.toast("Phone number must not start with 0.",
                              color: Colors.red);
                          return;
                        }
                        phone_number = val.trim().toString();
                      },
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              //country nationality
              FormBuilderTextField(
                decoration: CustomTheme.in_4(
                  label: "Location Address",
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: "Address is required.",
                  ),
                ]),
                initialValue: item.nationality,
                enableSuggestions: true,
                textCapitalization: TextCapitalization.characters,
                name: "address",
                onChanged: (String? val) {
                  if (val == null) {
                    return;
                  }
                  item.current_address = val.trim().toString().toUpperCase();
                },
                textInputAction: TextInputAction.next,
              ),
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
                onChanged: (String? val) {
                  if (val == null) {
                    return;
                  }
                  item.email = val.trim().toString();
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              //password
              FormBuilderTextField(
                decoration: CustomTheme.in_4(
                  label: "Password",
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
                obscureText: true,
                obscuringCharacter: '*',
                keyboardType: TextInputType.visiblePassword,
                name: "password",
                onChanged: (String? val) {
                  if (val == null) {
                    return;
                  }
                  item.password = val.trim().toString();
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              //confirm password
              FormBuilderTextField(
                decoration: CustomTheme.in_4(
                  label: "Confirm Password",
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: "Confirm password is required.",
                  ),
                ]),
                obscureText: true,
                obscuringCharacter: '*',
                keyboardType: TextInputType.visiblePassword,
                name: "confirm_password",
                onChanged: (String? val) {
                  if (val == null) {
                    return;
                  }
                  item.confirm_password = val.trim().toString();
                },
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 15),

              error_message.isEmpty
                  ? const SizedBox()
                  : FxContainer(
                      width: double.infinity,
                      borderColor: Colors.red.shade900,
                      bordered: true,
                      margin: const EdgeInsets.only(bottom: 10),
                      color: Colors.red.shade50,
                      child: FxText.bodySmall(
                        error_message,
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
                        if (_fKey.currentState!.saveAndValidate()) {
                          if (item.password != item.confirm_password) {
                            Utils.toast("Passwords do not match.",
                                color: Colors.red);
                            return;
                          }
                        } else {
                          Utils.toast("Please fill all fields.",
                              color: Colors.red);
                          return;
                        }
                        upload();
                      },
                      child: const Text(
                        'Create New Account',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> upload() async {
    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color: Colors.red.shade700);
      return;
    }
    error_message = "";
    setState(() {});
    //do some more validation
    if (item.password != item.confirm_password) {
      Utils.toast("Passwords do not match.", color: Colors.red);
      return;
    }

    //do some more validation
    if (item.phone_number_1.length < 6) {
      Utils.toast("Invalid phone number.", color: Colors.red);
      return;
    }
    //do some more validation
    if (item.current_address.length < 6) {
      Utils.toast("Invalid address.", color: Colors.red);
      return;
    }
    //do some more validation
    if (item.email.length < 4) {
      Utils.toast("Invalid email address.", color: Colors.red);
      return;
    }
    //do some more validation
    if (item.password.length < 4) {
      Utils.toast("Password is too short.", color: Colors.red);
      return;
    }
    //do some more validation
    if (item.first_name.length < 2) {
      Utils.toast("First name is too short.", color: Colors.red);
      return;
    }
    //do some more validation
    if (item.last_name.length < 2) {
      Utils.toast("Last name is too short.", color: Colors.red);
      return;
    }
    item.phone_number_1 = "$country$phone_number";
    //do some more validation
    if (item.phone_number_1.length < 6) {
      Utils.toast("Invalid phone number.", color: Colors.red);
      return;
    }
    Utils.toast("Creating account... ${item.phone_number_1}",
        color: Colors.green);
    Utils.showLoader(true);

    error_message = "";
    setState(() {});
    RespondModel resp =
        RespondModel(await Utils.http_post('users/register', item.toJson()));

    Utils.hideLoader();

    if (resp.code != 1) {
      is_loading = false;
      error_message = resp.message;
      Utils.toast(resp.message);
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
      error_message = 'Failed to retrieve you in.';
      setState(() {});
      return;
    }

    await Utils.setPref('token', lu.remember_token);

    String token = await Utils.getToken();
    if (token.isEmpty) {
      error_message = 'Failed to save token.';
      Utils.toast("Failed to save token.");
      setState(() {});
      return;
    }

    setState(() {});

    Get.off(const OnBoardingScreen());
  }

  bool is_loading = false;
  String error_message = "";
}
