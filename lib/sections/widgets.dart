import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/UserModel.dart';
import 'package:schooldynamics/screens/employees/EmployeeCreateScreen.dart';
import 'package:schooldynamics/screens/students/StudentScreen.dart';
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:schooldynamics/utils/AppConfig.dart';
import 'package:schooldynamics/utils/Utils.dart';
import 'package:shimmer/shimmer.dart';

import '../models/EmployeeModel.dart';
import '../models/StudentHasClassModel.dart';
import '../models/StudentVerificationModel.dart';
import '../models/UserMiniModel.dart';

Widget singleWidget2(String title, String subTitle) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FxText.bodySmall(
        title.toUpperCase(),
        color: CustomTheme.primary,
        textAlign: TextAlign.left,
        fontWeight: 800,
      ),
      FxText.bodyLarge(
        subTitle,
        maxLines: 10,
      ),
    ],
  );
}

Widget myListTile(String title, subtile, IconData icon, Function f) {
  return ListTile(
    onTap: () {
      f();
    },
    title: FxText.titleMedium(
      title,
      color: Colors.black,
      fontWeight: 700,
    ),
    dense: true,
    minLeadingWidth: 0,
    trailing: Icon(
      FeatherIcons.chevronRight,
      color: CustomTheme.primary,
    ),
    leading: Icon(
      icon,
      color: CustomTheme.primary,
    ),
    minVerticalPadding: 0,
    subtitle: FxText.bodySmall(
      subtile,
      color: Colors.black,
    ),
  );
}

Widget roundedImage2(String url, double w, double h,
    {String no_image = AppConfig.NO_IMAGE, double radius = 10}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: url,
      width: (w),
      height: (h),
      placeholder: (context, url) => ShimmerLoadingWidget(
        height: double.infinity,
      ),
      errorWidget: (context, url, error) => Image(
        image: AssetImage(no_image),
        fit: BoxFit.cover,
        width: (w),
        height: (h),
      ),
    ),
  );
}

Widget roundedImage(String url, double w, double h,
    {String no_image = AppConfig.NO_IMAGE, double radius = 10}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: url,
      width: (Get.width / w),
      height: (Get.width / h),
      placeholder: (context, url) => ShimmerLoadingWidget(
        height: double.infinity,
      ),
      errorWidget: (context, url, error) => Image(
        image: AssetImage(no_image),
        fit: BoxFit.cover,
        width: (Get.width / w),
        height: (Get.width / h),
      ),
    ),
  );
}

Widget circularImage(String url, double size,
    {String no_image = AppConfig.USER_IMAGE}) {
  return ClipOval(
    child: Container(
      color: CustomTheme.primary,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: url,
        width: (Get.width / size),
        height: (Get.width / size),
        placeholder: (context, url) => ShimmerLoadingWidget(
          height: double.infinity,
        ),
        errorWidget: (context, url, error) => Image(
          image: AssetImage(no_image),
          fit: BoxFit.cover,
          width: (Get.width / size),
          height: (Get.width / size),
        ),
      ),
    ),
  );
}

Widget titleValueWidget(String title, String subTitle) {
  return Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(bottom: 7),
    child: Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: FxText.bodyLarge(
            '$title : '.toUpperCase(),
            textAlign: TextAlign.left,
            color: Colors.black,
            fontWeight: 700,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        FxText.bodyMedium(
          subTitle.isEmpty ? "-" : subTitle,
          maxLines: 10,
          letterSpacing: .5,
          color: Colors.grey.shade800,
          height: 1,
        ),
      ],
    ),
  );
}

Widget titleValueWidget2(String title, String subTitle) {
  return Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(top: 7),
    child: Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: FxText.bodyLarge(
            '$title : '.toUpperCase(),
            textAlign: TextAlign.left,
            color: Colors.black,
            fontWeight: 700,
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        FxText.bodyLarge(
          subTitle.isEmpty ? "-" : subTitle,
          textAlign: TextAlign.right,
          fontWeight: 500,
        ),
      ],
    ),
  );
}

Widget singleWidget(String title, String subTitle) {
  /*   return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: valueUnitWidget(
        context,
        '${title} :',
        subTitle,
        fontSize: 10,
        titleColor: CustomTheme.primary,
        color: Colors.grey.shade600,
      ),
    );*/
  return Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(top: 4, bottom: 4),
    child: Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerRight,
          child: FxText.bodyLarge(
            '$title :'.toUpperCase(),
            textAlign: TextAlign.right,
            color: CustomTheme.primary,
            fontWeight: 700,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
            child: FxText.bodyLarge(
          subTitle,
          maxLines: 10,
        )),
      ],
    ),
  );
}

Widget ShimmerLoadingWidget(
    {double width = double.infinity,
    double height = 200,
    bool is_circle = false,
    double padding = 0.0}) {
  return Padding(
    padding: EdgeInsets.all(padding),
    child: SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade50,
        highlightColor: Colors.grey.shade300,
        child: const FxContainer(),
      ),
    ),
  );
}

Widget userWidget1(UserModel item) {
  return InkWell(
    onTap: () {
      Get.to(() => StudentScreen(data: item));
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: circularImage(item.avatar.toString(), 5.5),
        ),
        Center(
          child: FxText.titleSmall(
            item.name,
            maxLines: 1,
            height: 1.2,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

Widget userWidget2(StudentHasClassModel u, context, {String task_picker = ""}) {
  return InkWell(
    onTap: () {
      if (task_picker == 'task_picker') {
        Navigator.pop(context, u);
      } else {
        Get.to(() => StudentScreen(data: u));
      }
    },
    child: Container(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          roundedImage(u.administrator_photo.toString(), 4.5, 4.5),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.titleMedium(
                  u.administrator_text.toUpperCase(),
                  maxLines: 1,
                  fontWeight: 800,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    FxText.bodyMedium(
                      'CLASS: ',
                    ),
                    FxText.bodyMedium(
                      u.academic_class_id.toUpperCase(),
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
                /*Row(
                  children: [
                    FxText.bodyMedium(
                      'FEES BALANCE: ',
                    ),
                    FxText.bodyMedium(
                      'UGX ${Utils.moneyFormat(u.balance.toString())}'.toUpperCase(),
                      color: u.balance>0? Colors.red.shade800 : Colors.green.shade800,
                    ),
                  ],
                ),*/
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Icon(
                      FeatherIcons.user,
                      size: 12,
                      color: CustomTheme.primaryDark,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    FxText.bodySmall(u.administrator_text, color: Colors.grey),
                    const Spacer(),
                    Icon(
                      FeatherIcons.clock,
                      size: 12,
                      color: CustomTheme.primaryDark,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    FxText.bodySmall(
                      Utils.to_date_1(u.academic_class_text),
                      color: Colors.grey,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget userMiniWidget(UserMiniModel u) {
  return Container(
    padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
    child: Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        roundedImage(u.avatar.toString(), 7.5, 7.5),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxText.titleMedium(
                u.name.toUpperCase(),
                maxLines: 1,
                fontWeight: 800,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  FxContainer(
                    color: CustomTheme.primary,
                    borderRadiusAll: 10,
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 5,
                    ),
                    child: FxText.bodySmall(
                      u.user_type.toUpperCase(),
                      color: Colors.grey.shade100,
                      fontWeight: 800,
                    ),
                  ),
                  //phone_number not empty, display TEL
                  if (u.phone_number.isNotEmpty)
                    const SizedBox(
                      width: 5,
                    ),
                  if (u.phone_number.isNotEmpty) ...[
                    FxContainer(
                      color: CustomTheme.primary,
                      borderRadiusAll: 10,
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 5,
                      ),
                      child: FxText.bodySmall(
                        'TEL: ${u.phone_number}',
                        color: Colors.grey.shade100,
                        fontWeight: 800,
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget userWidget3(UserModel u, context, {String task_picker = ""}) {
  return InkWell(
    onTap: () {
      if (task_picker == 'task_picker') {
        Navigator.pop(context, u);
      } else {
        Get.to(() => StudentScreen(data: u));
      }
    },
    child: Container(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          roundedImage2(u.avatar.toString(), 50, 50),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.titleMedium(
                  u.name.toUpperCase(),
                  maxLines: 1,
                  fontWeight: 800,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(u.roles_text),
              ],
            ),
          ),
          //create popupMenu with view, edit and delete
          PopupMenuButton(
            icon: Icon(FeatherIcons.moreVertical,
                size: 30, color: CustomTheme.primary),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(FeatherIcons.eye),
                    title: const Text('View'),
                    onTap: () {
                      //pop
                      Navigator.pop(context);
                      Get.to(() => StudentScreen(data: u));
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(FeatherIcons.edit),
                    title: const Text('Edit'),
                    onTap: () {
                      Navigator.pop(context);
                      EmployeeModel e = EmployeeModel.fromJson(u.toJson());
                      Get.to(() => EmployeeCreateScreen({
                            'item': e,
                          }));
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    ),
  );
}

Widget userWidget(UserModel u, context, {String task_picker = ""}) {
  return InkWell(
    onTap: () {
      if (task_picker == 'task_picker') {
        Navigator.pop(context, u);
      } else {
        Get.to(() => StudentScreen(data: u));
      }
    },
    child: Container(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          roundedImage(u.avatar.toString(), 4.5, 4.5),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.titleMedium(
                  u.name.toUpperCase(),
                  maxLines: 1,
                  fontWeight: 800,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    FxText.bodyMedium(
                      'CLASS: ',
                    ),
                    FxText.bodyMedium(
                      u.current_class_text.toUpperCase(),
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
                /*Row(
                  children: [
                    FxText.bodyMedium(
                      'FEES BALANCE: ',
                    ),
                    FxText.bodyMedium(
                      'UGX ${Utils.moneyFormat(u.balance.toString())}'.toUpperCase(),
                      color: u.balance>0? Colors.red.shade800 : Colors.green.shade800,
                    ),
                  ],
                ),*/
                const SizedBox(
                  height: 6,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget accountWidget(UserModel u) {
  return Column(
    children: [
      Container(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 15),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            roundedImage(u.avatar.toString(), 8, 8),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.titleMedium(
                    u.name.toUpperCase(),
                    maxLines: 1,
                    fontWeight: 800,
                    overflow: TextOverflow.ellipsis,
                    height: 1,
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  FxText.bodySmall(
                    'CLASS: ${u.current_class_text}',
                    fontWeight: 800,
                    height: 1,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 2,
                      ),
                      FxCard(
                        padding:
                            const EdgeInsets.only(left: 5, right: 5, bottom: 0),
                        marginAll: 0,
                        color: u.verification == '1'
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        child: FxText.bodySmall(
                          u.verification == '1' ? 'Verified' : 'Not Verified',
                          fontWeight: 800,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          FxText.bodySmall('UGX'),
                        ],
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      FxText.titleLarge(
                        Utils.moneyFormat("${u.balance}"),
                        height: .6,
                        color: u.balance < 0
                            ? Colors.red.shade800
                            : Colors.green.shade800,
                        fontWeight: 900,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      const Divider(
        height: 0,
      )
    ],
  );
}

Widget studentVerificationWidget(StudentVerificationModel u, Function f) {
  return InkWell(
    onTap: () {
      f();
    },
    child: Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              roundedImage(u.avatar.toString(), 6.0, 6.0),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.titleMedium(
                      u.name.toUpperCase(),
                      maxLines: 1,
                      fontWeight: 800,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        FxText.bodyMedium(
                          'CLASS: ',
                        ),
                        FxText.bodyMedium(
                          "${u.current_class_text.isEmpty ? 'No class' : u.current_class_text.toUpperCase()} - "
                          "${u.current_stream_text.isEmpty ? 'No stream' : u.current_stream_text.toUpperCase()}",
                          color: CustomTheme.primary,
                          fontWeight: 900,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        FxText.bodyMedium(
                          'STATUS : ',
                        ),
                        FxContainer(
                          color: u.status == '1'
                              ? Colors.green.shade800
                              : u.status == '0'
                                  ? Colors.red.shade800
                                  : u.status == '2'
                                      ? Colors.yellow.shade900
                                      : CustomTheme.primary,
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 0, bottom: 0),
                          child: FxText.bodySmall(
                            u.status == '1'
                                ? 'ACTIVE'
                                : u.status == '2'
                                    ? 'PENDING'
                                    : 'NOT ACTIVE',
                            color: Colors.white,
                            fontWeight: 800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: const Divider(height: 0),
        ),
      ],
    ),
  );
}

Widget alertWidget(String msg, String type) {
  if (msg.isEmpty) {
    return const SizedBox();
  }
  Color borderColor = CustomTheme.primary;
  Color bgColor = CustomTheme.primary.withAlpha(10);
  if (type == 'success') {
    borderColor = Colors.green.shade700;
    bgColor = Colors.green.shade700.withAlpha(10);
  } else if (type == 'danger') {
    borderColor = Colors.red.shade700;
    bgColor = Colors.red.shade700.withAlpha(10);
  }

  return FxContainer(
    margin: const EdgeInsets.only(bottom: 15),
    width: double.infinity,
    color: bgColor,
    bordered: true,
    borderColor: borderColor,
    child: FxText(msg),
  );
}

Widget noItemWidget(String title, Function onTap) {
  if (title.isEmpty) {
    title = "😇 No item found.";
  }
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FxText(
          title,
        ),
        FxButton.text(
            onPressed: () {
              onTap();
            },
            child: const Text("Reload"))
      ],
    ),
  );
}

Widget titleWidget(String title, Function onTap) {
  return InkWell(
    onTap: () {
      onTap();
    },
    child: Container(
      padding: const EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 10),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          FxText.titleMedium(
            title.toUpperCase(),
            fontWeight: 700,
            color: Colors.black,
          ),
          const Spacer(),
          Row(
            children: [
              FxText.bodyLarge(
                'View All'.toUpperCase(),
                fontWeight: 300,
                letterSpacing: .1,
              ),
              const Icon(FeatherIcons.chevronRight),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget textInput(
  context, {
  required String label,
  required String name,
  required String value,
  bool required = false,
}) {
  return FormBuilderTextField(
    decoration: CustomTheme.in_3(
      label: label,
    ),
    initialValue: value,
    textCapitalization: TextCapitalization.sentences,
    name: name,
    validator: (!required)
        ? FormBuilderValidators.compose([])
        : MyWidgets.my_validator_field_required(context, 'Title is required'),
    textInputAction: TextInputAction.next,
  );
}

// ignore: non_constant_identifier_names
Widget title_widget_2(String title) {
  return FxContainer(
    alignment: Alignment.center,
    color: CustomTheme.primaryDark,
    borderRadiusAll: 0,
    paddingAll: 5,
    child: FxText.bodyLarge(
      title,
      color: Colors.white,
    ),
  );
}

// ignore: non_constant_identifier_names
Widget title_widget(String title) {
  return Row(
    children: [
      Container(
        color: Colors.grey,
        height: 18,
        width: 10,
      ),
      const SizedBox(
        width: 5,
      ),
      FxText.titleMedium(
        title,
        textAlign: TextAlign.center,
        fontWeight: 800,
        fontSize: 18,
        color: CustomTheme.primary,
      ),
      const SizedBox(
        width: 5,
      ),
      Expanded(
          child: Container(
        color: Colors.grey,
        height: 18,
      ))
    ],
  );
}

// ignore: non_constant_identifier_names
Widget IconTextWidget(
  String t,
  String s,
  bool isDone,
  Function f, {
  bool show_acation_button = true,
  String action_text = "Edit",
}) {
  return ListTile(
    leading: isDone
        ? const Icon(
            Icons.check,
            color: Colors.green,
            size: 28,
          )
        : Icon(
            Icons.label_outline_sharp,
            color: Colors.red.shade600,
            size: 28,
          ),
    contentPadding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
    minLeadingWidth: 0,
    trailing: (!show_acation_button)
        ? null
        : FxButton.outlined(
            onPressed: () {
              f();
            },
            padding: EdgeInsets.zero,
            borderRadiusAll: 30,
            borderColor: CustomTheme.primary,
            child: FxText(
              action_text,
              color: CustomTheme.primary,
              fontSize: 18,
            ),
          ),
    title: FxText.titleMedium(
      t,
      fontWeight: 700,
      color: Colors.black,
    ),
    subtitle: FxText.bodyMedium(s,
        fontWeight: 600,
        maxLines: 2,
        color: Colors.grey.shade700,
        height: 1.1,
        overflow: TextOverflow.ellipsis),
  );
}

class MyWidgets {
  static FormFieldValidator my_validator_field_required(
      BuildContext context, String field) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(
        errorText: "$field is required.",
      ),
    ]);
  }
}
