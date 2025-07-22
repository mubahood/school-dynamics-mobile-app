import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:schooldynamics/models/TransportVehicleModel.dart';

import '../../theme/custom_theme.dart';

class TransportVehicleScreen extends StatefulWidget {
  Map<String, dynamic> params;

  TransportVehicleScreen(this.params, {super.key});

  @override
  TransportVehicleScreenState createState() => TransportVehicleScreenState();
}

class TransportVehicleScreenState extends State<TransportVehicleScreen> {
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
                'Vehicles',
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
                  TransportVehicleModel m = items[index];
                  return Column(
                    children: [
                      ListTile(
                          onTap: () {
                            if (isPicker) {
                              Navigator.pop(context, m);
                            }
                          },
                          dense: true,
                          subtitle: FxText.bodySmall(
                            m.registration_number,
                            color: FxAppTheme.theme.colorScheme.onSurface,
                          ),
                          title: FxText.titleLarge(m.name,
                              fontWeight: 600, letterSpacing: .5)),
                      const Divider()
                    ],
                  );
                },
                childCount: items.length, // 1000 list items
              ),
            )
          ],
        ),
      ),
    );
  }

  List<TransportVehicleModel> items = [];

  bool isPicker = false;

  Future<void> init() async {
    if (widget.params['task'] == 'picker') {
      isPicker = true;
    }
    items = await TransportVehicleModel.get_items();
    items.sort((a, b) => a.name.compareTo(b.name));

    setState(() {});
  }
}
