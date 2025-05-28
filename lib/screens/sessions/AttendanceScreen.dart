import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/screens/sessions/SessionLocalScreen.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../models/RollCall/Participant.dart';
import '../../models/SessionLocal.dart';
import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';
import 'SessionCreateNewScreen.dart';

//AttendanceScreen
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  AttendanceScreenState createState() => AttendanceScreenState();
}

class AttendanceScreenState extends State<AttendanceScreen> {
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

  List<SessionLocal> sessions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => const SessionCreateNewScreen());
          await init();
          setState(() {
          });
          // submit_form();
        },
        backgroundColor: CustomTheme.primary,
        child: const Icon(FeatherIcons.plus),
      ),
      appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(FeatherIcons.refreshCcw),
              onPressed: () async {
                init();
              },
            )
          ],
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
                'Roll-calling',
                color: Colors.white,
                fontWeight: 700,
                height: .8,
              ),
              FxText.titleSmall(
                'Found ${participants.length} records',
                color: Colors.white,
              ),
            ],
          )),
      body: RefreshIndicator(
        onRefresh: () async {
          await init();
        },
        color: CustomTheme.primary,
        backgroundColor: Colors.white,
        child: Column(
          children: [
            sessions.isNotEmpty
                ? InkWell(
                    onTap: () async {
                      await Get.to(() => const SessionLocalScreen());
                      init();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 16,
                      ),
                      color: Colors.red,
                      width: double.infinity,
                      child: Row(
                        children: [
                          FxText.titleSmall(
                            'You have ${sessions.length} roll-calls pending for upload.',
                            color: Colors.white,
                          ),
                          const Spacer(),
                          const Icon(
                            FeatherIcons.chevronRight,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        Participant m = participants[index];
                        return FxContainer(
                          onTap: () {
                            _showBottomSheet(m);
                          },
                          color:
                              m.p() ? Colors.green.shade50 : Colors.red.shade50,
                          paddingAll: 0,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  roundedImage(m.avatar.toString(), 8, 8),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FxText.titleMedium(
                                          m.administrator_text,
                                          maxLines: 1,
                                          height: 1,
                                          color: Colors.grey.shade800,
                                          fontWeight: 800,
                                        ),
                                        FxText.bodySmall(m.getDisplayText()),
                                        Row(
                                          children: [
                                            FxCard(
                                                color: m.p()
                                                    ? Colors.green.shade700
                                                    : Colors.red.shade700,
                                                padding: const EdgeInsets.only(
                                                  top: 2,
                                                  bottom: 4,
                                                  left: 8,
                                                  right: 8,
                                                ),
                                                borderRadiusAll: 50,
                                                child: FxText.bodySmall(
                                                  m.p() ? 'Present' : 'Absent',
                                                  color: Colors.white,
                                                  fontWeight: 900,
                                                  height: 1,
                                                  fontSize: 10,
                                                )),
                                            const Spacer(),
                                            FxText.bodySmall(
                                                Utils.to_date(m.created_at)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        );
                      },
                      childCount: participants.length, // 1000 list items
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Participant> participants = [];

  Future<void> init() async {
    sessions = await SessionLocal.getItems();
    setState(() {});
    participants = await Participant.get_items();

    setState(() {});
  }

  void _showBottomSheet(Participant m) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 15,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            FeatherIcons.x,
                            color: Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: roundedImage(
                              m.avatar.toString(),
                              5,
                              5,
                              radius: 100,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          FxText.titleLarge(
                            m.academic_class_text,
                            fontWeight: 800,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 5,
                          ),
                          titleValueWidget('Date', Utils.to_date(m.created_at)),
                          const SizedBox(
                            height: 5,
                          ),
                          titleValueWidget('Roll Call', m.getDisplayText()),
                          const SizedBox(
                            height: 5,
                          ),
                          titleValueWidget(
                              'Status', m.p() ? 'Present' : 'Absent'),
                          const SizedBox(
                            height: 5,
                          ),
                          titleValueWidget('Details', m.session_text),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
