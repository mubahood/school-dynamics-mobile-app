import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/RespondModel.dart';
import 'package:schooldynamics/models/StudentReportCard.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../design_system/colors/app_colors.dart';
import '../../design_system/typography/app_typography.dart';
import 'PdfViewer.dart';

// ─── Models ──────────────────────────────────────────────────────────────────

class _SubjectMark {
  final String subjectName;
  final String botMark;
  final String motMark;
  final String eotMark;
  final String total;
  final String grade;
  final String remarks;
  final String initials;
  final bool didBot;
  final bool didMot;
  final bool didEot;

  const _SubjectMark({
    required this.subjectName,
    required this.botMark,
    required this.motMark,
    required this.eotMark,
    required this.total,
    required this.grade,
    required this.remarks,
    required this.initials,
    required this.didBot,
    required this.didMot,
    required this.didEot,
  });

  factory _SubjectMark.fromJson(Map<String, dynamic> m) {
    return _SubjectMark(
      subjectName: Utils.to_str(m['subject_name'], ''),
      botMark: Utils.to_str(m['bot_mark'], ''),
      motMark: Utils.to_str(m['mot_mark'], ''),
      eotMark: Utils.to_str(m['eot_mark'], ''),
      total: Utils.to_str(m['total'], ''),
      grade: Utils.to_str(m['grade_name'], ''),
      remarks: Utils.to_str(m['remarks'], ''),
      initials: Utils.to_str(m['initials'], ''),
      didBot: Utils.to_str(m['did_bot'], '') == '1' ||
          Utils.to_str(m['did_bot'], '') == 'Yes',
      didMot: Utils.to_str(m['did_mot'], '') == '1' ||
          Utils.to_str(m['did_mot'], '') == 'Yes',
      didEot: Utils.to_str(m['did_eot'], '') == '1' ||
          Utils.to_str(m['did_eot'], '') == 'Yes',
    );
  }
}

class _TheologyCard {
  final String grade;
  final String position;
  final String totalStudents;
  final String totalMarks;
  final String totalAggregates;
  final String classTeacherComment;
  final String headTeacherComment;

  const _TheologyCard({
    required this.grade,
    required this.position,
    required this.totalStudents,
    required this.totalMarks,
    required this.totalAggregates,
    required this.classTeacherComment,
    required this.headTeacherComment,
  });

  factory _TheologyCard.fromJson(Map<String, dynamic> m) => _TheologyCard(
        grade: Utils.to_str(m['grade'], ''),
        position: Utils.to_str(m['position'], ''),
        totalStudents: Utils.to_str(m['total_students'], ''),
        totalMarks: Utils.to_str(m['total_marks'], ''),
        totalAggregates: Utils.to_str(m['total_aggregates'], ''),
        classTeacherComment: Utils.to_str(m['class_teacher_comment'], ''),
        headTeacherComment: Utils.to_str(m['head_teacher_comment'], ''),
      );
}

// ─── Screen ──────────────────────────────────────────────────────────────────

class ReportCardDetailScreen extends StatefulWidget {
  final StudentReportCard card;
  const ReportCardDetailScreen({super.key, required this.card});

  @override
  State<ReportCardDetailScreen> createState() => _ReportCardDetailScreenState();
}

class _ReportCardDetailScreenState extends State<ReportCardDetailScreen> {
  bool _loading = true;
  bool _generatingPdf = false;
  String _error = '';

  StudentReportCard _card = StudentReportCard();
  List<_SubjectMark> _secularItems = [];
  List<_SubjectMark> _theologyItems = [];
  _TheologyCard? _theologyCard;

  @override
  void initState() {
    super.initState();
    _card = widget.card;
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    final raw = await Utils.http_get('student-report-card-detail/${_card.id}', {});
    final resp = RespondModel(raw);

    if (resp.code == 1 && resp.data != null) {
      final data = resp.data as Map<String, dynamic>;

      final updated = StudentReportCard.fromJson(data);
      updated.pdf_url = Utils.to_str(data['pdf_url'], '');

      List<_SubjectMark> secular = [];
      if (data['items'] is List) {
        for (final i in data['items'] as List) {
          secular.add(_SubjectMark.fromJson(i as Map<String, dynamic>));
        }
      }

      List<_SubjectMark> theology = [];
      if (data['theology_items'] is List) {
        for (final i in data['theology_items'] as List) {
          theology.add(_SubjectMark.fromJson(i as Map<String, dynamic>));
        }
      }

      _TheologyCard? theoCard;
      if (data['theology_card'] is Map) {
        theoCard = _TheologyCard.fromJson(
            data['theology_card'] as Map<String, dynamic>);
      }

      if (mounted) {
        setState(() {
          _card = updated;
          _secularItems = secular;
          _theologyItems = theology;
          _theologyCard = theoCard;
          _loading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _error = resp.message.isNotEmpty ? resp.message : 'Failed to load data.';
          _loading = false;
        });
      }
    }
  }

  Future<void> _generatePdf() async {
    setState(() => _generatingPdf = true);
    Utils.toast('Generating PDF, please wait…');

    final raw = await Utils.http_post('make-pdf/${_card.id}', {});
    final resp = RespondModel(raw);

    if (resp.code == 1 && resp.data != null) {
      final fullUrl = Utils.to_str(resp.data['full_url'], '');
      final pdfUrl = Utils.to_str(resp.data['pdf_url'], '');
      setState(() {
        _card.pdf_url = pdfUrl;
        _generatingPdf = false;
      });
      if (fullUrl.isNotEmpty && mounted) {
        Get.to(() => PdfViewerScreen(fullUrl, 'Report Card'));
      }
    } else {
      setState(() => _generatingPdf = false);
      Utils.toast(resp.message.isNotEmpty
          ? resp.message
          : 'PDF generation failed. Please try again.');
    }
  }

  void _openPdf() {
    if (!_card.hasPdf) return;
    Get.to(() => PdfViewerScreen(_card.getPdf(), 'Report Card'));
  }

  // ── Grade / mark helpers ─────────────────────────────────────────────────

  Color _gradeColor(String g) {
    switch (g.toUpperCase()) {
      case 'D1': case '1': return const Color(0xFF1B8A3C);
      case 'D2': case '2': return const Color(0xFF43A047);
      case 'C3': case '3': return const Color(0xFF7CB342);
      case 'C4': case '4': return const Color(0xFFF9A825);
      case 'C5': case '5': return const Color(0xFFFB8C00);
      case 'C6': case '6': return const Color(0xFFE64A19);
      case 'D7': case '7': return const Color(0xFFC62828);
      case 'D8': case '8': return const Color(0xFF880E4F);
      case 'U': return const Color(0xFF757575);
      default:   return AppColors.textSecondary;
    }
  }

  Color _markBandColor(String markStr) {
    final v = double.tryParse(markStr) ?? 0;
    if (v >= 75) return const Color(0xFF1B8A3C);
    if (v >= 60) return const Color(0xFF43A047);
    if (v >= 45) return const Color(0xFFF9A825);
    if (v >= 30) return const Color(0xFFFB8C00);
    return const Color(0xFFC62828);
  }

  // Determine which assessment columns are active across all rows
  bool _hasBot(List<_SubjectMark> items) => items.any((i) => i.didBot);
  bool _hasMot(List<_SubjectMark> items) => items.any((i) => i.didMot);
  bool _hasEot(List<_SubjectMark> items) => items.any((i) => i.didEot);

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Report Card',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          if (!_loading)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _fetchDetail,
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? _buildError()
              : RefreshIndicator(
                  onRefresh: _fetchDetail,
                  color: AppColors.primary,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildHero(),
                      const SizedBox(height: 12),
                      if (_secularItems.isNotEmpty)
                        _buildMarksSection(
                          title: 'SECULAR REPORT',
                          icon: FeatherIcons.bookOpen,
                          accentColor: AppColors.primary,
                          items: _secularItems,
                          summaryGrade: _card.grade,
                          summaryPosition: _card.position,
                          summaryTotal: _card.total_students,
                          summaryMarks: _card.total_marks,
                          summaryAgg: _card.total_aggregates,
                        ),
                      if (_theologyItems.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildMarksSection(
                          title: 'THEOLOGY REPORT',
                          icon: FeatherIcons.book,
                          accentColor: const Color(0xFF7B5EA7),
                          items: _theologyItems,
                          summaryGrade: _theologyCard?.grade ?? '',
                          summaryPosition: _theologyCard?.position ?? '',
                          summaryTotal: _theologyCard?.totalStudents ?? '',
                          summaryMarks: _theologyCard?.totalMarks ?? '',
                          summaryAgg: _theologyCard?.totalAggregates ?? '',
                        ),
                      ],
                      if (_secularItems.isEmpty && _theologyItems.isEmpty)
                        _buildNoMarks(),
                      const SizedBox(height: 12),
                      _buildComments(),
                      const SizedBox(height: 12),
                      _buildPdfActions(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  // ── Hero header ───────────────────────────────────────────────────────────

  Widget _buildHero() {
    return Container(
      color: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student avatar placeholder
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.5),
                  ),
                  child: const Icon(FeatherIcons.user, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _card.student_text.isNotEmpty ? _card.student_text : 'Student',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (_card.academic_class_text.isNotEmpty)
                        Text(
                          _card.academic_class_text,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (_card.term_text.isNotEmpty)
                            _chip(FeatherIcons.calendar, _card.term_text),
                          if (_card.academic_year_text.isNotEmpty)
                            _chip(FeatherIcons.award, _card.academic_year_text),
                          if (_card.is_ready == '1')
                            _chip(FeatherIcons.checkCircle, 'Published',
                                color: Colors.greenAccent.shade100),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label, {Color? color}) {
    final c = color ?? Colors.white.withValues(alpha: 0.9);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: c),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ── Full marks section (summary + table) ──────────────────────────────────

  Widget _buildMarksSection({
    required String title,
    required IconData icon,
    required Color accentColor,
    required List<_SubjectMark> items,
    required String summaryGrade,
    required String summaryPosition,
    required String summaryTotal,
    required String summaryMarks,
    required String summaryAgg,
  }) {
    final hasBot = _hasBot(items);
    final hasMot = _hasMot(items);
    final hasEot = _hasEot(items);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              border: Border(
                bottom: BorderSide(color: accentColor.withValues(alpha: 0.15)),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 14, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),

          // Summary strip
          _buildSummaryStrip(
            accentColor: accentColor,
            grade: summaryGrade,
            position: summaryPosition,
            total: summaryTotal,
            marks: summaryMarks,
            agg: summaryAgg,
          ),

          const Divider(height: 1, color: AppColors.border),

          // Column headers
          _buildTableHeader(hasBot: hasBot, hasMot: hasMot, hasEot: hasEot, accent: accentColor),

          const Divider(height: 1, color: AppColors.border),

          // Subject rows
          ...List.generate(items.length, (i) {
            final item = items[i];
            return Column(
              children: [
                _buildSubjectRow(item, hasBot: hasBot, hasMot: hasMot, hasEot: hasEot),
                if (i < items.length - 1)
                  const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.border),
              ],
            );
          }),

          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildSummaryStrip({
    required Color accentColor,
    required String grade,
    required String position,
    required String total,
    required String marks,
    required String agg,
  }) {
    final pos = position.isNotEmpty ? position : '—';
    final tot = total.isNotEmpty ? total : '—';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          _summaryCell(
            label: 'GRADE',
            value: grade.isNotEmpty ? grade : '—',
            valueColor: grade.isNotEmpty ? _gradeColor(grade) : AppColors.textSecondary,
            large: true,
          ),
          _vLine(),
          _summaryCell(
            label: 'POSITION',
            value: '$pos / $tot',
          ),
          _vLine(),
          _summaryCell(
            label: 'MARKS',
            value: marks.isNotEmpty ? marks : '—',
          ),
          _vLine(),
          _summaryCell(
            label: 'AGGREGATES',
            value: agg.isNotEmpty ? agg : '—',
          ),
        ],
      ),
    );
  }

  Widget _summaryCell({
    required String label,
    required String value,
    Color? valueColor,
    bool large = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: large ? 22 : 16,
              fontWeight: FontWeight.w800,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _vLine() => Container(width: 1, height: 36, color: AppColors.border);

  // ── Table header ──────────────────────────────────────────────────────────

  Widget _buildTableHeader({
    required bool hasBot,
    required bool hasMot,
    required bool hasEot,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      color: accent.withValues(alpha: 0.04),
      child: Row(
        children: [
          const Expanded(
            flex: 4,
            child: Text('SUBJECT',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.3)),
          ),
          if (hasBot) _thCell('BOT'),
          if (hasMot) _thCell('MOT'),
          if (hasEot) _thCell('EOT'),
          _thCell('TOTAL'),
          _thCell('GRD', width: 42),
        ],
      ),
    );
  }

  Widget _thCell(String label, {double width = 36}) => SizedBox(
        width: width,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.3),
        ),
      );

  // ── Subject row ───────────────────────────────────────────────────────────

  Widget _buildSubjectRow(
    _SubjectMark item, {
    required bool hasBot,
    required bool hasMot,
    required bool hasEot,
  }) {
    final totalVal = double.tryParse(item.total) ?? 0;
    final hasTotal = totalVal > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Subject name + remarks
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.subjectName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.remarks.isNotEmpty && item.remarks != '-')
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.remarks,
                      style: TextStyle(
                        fontSize: 9.5,
                        color: hasTotal
                            ? _markBandColor(item.total).withValues(alpha: 0.9)
                            : AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // BOT
          if (hasBot) _markCell(item.botMark, item.didBot),
          // MOT
          if (hasMot) _markCell(item.motMark, item.didMot),
          // EOT
          if (hasEot) _markCell(item.eotMark, item.didEot),
          // Total — always shown
          SizedBox(
            width: 36,
            child: Text(
              hasTotal ? item.total : '—',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: hasTotal ? _markBandColor(item.total) : Colors.grey.shade400,
              ),
            ),
          ),
          // Grade badge
          SizedBox(
            width: 42,
            child: item.grade.isNotEmpty && item.grade != 'X' && item.grade != '-'
                ? _gradeBadge(item.grade)
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _markCell(String mark, bool submitted) {
    final val = double.tryParse(mark) ?? 0;
    final hasValue = submitted && mark.isNotEmpty && val > 0;
    return SizedBox(
      width: 36,
      child: Text(
        hasValue ? mark : '—',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
          color: hasValue ? _markBandColor(mark) : Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _gradeBadge(String grade) {
    final color = _gradeColor(grade);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        grade,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color),
      ),
    );
  }

  // ── No marks placeholder ──────────────────────────────────────────────────

  Widget _buildNoMarks() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
      ),
      child: Column(
        children: [
          Icon(FeatherIcons.fileText, size: 40, color: AppColors.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            'Subject marks are not yet available.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'They will appear here once the report card has been generated.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textDisabled),
          ),
        ],
      ),
    );
  }

  // ── Comments ──────────────────────────────────────────────────────────────

  Widget _buildComments() {
    final comments = <_CommentData>[];
    if (_card.class_teacher_comment.isNotEmpty) {
      comments.add(_CommentData('Class Teacher', _card.class_teacher_comment, FeatherIcons.user));
    }
    if (_card.head_teacher_comment.isNotEmpty) {
      comments.add(_CommentData('Head Teacher', _card.head_teacher_comment, FeatherIcons.briefcase));
    }
    if (_card.sports_comment.isNotEmpty) {
      comments.add(_CommentData('Sports', _card.sports_comment, FeatherIcons.activity));
    }
    if (_card.mentor_comment.isNotEmpty) {
      comments.add(_CommentData('Mentor', _card.mentor_comment, FeatherIcons.heart));
    }
    if (_card.nurse_comment.isNotEmpty) {
      comments.add(_CommentData('Nurse', _card.nurse_comment, FeatherIcons.plus));
    }

    // Theology comments
    if (_theologyCard != null && _theologyCard!.classTeacherComment.isNotEmpty) {
      comments.add(_CommentData('Theology Class Teacher', _theologyCard!.classTeacherComment, FeatherIcons.book));
    }
    if (_theologyCard != null && _theologyCard!.headTeacherComment.isNotEmpty) {
      comments.add(_CommentData('Theology Head Teacher', _theologyCard!.headTeacherComment, FeatherIcons.briefcase));
    }

    if (comments.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              border: const Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Icon(FeatherIcons.messageSquare, size: 14, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('COMMENTS',
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 0.8)),
              ],
            ),
          ),
          ...comments.map((c) => _buildCommentTile(c)),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildCommentTile(_CommentData c) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(c.icon, size: 14, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.role,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.4)),
                const SizedBox(height: 3),
                Text(c.text,
                    style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── PDF actions ───────────────────────────────────────────────────────────

  Widget _buildPdfActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_card.hasPdf) ...[
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 2,
              ),
              onPressed: _openPdf,
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white, size: 20),
              label: const Text('Open Report Card PDF',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 10),
          ],
          _generatingPdf
              ? Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
                      const SizedBox(width: 12),
                      const Text('Generating PDF…',
                          style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                    ],
                  ),
                )
              : OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: _card.hasPdf ? Colors.orange.shade700 : AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _generatePdf,
                  icon: Icon(
                    _card.hasPdf ? Icons.refresh : Icons.picture_as_pdf_outlined,
                    color: _card.hasPdf ? Colors.orange.shade700 : AppColors.primary,
                    size: 18,
                  ),
                  label: Text(
                    _card.hasPdf ? 'Regenerate PDF' : 'Generate PDF',
                    style: TextStyle(
                      color: _card.hasPdf ? Colors.orange.shade700 : AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FeatherIcons.alertCircle, size: 48, color: AppColors.error.withValues(alpha: 0.7)),
            const SizedBox(height: 16),
            Text(_error, textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              onPressed: _fetchDetail,
              icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
              label: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentData {
  final String role;
  final String text;
  final IconData icon;
  const _CommentData(this.role, this.text, this.icon);
}
