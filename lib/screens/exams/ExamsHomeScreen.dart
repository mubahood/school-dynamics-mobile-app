import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/screens/exams/MarksScreen.dart';
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:schooldynamics/theme/custom_theme.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../models/TermlyReportCard.dart';
import '../../models/TheologyTermlyReportCard.dart';
import 'TheologyMarksScreen.dart';

class ExamsHomeScreen extends StatefulWidget {
  const ExamsHomeScreen({super.key});

  @override
  State<ExamsHomeScreen> createState() => _ExamsHomeScreenState();
}

class _ExamsHomeScreenState extends State<ExamsHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myInit();
  }

  TermlyReportCard activeReportCard = TermlyReportCard();
  TheologyTermlyReportCard theologyActiveReportCard =
      TheologyTermlyReportCard();

  myInit() async {
    List<TermlyReportCard> termlyReports = await TermlyReportCard.get_items();
    List<TheologyTermlyReportCard> theologyTermlyReports =
        await TheologyTermlyReportCard.get_items();

    Utils.showLoader(true);

    if (termlyReports.isEmpty) {
      await TermlyReportCard.getOnlineItems();
      termlyReports = await TermlyReportCard.get_items();
    }
    if (theologyTermlyReports.isEmpty) {
      await TheologyTermlyReportCard.getOnlineItems();
      theologyTermlyReports = await TheologyTermlyReportCard.get_items();
    }

    if (termlyReports.isNotEmpty) {
      activeReportCard = termlyReports.first;
    } else {
      Utils.toast(
          "No active report card for this term. Please contact system admin.",
          color: Colors.red);
      Utils.hideLoader();
      //Get.back();
      return;
    }

    if (theologyTermlyReports.isNotEmpty) {
      theologyActiveReportCard = theologyTermlyReports.first;
    } else {
      Utils.toast(
          "Theology: No active report card for this term. Please contact system admin.",
          color: Colors.red);
      Utils.hideLoader();
      //Get.back();
      return;
    }

    setState(() {});
    Utils.hideLoader();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FxContainer(
            borderRadiusAll: 0,
            width: double.infinity,
            color: CustomTheme.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  height: 0,
                ),
                const SizedBox(
                  height: 10,
                ),
                FxText.bodyLarge(
                  'CURRENT TERM: Term ${activeReportCard.term_text}',
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 5,
                ),
                FxText.bodyLarge(
                  'ACTIVE MARKS SUBMISSION: ${activeReportCard.getName(activeReportCard.activeMarkSubmission())}',
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
              child: RefreshIndicator(
            onRefresh: () async {
              myInit();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      if (activeReportCard.term_id == '0') {
                        Utils.toast(
                            "No active report card for this term. Please contact system admin.",
                            color: Colors.red);
                        return;
                      }
                      Get.to(() => MarksScreen(const {}, activeReportCard));
                    },
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    title: FxText.titleLarge('Secular Marks', fontWeight: 700),
                    leading: const Icon(FeatherIcons.bookOpen),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      size: 30,
                    ),
                  ),
                 /* Divider(
                    height: 0,
                    color: CustomTheme.primary,
                  ),
                  ListTile(
                    onTap: () {
                      if (activeReportCard.term_id == '0') {
                        Utils.toast(
                            "No active report card for this term. Please contact system admin.",
                            color: Colors.red);
                        return;
                      }
                      Get.to(
                          () => ReportCardsScreen(const {}, activeReportCard));
                    },
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    title: FxText.titleLarge('Secular Report Cards',
                        fontWeight: 700),
                    leading: const Icon(FeatherIcons.bookOpen),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      size: 30,
                    ),
                  ),*/
                  Divider(
                    height: 0,
                    color: CustomTheme.primary,
                  ),
                  ListTile(
                    onTap: () {
                      if (theologyActiveReportCard.term_id == '0') {
                        Utils.toast(
                            "Theology: No active report card for this term. Please contact system admin.",
                            color: Colors.red);
                        return;
                      }
                      Get.to(() => TheologyMarksScreen(
                          const {}, theologyActiveReportCard));
                    },
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    title:
                        FxText.titleLarge('Theological Marks', fontWeight: 700),
                    leading: const Icon(FeatherIcons.book),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      size: 30,
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: CustomTheme.primary,
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
      appBar: AppBar(
        systemOverlayStyle: Utils.overlay(),
        actions: [
          InkWell(
              onTap: () {
                myInit();
              },
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 35,
              )),
          const SizedBox(
            width: 15,
          )
        ],
        title: FxText.titleLarge(
          'Exams & Report-cards',
          color: Colors.white,
          fontWeight: 700,
        ),
      ),
    );
  }
}
