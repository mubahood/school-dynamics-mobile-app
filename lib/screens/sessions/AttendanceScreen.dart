import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/screens/sessions/SessionLocalScreen.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../models/LoggedInUserModel.dart';
import '../../models/RollCall/Participant.dart';
import '../../models/RespondModel.dart';
import '../../models/SessionLocal.dart';
import '../../design_system/design_system.dart';
import '../../sections/widgets.dart';
import 'SessionCreateNewScreen.dart';

//AttendanceScreen
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  AttendanceScreenState createState() => AttendanceScreenState();
}

class AttendanceScreenState extends State<AttendanceScreen> {
  LoggedInUserModel loggedInUser = LoggedInUserModel();
  List<SessionLocal> sessions = [];
  List<Participant> participants = [];

  // Summary data
  String termText = '';
  int summaryTotal = 0;
  int summaryPresent = 0;
  int summaryAbsent = 0;
  List<dynamic> summaryChildren = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    loggedInUser = await LoggedInUserModel.getLoggedInUser();
    sessions = await SessionLocal.getItems();
    setState(() {});

    // Load summary from API
    RespondModel summResp = RespondModel(
        await Utils.http_get('attendance-summary', {}));
    if (summResp.code == 1 && summResp.data != null) {
      final d = summResp.data;
      termText = d['term_text']?.toString() ?? '';
      summaryTotal = Utils.int_parse(d['total']);
      summaryPresent = Utils.int_parse(d['present']);
      summaryAbsent = Utils.int_parse(d['absent']);
      summaryChildren = (d['children'] is List) ? d['children'] : [];
    }

    participants = await Participant.get_items();
    setState(() {});
  }

  bool get _isParent =>
      loggedInUser.isRole('parent') || loggedInUser.user_type == 'parent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      floatingActionButton: _isParent
          ? null
          : FloatingActionButton(
              onPressed: () async {
                await Get.to(() => const SessionCreateNewScreen());
                await init();
                setState(() {});
              },
              backgroundColor: AppColors.primary,
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
          backgroundColor: AppColors.primary,
          titleSpacing: 0,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
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
        color: AppColors.primary,
        backgroundColor: Colors.white,
        child: Column(
          children: [
            // ── Pending uploads banner ─────────────────────────────────
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

            // ── Summary card ───────────────────────────────────────────
            if (summaryTotal > 0) _buildSummaryCard(),

            // ── Records list ───────────────────────────────────────────
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
                              const SizedBox(height: 10),
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  const SizedBox(width: 15),
                                  roundedImage(m.avatar.toString(), 8, 8),
                                  const SizedBox(width: 10),
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
                                                borderRadiusAll: 0,
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
                                  const SizedBox(width: 10),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                      childCount: participants.length,
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

  Widget _buildSummaryCard() {
    final double presentPct =
        summaryTotal > 0 ? summaryPresent / summaryTotal : 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(12),
        border: Border.all(color: AppColors.primary.withAlpha(60)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Term label + attendance rate
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: FxText.titleSmall(
                    termText.isNotEmpty ? termText : 'Active Term',
                    fontWeight: 700,
                    color: AppColors.primary,
                  ),
                ),
                FxText.bodySmall(
                  '${(presentPct * 100).toStringAsFixed(0)}% attendance',
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: presentPct,
                minHeight: 6,
                backgroundColor: Colors.red.shade100,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.green.shade600),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Total / Present / Absent counters
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: Row(
              children: [
                _statChip('Total', summaryTotal, Colors.grey.shade700),
                const SizedBox(width: 8),
                _statChip('Present', summaryPresent, Colors.green.shade700),
                const SizedBox(width: 8),
                _statChip('Absent', summaryAbsent, Colors.red.shade700),
              ],
            ),
          ),
          // Per-child breakdown (parents only)
          if (_isParent && summaryChildren.isNotEmpty) ...[
            Divider(
                height: 1,
                color: AppColors.primary.withAlpha(40)),
            ...summaryChildren.map((child) {
              final int ct = Utils.int_parse(child['total']);
              final int cp = Utils.int_parse(child['present']);
              final double cpct = ct > 0 ? cp / ct : 0;
              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    roundedImage(child['avatar']?.toString() ?? '', 10, 10),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.titleSmall(
                            child['name']?.toString() ?? '',
                            fontWeight: 700,
                            maxLines: 1,
                            color: Colors.grey.shade800,
                          ),
                          const SizedBox(height: 3),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: cpct,
                              minHeight: 4,
                              backgroundColor: Colors.red.shade100,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.green.shade600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    FxText.bodySmall(
                      '$cp/$ct',
                      fontWeight: 700,
                      color: Colors.grey.shade700,
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _statChip(String label, int value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            FxText.titleMedium(
              '$value',
              fontWeight: 800,
              color: color,
            ),
            FxText.bodySmall(
              label,
              color: color,
              fontSize: 10,
            ),
          ],
        ),
      ),
    );
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
                      topLeft: Radius.zero,
                      topRight: Radius.zero)),
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
                          const SizedBox(height: 5),
                          FxText.titleLarge(
                            m.academic_class_text,
                            fontWeight: 800,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 5),
                          const Divider(),
                          const SizedBox(height: 5),
                          titleValueWidget('Date', Utils.to_date(m.created_at)),
                          const SizedBox(height: 5),
                          titleValueWidget('Roll Call', m.getDisplayText()),
                          const SizedBox(height: 5),
                          titleValueWidget(
                              'Status', m.p() ? 'Present' : 'Absent'),
                          const SizedBox(height: 5),
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
