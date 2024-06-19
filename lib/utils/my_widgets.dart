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
import 'my_text.dart';

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
                    Text(object.title,
                        maxLines: 3,
                        style: MyText.body1(context)!.copyWith(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500)),
                    Container(height: 5),
                    Text("EVENT DATE: ${Utils.to_date_1(object.event_date)}",
                        style: MyText.body1(context)!
                            .copyWith(color: Colors.grey[900])),
                    Container(height: 5),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FxContainer(
                        color: object.isBeforeToday()
                            ? Colors.yellow.shade900
                            : CustomTheme.primary,
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Text(
                          object.isBeforeToday()
                              ? "PAST EVENT"
                              : "UPCOMING EVENT",
                          maxLines: 2,
                          style: MyText.body1(context)!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: Colors.grey[100]),
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
                            child: Text(object.title,
                                style: MyText.body2(context)!
                                    .copyWith(color: Colors.black)),
                          ),
                        ],
                      ),
                      Container(height: 10),
                      Text(Utils.to_date_1(object.created_at),
                          style: MyText.body1(context)!
                              .copyWith(color: MyColors.grey_40)),
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
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Card(
                    margin: EdgeInsets.all(0),
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
                      Text(object.title,
                          maxLines: 3,
                          style: MyText.body1(context)!.copyWith(
                              color: MyColors.grey_80,
                              fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Row(
                        children: <Widget>[
                          Text(object.type.toUpperCase(),
                              style: MyText.caption(context)!
                                  .copyWith(color: MyColors.grey_40)),
                          const Spacer(),
                          Text(Utils.to_date_1(object.created_at),
                              style: MyText.caption(context)!
                                  .copyWith(color: MyColors.grey_40)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(height: 10),
          Divider(height: 0)
        ],
      ),
    ),
  );
  return InkWell(
    onTap: () {
      f(object);
    },
    child: Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(0),
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
          Row(
            children: <Widget>[
              Text(object.title,
                  style:
                      MyText.body2(context)!.copyWith(color: MyColors.grey_40)),
              Spacer(),
              Text(object.created_at,
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_40)),
            ],
          ),
          Container(height: 10),
          Text(object.title,
              style: MyText.body1(context)!.copyWith(
                  color: MyColors.grey_80, fontWeight: FontWeight.w500)),
          Container(height: 10),
          Divider(height: 0),
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
        FxText.titleMedium(
          title.isEmpty ? "No items found." : title,
          color: Colors.black,
          fontWeight: 700,
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
            "${m.administrator_text}",
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
    SizedBox(
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
    padding: EdgeInsets.only(left: 5, right: 5),
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
      style: TextStyle(
        height: 1,
        color: Colors.black,
      ),
      children: <TextSpan>[
        TextSpan(
          text: '${value.toString()}',
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
    textScaleFactor: 0.5,
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

Widget myListLoaderWidget(BuildContext context) {
  return Container(
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
        SizedBox(
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
                  SizedBox(
                    height: 5,
                  ),
                  FxContainer(
                    height: Utils.mediaWidth(context) / 14,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  FxContainer(
                    height: Utils.mediaWidth(context) / 14,
                    color: Colors.grey,
                  ),
                  SizedBox(
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
                      Spacer(),
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
