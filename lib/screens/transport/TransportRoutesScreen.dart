import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../../models/TransportStage.dart';
import '../../theme/custom_theme.dart';

class TransportRoutesScreen extends StatefulWidget {
  Map<String, dynamic> params;

  TransportRoutesScreen(this.params, {super.key});

  @override
  TransportRoutesScreenState createState() => TransportRoutesScreenState();
}

class TransportRoutesScreenState extends State<TransportRoutesScreen> {
  Future<void> submit_form() async {
    init();
    return;
  }

  String error_message = "";
  bool is_loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          titleSpacing: 0,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          // remove back button in appbar.
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxText.titleLarge(
                'Transport Routes',
                color: Colors.white,
                fontWeight: 700,
                height: .8,
              ),
            ],
          )),
      body: RefreshIndicator(
        onRefresh: () async {
          await init();
        },
        color: CustomTheme.primary,
        backgroundColor: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  TransportStage m = items[index];
                  return ListTile(
                      onTap: () {
                        if (isPicker) {
                          Navigator.pop(context, m);
                        }
                      },
                      dense: true,
                      title: FxText.titleLarge(m.name));
                },
                childCount: items.length, // 1000 list items
              ),
            )
          ],
        ),
      ),
    );
  }

  List<TransportStage> items = [];

  bool isPicker = false;

  Future<void> init() async {
    if (widget.params['task'] == 'picker') {
      isPicker = true;
    }
    items = await TransportStage.get_items();
    items.sort((a, b) => a.name.compareTo(b.name));

    setState(() {});
  }
}
