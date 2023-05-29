import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:schooldynamics/models/MarksModel.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../models/Service.dart';
import '../../theme/custom_theme.dart';
import '../../utils/my_widgets.dart';

class ServicesScreen extends StatefulWidget {

  Map<String, String> params = {};

  ServicesScreen(this.params, {Key? key}) : super(key: key);



  @override
  ServicesScreenState createState() => ServicesScreenState();
}

class ServicesScreenState extends State<ServicesScreen> {
  List<ServiceModel> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doRefresh();
  }

  bool isPickTask = false;
  Future<dynamic> doRefresh() async {
    futureInit = init();

    if (widget.params != null) {
      if (widget.params['task_picker'] != null) {
        isPickTask = true;
      }
    }

    setState(() {});
  }

  late Future<dynamic> futureInit;
  MarksModel localMark = MarksModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          titleSpacing: 0,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          // remove back button in appbar.
          title: FxText.titleLarge(
            "Services",
            color: Colors.white,
          )),
      body: FutureBuilder(
          future: futureInit,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return myListLoaderWidget(context);
            }
            if (items.isEmpty) {
              return Center(child: FxText('No item found.'));
            }

            return RefreshIndicator(
              backgroundColor: Colors.white,
              onRefresh: doRefresh,
              child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                        height: 15,
                      ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final ServiceModel m = items[index];
                    return InkWell(
                      onTap: (){
                        if(isPickTask){
                          Navigator.pop(context,m);
                        }
                      },
                      child: Flex(
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
                                  m.name,
                                  color: Colors.black,
                                  fontWeight: 700,
                                ),
                                FxText.bodySmall("${m.description}"),
                              ],
                            ),
                          ),
                          Container(
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                FxText.titleLarge(
                                  Utils.moneyFormat(m.fee),
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
                      ),
                    );
                  }),
            );
          }),
    );
  }

  Future<void> init() async {
    items = await ServiceModel.getItems();
    setState(() {});
  }
}
