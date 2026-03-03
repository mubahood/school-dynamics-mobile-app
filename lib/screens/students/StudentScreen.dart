import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:schooldynamics/models/UserModel.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../design_system/design_system.dart';
import '../../models/DisciplinaryRecordModel.dart';
import '../../models/RespondModel.dart';
import '../../models/RollCall/Participant.dart';
import '../../models/StudentReportCard.dart';
import '../../models/Transaction.dart';
import '../../sections/widgets.dart';
import '../../utils/my_widgets.dart';
import 'PdfViewer.dart';
import 'StudentEditBioScreen.dart';
import 'StudentEditGuardianScreen.dart';
import 'StudentEditPhotoScreen.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key, required this.data});
  final dynamic data;

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  UserModel item = UserModel();
  LoggedInUserModel loggedInUser = LoggedInUserModel();
  bool showEditActions = false;
  bool dataLoading = true;

  List<Participant> participants = [];
  List<StudentReportCard> cards = [];
  List<DisciplinaryRecordModel> disciplinaryRecords = [];
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    item = widget.data;
    loggedInUser = await LoggedInUserModel.getLoggedInUser();
    showEditActions = loggedInUser.user_type == 'employee';
    setState(() {});
    await _loadTabData();
  }

  Future<void> _loadTabData() async {
    setState(() => dataLoading = true);
    cards = await StudentReportCard.get_items(
        where: " student_id = '${item.id}'");
    disciplinaryRecords = await DisciplinaryRecordModel.get_items(
        where: " administrator_id = '${item.id}'");
    participants = await Participant.get_items(
        where: " administrator_id = '${item.id}'");
    RespondModel txResp = RespondModel(
        await Utils.http_get('student-transactions', {'student_id': item.id}));
    if (txResp.code == 1 && txResp.data != null) {
      transactions = [];
      for (var x in txResp.data) {
        transactions.add(Transaction.fromJson(x));
      }
      transactions.sort((a, b) => b.id.compareTo(a.id));
    }
    setState(() => dataLoading = false);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 18, 0, 6),
        child: Row(
          children: [
            Container(
              width: 3,
              height: 14,
              color: AppColors.primary,
              margin: const EdgeInsets.only(right: 8),
            ),
            Text(
              title.toUpperCase(),
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      );

  Widget _infoRow(String label, String value, {IconData? icon}) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 6),
          ],
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Profile header ────────────────────────────────────────────────────────

  Widget _profileHeader() {
    final bool isActive = item.status == '1';
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Photo
          GestureDetector(
            onTap: showEditActions
                ? () async {
                    await Get.to(
                        () => StudentEditPhotoScreen(data: item));
                    _init();
                  }
                : null,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5), width: 2),
              ),
              child: roundedImage(item.avatar.toString(), 5, 5, radius: 0),
            ),
          ),
          const SizedBox(width: 16),
          // Name + class + status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                if (item.current_class_text.isNotEmpty)
                  Text(
                    item.current_class_text,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green.shade400
                            : Colors.orange.shade400,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        isActive ? 'Active' : 'Pending',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (item.sex.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          item.sex,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── BIO tab ───────────────────────────────────────────────────────────────

  Widget _bioTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      children: [
        _sectionHeader('Bio Data'),
        _infoRow('Full name', item.name, icon: FeatherIcons.user),
        _infoRow('Sex', item.sex, icon: FeatherIcons.users),
        _infoRow('Date of birth', Utils.to_date_1(item.date_of_birth),
            icon: FeatherIcons.calendar),
        _infoRow('Home address', item.home_address,
            icon: FeatherIcons.mapPin),

        _sectionHeader('Academics'),
        _infoRow('Student ID', item.user_id, icon: FeatherIcons.hash),
        _infoRow('Current class', item.current_class_text,
            icon: FeatherIcons.bookOpen),
        _infoRow('School Pay Code', item.school_pay_payment_code,
            icon: FeatherIcons.creditCard),
        _infoRow('Registered', Utils.to_date_1(item.created_at),
            icon: FeatherIcons.clock),

        _sectionHeader('Guardian'),
        _infoRow("Father's name", item.father_name,
            icon: FeatherIcons.user),
        _infoRow("Mother's name", item.mother_name,
            icon: FeatherIcons.user),
        _infoRow('Contact', item.phone_number_1,
            icon: FeatherIcons.phone),
        _infoRow('Contact 2', item.phone_number_2,
            icon: FeatherIcons.phone),
        _infoRow('Email', item.email, icon: FeatherIcons.mail),
      ],
    );
  }

  // ── Attendance tab ────────────────────────────────────────────────────────

  Widget _attendanceTab() {
    if (dataLoading) return myListLoaderWidget(context);
    if (participants.isEmpty) {
      return _emptyTab('No attendance records', FeatherIcons.checkSquare);
    }
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: _loadTabData,
      child: ListView.builder(
        itemCount: participants.length,
        itemBuilder: (_, i) {
          final Participant p = participants[i];
          final bool present = p.p();
          return _recordTile(
            title: p.getDisplayText(),
            date: Utils.to_date(p.created_at),
            badge: present ? 'Present' : 'Absent',
            badgeColor: present ? AppColors.success : AppColors.error,
            badgeBg: present ? AppColors.successLight : AppColors.errorLight,
            onTap: () => _attendanceSheet(p),
          );
        },
      ),
    );
  }

  // ── Discipline tab ────────────────────────────────────────────────────────

  Widget _disciplineTab() {
    if (dataLoading) return myListLoaderWidget(context);
    if (disciplinaryRecords.isEmpty) {
      return _emptyTab('No disciplinary records', FeatherIcons.shield);
    }
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: _loadTabData,
      child: ListView.builder(
        itemCount: disciplinaryRecords.length,
        itemBuilder: (_, i) {
          final DisciplinaryRecordModel d = disciplinaryRecords[i];
          final bool good = d.p();
          return _recordTile(
            title: d.getDisplayText(),
            date: Utils.to_date(d.created_at),
            badge: good ? 'Good Record' : 'Indiscipline',
            badgeColor: good ? AppColors.success : AppColors.error,
            badgeBg: good ? AppColors.successLight : AppColors.errorLight,
            onTap: () => _disciplineSheet(d),
          );
        },
      ),
    );
  }

  // ── Report cards tab ──────────────────────────────────────────────────────

  Widget _reportCardsTab() {
    if (dataLoading) return myListLoaderWidget(context);
    if (cards.isEmpty) {
      return _emptyTab('No report cards', FeatherIcons.fileText);
    }
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: _loadTabData,
      child: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (_, i) {
          final StudentReportCard rc = cards[i];
          return _recordTile(
            title: rc.student_text,
            subtitle: rc.academic_class_text,
            date: Utils.to_date(rc.created_at),
            badge: rc.grade,
            badgeColor: AppColors.onPrimary,
            badgeBg: AppColors.primary,
            onTap: () =>
                Get.to(() => PdfViewerScreen(rc.getPdf(), 'Report Card')),
          );
        },
      ),
    );
  }

  // ── Finance tab ───────────────────────────────────────────────────────────

  Widget _financeTab() {
    if (dataLoading) return myListLoaderWidget(context);
    final bool inDebt = item.balance < 0;
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: _loadTabData,
      child: ListView(
        children: [
          // Balance card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: inDebt ? AppColors.errorLight : AppColors.successLight,
              border: Border.all(
                color: inDebt ? AppColors.error : AppColors.success,
                width: 0.8,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'FEES BALANCE',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'UGX ${Utils.moneyFormat("${item.balance}")}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: inDebt ? Colors.red.shade800 : Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  color:
                      inDebt ? Colors.red.shade700 : Colors.green.shade700,
                  child: Text(
                    item.verification == '1'
                        ? 'Verified Balance'
                        : 'Not Verified',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Transactions list
          if (transactions.isEmpty)
            _emptyTab('No transactions yet', FeatherIcons.creditCard)
          else ...[
            _sectionHeader('Transactions'),
            ...transactions.map(_transactionTile),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _transactionTile(Transaction t) {
    final bool isCharge = t.amount_figure < 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: AppColors.border, width: 0.8)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            color: isCharge ? AppColors.errorLight : AppColors.successLight,
            child: Icon(
              isCharge ? FeatherIcons.arrowUp : FeatherIcons.arrowDown,
              size: 16,
              color: isCharge ? AppColors.error : AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.description.isNotEmpty ? t.description : t.type,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  Utils.to_date(t.created_at),
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'UGX ${Utils.moneyFormat(t.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: isCharge ? Colors.red.shade700 : Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared list tile ──────────────────────────────────────────────────────

  Widget _recordTile({
    required String title,
    String? subtitle,
    required String date,
    required String badge,
    required Color badgeColor,
    required Color badgeBg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColors.border, width: 0.8)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary)),
                  ],
                  const SizedBox(height: 3),
                  Text(
                    date,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                badge,
                style: AppTypography.bodySmall.copyWith(
                  color: badgeColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _emptyTab(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 48,
              color: AppColors.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(message,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  // ── Bottom sheets ─────────────────────────────────────────────────────────

  void _attendanceSheet(Participant p) {
    _infoSheet([
      _sheetRow('Date', Utils.to_date(p.created_at)),
      _sheetRow('Roll call', p.getDisplayText()),
      _sheetRow('Status', p.p() ? 'Present' : 'Absent'),
      _sheetRow('Session', p.session_text),
    ]);
  }

  void _disciplineSheet(DisciplinaryRecordModel d) {
    _infoSheet([
      _sheetRow('Date', Utils.to_date(d.created_at)),
      _sheetRow('Title', d.getDisplayText()),
      _sheetRow('Category', d.p() ? 'Good Record' : 'Indiscipline'),
      _sheetRow('Details', d.description),
      if (d.hm_comment.isNotEmpty)
        _sheetRow("Head Teacher's Comment", d.hm_comment),
      if (d.teacher_comment.isNotEmpty)
        _sheetRow("Class Teacher's Comment", d.teacher_comment),
      if (d.student_comment.isNotEmpty)
        _sheetRow("Student's Comment", d.student_comment),
      if (d.parent_comment.isNotEmpty)
        _sheetRow("Parent's Comment", d.parent_comment),
    ]);
  }

  Widget _sheetRow(String label, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _infoSheet(List<Widget> rows) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                  children: rows,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          titleSpacing: 0,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            item.name.isEmpty ? 'Student' : item.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: showEditActions
              ? [
                  PopupMenuButton<int>(
                    icon: const Icon(FeatherIcons.moreVertical,
                        color: Colors.white),
                    onSelected: (v) async {
                      if (v == 1) {
                        await Get.to(
                            () => StudentEditBioScreen(data: item));
                        _init();
                      } else if (v == 2) {
                        await Get.to(
                            () => StudentEditPhotoScreen(data: item));
                        _init();
                      } else if (v == 3) {
                        await Get.to(
                            () => StudentEditGuardianScreen(data: item));
                        _init();
                      }
                    },
                    itemBuilder: (_) => [
                      _menuItem(1, FeatherIcons.edit2, 'Edit bio data'),
                      _menuItem(2, FeatherIcons.camera, 'Update photo'),
                      _menuItem(3, FeatherIcons.users, 'Edit guardian'),
                    ],
                  ),
                ]
              : null,
        ),
        body: Column(
          children: [
            _profileHeader(),
            // ── Tab bar sits directly below the profile card ────────────
            Container(
              color: AppColors.surface,
              child: TabBar(
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                isScrollable: true,
                labelStyle: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w400),
                tabs: const [
                  Tab(text: 'Bio'),
                  Tab(text: 'Attendance'),
                  Tab(text: 'Discipline'),
                  Tab(text: 'Report Cards'),
                  Tab(text: 'Finance'),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: TabBarView(
                children: [
                  _bioTab(),
                  _attendanceTab(),
                  _disciplineTab(),
                  _reportCardsTab(),
                  _financeTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<int> _menuItem(int value, IconData icon, String label) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Text(label, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
