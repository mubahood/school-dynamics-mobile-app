import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/PostModel.dart';
import 'package:shimmer/shimmer.dart';

import '../models/MenuItem.dart';
import '../models/ServiceSubscription.dart';
import '../sections/widgets.dart';
import '../theme/custom_theme.dart';
import 'Utils.dart';
import 'my_colors.dart';


Widget MyButtonIcon(String title, String icon, Function f,
    {Color color = Colors.grey,
      Color textColor = Colors.black,
      double fontSize = 16,
      double iconSize = 30,
      double padding = 0,
      double borderRadius = 10,
      double borderWidth = 1,
      double height = 50,
      double width = 100}) {
  return FxButton.outlined(
    padding: EdgeInsets.all(padding),
    onPressed: () {
      f();
    },
    borderColor: color,
    block: true,
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Image(
            image: AssetImage(icon),
            width: iconSize,
          ),
        ),
        Container(
          height: height,
          width: 2,
          color: color,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: FxText.bodyLarge(
            title,
            fontWeight: 600,
            color: textColor,
            fontSize: fontSize,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget postWidget3(PostModel object, Function f, BuildContext context) {
  return InkWell(
    onTap: () {
      f();
    },
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              imageWidget(object.getLogo(), 100, 100),
              Container(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FxText(
                      object.title,
                      maxLines: 3,
                      color: Colors.black,
                    ),
                    Container(height: 5),
                    FxText(
                      "EVENT DATE: ${Utils.to_date_1(object.event_date)}",
                      maxLines: 2,
                      color: Colors.grey[700],
                    ),
                    Container(height: 5),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FxContainer(
                        color: object.isBeforeToday()
                            ? Colors.yellow.shade900
                            : CustomTheme.primary,
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: FxText(
                          object.isBeforeToday()
                              ? "PAST EVENT"
                              : "UPCOMING EVENT",
                          maxLines: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(height: 0, color: Colors.grey[300], thickness: 0.5)
      ],
    ),
  );
}

Widget postWidget2(PostModel object, Function f, BuildContext context) {
  return InkWell(
    onTap: () {
      f(object);
    },
    child: Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Card(
          margin: const EdgeInsets.all(0),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: <Widget>[
              imageWidget(object.getLogo(), 180, double.infinity),
              Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              object.title,
                            ),
                          ),
                        ],
                      ),
                      Container(height: 10),
                      Text(Utils.to_date_1(object.created_at),
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(height: 10),
                    ],
                  )),
            ],
          )),
    ),
  );
}

imageWidget(String url, double height, double width,
    {fit = BoxFit.cover, placeholder, errorWidget}) {
  return CachedNetworkImage(
    imageUrl: url,
    height: height,
    width: width,
    fit: fit,
    placeholder: (context, url) => ShimmerLoadingWidget(
      height: 100,
    ),
    errorWidget: (context, url, error) => Image(
      image: const AssetImage('assets/images/logo.png'),
      fit: BoxFit.contain,
      width: width,
      height: height,
    ),
  );
}

Widget postWidget(PostModel object, Function f, BuildContext context) {
  return InkWell(
    onTap: () {
      f(object);
    },
    child: Container(
      height: 110,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Card(
                    margin: const EdgeInsets.all(0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: CachedNetworkImage(
                      imageUrl: object.getLogo(),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => ShimmerLoadingWidget(
                        height: 100,
                      ),
                      errorWidget: (context, url, error) => const Image(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.contain,
                        width: 100,
                        height: 100,
                      ),
                    )),
                Container(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FxText(
                        object.title,
                        maxLines: 3,
                        color: Colors.black,
                      ),
                      const Spacer(),
                      Row(
                        children: <Widget>[
                          FxText(
                            object.type.toUpperCase(),
                            color: MyColors.grey_40,
                            fontSize: 12,
                          ),
                          const Spacer(),
                          FxText(
                            Utils.to_date_1(object.created_at),
                            color: MyColors.grey_40,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(height: 10),
          const Divider(height: 0)
        ],
      ),
    ),
  );
  return InkWell(
    onTap: () {
      f(object);
    },
    child: Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(0),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: CachedNetworkImage(
              imageUrl: object.getLogo(),
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => ShimmerLoadingWidget(
                height: 180,
              ),
              errorWidget: (context, url, error) => Image(
                image: const AssetImage('assets/images/logo.png'),
                fit: BoxFit.contain,
                width: (Get.width / 5),
                height: (Get.width / 5),
              ),
            ),
          ),
          Container(height: 10),
        ],
      ),
    ),
  );
}

Widget emptyListWidget(String title, Function f) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 60,
            vertical: 5,
          ),
          child: FxText.titleMedium(
            title.isEmpty ? "No items found." : title,
            color: Colors.black,
            fontWeight: 700,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        FxButton.outlined(
          onPressed: () {
            f();
          },
          padding:
          const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          borderRadiusAll: 100,
          borderColor: CustomTheme.primary,
          child: FxText.bodySmall(
            "Reload",
            color: CustomTheme.primary,
            fontWeight: 800,
          ),
        ),
      ],
    ),
  );
}

Widget ServiceSubscriptionWidget(ServiceSubscription m) => Flex(
  direction: Axis.horizontal,
  children: [
    const SizedBox(
      width: 15,
    ),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.titleMedium(
                m.administrator_text,
                color: Colors.black,
            fontWeight: 700,
          ),
          FxText.bodySmall(
            "TERM: ${m.due_term_text} \n ${m.service_text} X ${m.quantity}",
          ),
        ],
      ),
    ),
    Container(
      child: Flex(
        direction: Axis.horizontal,
        children: [
          FxText.titleLarge(
            Utils.moneyFormat(m.total),
            color: Colors.black,
            fontWeight: 800,
          ),
        ],
      ),
    ),
        const SizedBox(
          width: 15,
    ),
  ],
);

Widget menuItemWidget(MenuItem item) {
  return FxCard(
    width: (Get.width / 6),
    height: (Get.width / 6),
    borderRadiusAll: 10,
    bordered: true,
    padding: const EdgeInsets.only(left: 5, right: 5),
    onTap: () {
      item.f();
    },
    border: Border.all(
      color: CustomTheme.primary,
      width: 1,
    ),
    color: Colors.white,
    paddingAll: 0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: Image(
            image: AssetImage('assets/icons/${item.img}'),
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: FxText.bodyMedium(
                item.title,
                textAlign: TextAlign.center,
                color: Colors.black,
                letterSpacing: .001,
                fontWeight: 800,
                maxLines: 2,
                height: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    ),
  );
}

Widget valueUnitWidget2(dynamic title, dynamic value,
    {double fontSize = 6,
      double letterSpacing = -1,
      Color titleColor = Colors.grey,
      Color color = Colors.black,
      fontWeight = FontWeight.w500}) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FxText.bodySmall(
          '${title.toString().toUpperCase()}:',
          height: 0,
          color: titleColor,
        ),
        FxText.bodyLarge(
          value.toString(),
          height: 0,
          color: color,
          letterSpacing: -.5,
        ),
      ],
    ),
  );
}

Widget valueUnitWidget(BuildContext context, dynamic value, dynamic unit,
    {double fontSize = 6,
      double letterSpacing = -1,
      Color color = Colors.grey,
      Color titleColor = Colors.black,
      fontWeight = FontWeight.w500}) {
  return RichText(
    text: TextSpan(
      style: const TextStyle(
        height: 1,
        color: Colors.black,
      ),
      children: <TextSpan>[
        TextSpan(
          text: value.toString(),
          style: TextStyle(
              color: titleColor,
              letterSpacing: letterSpacing,
              fontSize: Utils.mediaWidth(context) / fontSize,
              fontWeight: fontWeight),
        ),
        TextSpan(
          text: ' ${unit.toString()}',
          style: TextStyle(
            color: color,
            fontSize: Utils.mediaWidth(context) / (fontSize * 1),
          ),
        ),
      ],
    ),
    textScaler: const TextScaler.linear(0.5),
  );
}

Widget listItem(MenuItem item) {
  return InkWell(
    onTap: () {
      item.f();
    },
    child: Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, top: 12, bottom: 12, right: 10),
                child: item.icon == null
                    ? const SizedBox(
                  height: 34,
                      )
                    : Icon(
                  item.icon,
                  size: 34,
                  color: CustomTheme.primary,
                ),
              ),
              Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      FxText.titleMedium(
                        item.title,
                        maxLines: 2,
                        height: .8,
                        fontWeight: 800,
                        color: Colors.black,
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                      ),
                      FxText.bodySmall(
                        item.subTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, top: 5),
          child: Icon(
            FeatherIcons.chevronRight,
            size: 30,
            color: CustomTheme.primary,
          ),
        ),
      ],
    ),
  );
}

Widget listItem2(MenuItem item) {
  return InkWell(
    onTap: () {
      item.f();
    },
    child: Container(
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 50, top: 0, bottom: 0, right: 5),
                  child: Icon(
                    FeatherIcons.chevronRight,
                    size: 35,
                    color: CustomTheme.primary,
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    FxText.titleMedium(
                      item.title,
                      maxLines: 2,
                      height: .8,
                      fontWeight: 600,
                      color: Colors.black,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                    FxText.bodySmall(
                      item.subTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget myListLoaderWidget(BuildContext context) {
  return SizedBox(
    height: Get.height,
    child: ListView(
      children: [
        singleLoadingWidget(context),
        singleLoadingWidget(context),
        singleLoadingWidget(context),
        singleLoadingWidget(context),
        singleLoadingWidget(context),
      ],
    ),
  );
}

Widget myContainerLoaderWidget(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade50,
    highlightColor: Colors.grey.shade300,
    child: FxContainer(
      width: Utils.mediaWidth(context) / 4,
      height: Utils.mediaWidth(context) / 4,
      color: Colors.grey,
    ),
  );
}

Widget singleLoadingWidget(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 15,
      right: 10,
      top: 8,
      bottom: 8,
    ),
    child: Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade50,
          highlightColor: Colors.grey.shade300,
          child: FxContainer(
            width: Utils.mediaWidth(context) / 4,
            height: Utils.mediaWidth(context) / 4,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade50,
              highlightColor: Colors.grey.shade300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxContainer(
                    color: Colors.grey,
                    height: Utils.mediaWidth(context) / 30,
                    width: Utils.mediaWidth(context) / 3,
                  ),
              const SizedBox(
                height: 5,
                  ),
                  FxContainer(
                    height: Utils.mediaWidth(context) / 14,
                    color: Colors.grey,
                  ),
              const SizedBox(
                height: 5,
                  ),
                  FxContainer(
                    height: Utils.mediaWidth(context) / 14,
                    color: Colors.grey,
                  ),
              const SizedBox(
                height: 5,
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      FxContainer(
                        color: Colors.grey,
                        height: Utils.mediaWidth(context) / 30,
                        width: Utils.mediaWidth(context) / 6,
                      ),
                  const Spacer(),
                  FxContainer(
                        color: Colors.grey,
                        height: Utils.mediaWidth(context) / 30,
                        width: Utils.mediaWidth(context) / 6,
                      ),
                    ],
                  )
                ],
              ),
            ))
      ],
    ),
  );
}
