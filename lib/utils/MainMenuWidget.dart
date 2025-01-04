import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';

import '../../models/MenuItem.dart';
import '../../utils/my_widgets.dart';
import '../theme/custom_theme.dart';

class MainMenuWidget extends StatefulWidget {
  MenuItem main;
  List<MenuItem> menuItems;

  MainMenuWidget(this.main, this.menuItems);

  @override
  _CourseTasksScreenState createState() => _CourseTasksScreenState();
}

class _CourseTasksScreenState extends State<MainMenuWidget> {
  _CourseTasksScreenState();

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.all(0),
      leading: Padding(
        padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
        child: widget.main.icon == null
            ? const SizedBox(
                height: 34,
              )
            : Icon(
                widget.main.icon,
                size: 34,
                color: CustomTheme.primary,
              ),
      ),
      title: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              FxText.titleMedium(
                widget.main.title,
                maxLines: 2,
                height: .8,
                fontWeight: 800,
                color: Colors.black,
                fontSize: 18,
                overflow: TextOverflow.ellipsis,
              ),
              FxText.bodySmall(
                widget.main.subTitle,
                maxLines: 1,
                color: Colors.grey.shade600,
                fontWeight: 500,
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        ],
      ),
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    MenuItem item = widget.menuItems[index];
                    item.icon = null;
                    return listItem2(item);
                  },
                  itemCount: widget.menuItems.length),
            ],
          ),
        ),
      ],
    );
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return listItem(widget.menuItems[index]);
        },
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: Colors.grey.shade200),
        itemCount: widget.menuItems.length);
  }
}
