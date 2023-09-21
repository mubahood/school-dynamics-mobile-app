import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/widgets/card/card.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../models/MenuItem.dart';
import '../models/ServiceSubscription.dart';
import '../theme/custom_theme.dart';
import 'Utils.dart';

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
    bordered: false,
    padding: EdgeInsets.only(left: 5, right: 5),
    onTap: () {
      item.f();
    },
    color: Colors.white,
    paddingAll: 0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage('assets/icons/${item.img}'),
          fit: BoxFit.cover,
          height: Get.width/4,
        ),
        SizedBox(
          height: 3,
        ),
        FxText.bodyMedium(
          item.title,
          textAlign: TextAlign.center,
          color: Colors.black,
          letterSpacing: .001,
          fontWeight: 800,
          maxLines: 2,
          height: 1,
          overflow: TextOverflow.ellipsis,
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
  return ListView(
    children: [
      singleLoadingWidget(context),
      singleLoadingWidget(context),
      singleLoadingWidget(context),
      singleLoadingWidget(context),
      singleLoadingWidget(context),
    ],
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
    padding: EdgeInsets.only(
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
