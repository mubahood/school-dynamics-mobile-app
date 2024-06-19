import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:schooldynamics/theme/custom_theme.dart';

import '../../models/TransportParticipantModel.dart';
import 'PostModelsScreen.dart';

class NewsHomeScreen extends StatefulWidget {
  NewsHomeScreen({Key? key}) : super(key: key);

  @override
  _NewsHomeScreenState createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    my_init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<TransportParticipantModel> expected_passengers = [];
  int on_board_passengers = 0;
  int arrived_passengers = 0;
  int absent_passengers = 0;

  Future<void> my_init() async {
    setState(() {});
    arrived_passengers = 0;
    on_board_passengers = 0;
    absent_passengers = 0;
    expected_passengers.clear();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              size: 35,
            ),
            onPressed: () {
              // show_found_passenger(widget.item.passengers[0]);
              // return;
              my_init();
            },
          )
        ],
        backgroundColor: CustomTheme.primary,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.titleMedium(
              "School News".toUpperCase(),
              color: Colors.white,
              maxLines: 3,
              fontWeight: 700,
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabAlignment: TabAlignment.center,
          isScrollable: false,
          tabs: const [
            Tab(text: 'News'),
            Tab(text: 'Events'),
            Tab(text: 'Noticeboard'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.6),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                PostModelsScreen('Notice', false),
                PostModelsScreen('Event', false),
                PostModelsScreen('News', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool loading = false;
}
