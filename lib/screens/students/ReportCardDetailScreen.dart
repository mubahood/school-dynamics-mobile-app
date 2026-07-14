import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/RespondModel.dart';
import 'package:schooldynamics/models/StudentReportCard.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../design_system/colors/app_colors.dart';
import '../../design_system/typography/app_typography.dart';
import 'PdfViewer.dart';

// ─── Lightweight model for a single subject row ───────────────────────────────
class _SubjectMark {
  final String subjectName;
  final String botMark;
  final String motMark;
  final String eotMark;
  final String total;
  final String grade;
  final String remarks;
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
      didBot: Utils.to_str(m['did_bot'], '') == '1' ||
          Utils.to_str(m['did_bot'], '') == 'Yes',
      didMot: Utils.to_str(m['did_mot'], '') == '1' ||
          Utils.to_str(m['did_mot'], '') == 'Yes',
      didEot: Utils.to_str(m['did_eot'], '') == '1' ||
          Utils.to_str(m['did_eot'], '') == 'Yes',
    );
  }
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

  // Detail data populated from API
  StudentReportCard _card = StudentReportCard();
  List<_SubjectMark> _items = [];

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

    final raw = await Utils.http_get(
        'student-report-card-detail/${_card.id}', {});
    final resp = RespondModel(raw);

    if (resp.code == 1 && resp.data != null) {
      final data = resp.data as Map<String, dynamic>;

      // Re-parse the card fields from detail response
      final updated = StudentReportCard.fromJson(data);
      updated.pdf_url = Utils.to_str(data['pdf_url'], '');

      // Parse subject items
      final rawItems = data['items'];
      final parsedItems = <_SubjectMark>[];
      if (rawItems is List) {
        for (final item in rawItems) {
          parsedItems.add(_SubjectMark.fromJson(item as Map<String, dynamic>));
        }
      }

      if (mounted) {
        setState(() {
          _card = updated;
          _items = parsedItems;
          _loading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _error =
              resp.message.isNotEmpty ? resp.message : 'Failed to load data.';
          _loading = false;
        });
      }
    }
  }

  Future<void> _generatePdf() async {
    setState(() => _generatingPdf = true);
    Utils.toast('Generating PDF, please wait…');

    final raw =
        await Utils.http_post('make-pdf/${_card.id}', {});
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

  // ── Grade helpers ────────────────────────────────────────────────────────

  Color _gradeColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'D1':
      case '1':
        return Colors.green.shade700;
      case 'D2':
      case '2':
        return Colors.lightGreen.shade600;
      case 'D3':
      case '3':
        return Colors.amber.shade700;
      case 'D4':
      case '4':
        return Colors.orange.shade700;
      case 'U':
        return Colors.red.shade700;
      default:
        return Colors.blueGrey.shade600;
    }
  }

  Color _markColor(String markStr) {
    final val = double.tryParse(markStr) ?? 0;
    if (val >= 70) return Colors.green.shade700;
    if (val >= 50) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Report Card',
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
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
                    padding: const EdgeInsets.all(0),
                    children: [
                      _buildHeader(),
                      _buildSummaryRow(),
                      if (_items.isNotEmpty) _buildSubjectMarks(),
                      _buildComments(),
                      _buildPdfActions(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FeatherIcons.alertCircle,
                size: 48, color: AppColors.error.withValues(alpha: 0.7)),
            const SizedBox(height: 16),
            Text(_error,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: _fetchDetail,
              icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
              label: const Text('Retry',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header card ───────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student name
          Text(
            _card.student_text.isNotEmpty ? _card.student_text : 'Student',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          // Class + stream
          if (_card.academic_class_text.isNotEmpty)
            Text(
              _card.academic_class_text,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          const SizedBox(height: 10),
          // Term / year chips
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (_card.term_text.isNotEmpty)
                _headerChip(FeatherIcons.calendar, _card.term_text),
              if (_card.academic_year_text.isNotEmpty)
                _headerChip(FeatherIcons.award, _card.academic_year_text),
              if (_card.is_ready == '1')
                _headerChip(FeatherIcons.checkCircle, 'Published',
                    color: Colors.green.shade300),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerChip(IconData icon, String label, {Color? color}) {
    final c = color ?? Colors.white.withValues(alpha: 0.85);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: c),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  color: c, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ── Summary stats ─────────────────────────────────────────────────────────

  Widget _buildSummaryRow() {
    final grade = _card.grade;
    final pos = _card.position.isNotEmpty ? _card.position : '—';
    final total = _card.total_students.isNotEmpty ? _card.total_students : '—';
    final marks = _card.total_marks.isNotEmpty ? _card.total_marks : '—';
    final agg = _card.total_aggregates.isNotEmpty
        ? _card.total_aggregates
        : '—';

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          _summaryCell(
            label: 'GRADE',
            value: grade.isNotEmpty ? grade : '—',
            valueColor: grade.isNotEmpty ? _gradeColor(grade) : AppColors.textSecondary,
            large: true,
          ),
          _divider(),
          _summaryCell(
            label: 'POSITION',
            value: '$pos / $total',
          ),
          _divider(),
          _summaryCell(
            label: 'TOTAL MARKS',
            value: marks,
          ),
          _divider(),
          _summaryCell(
            label: 'AGGREGATES',
            value: agg,
          ),
        ],
      ),
    );
  }

  Widget _summaryCell(
      {required String label,
      required String value,
      Color? valueColor,
      bool large = false}) {
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
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 40,
        color: AppColors.border,
      );

  // ── Subject marks table ───────────────────────────────────────────────────

  Widget _buildSubjectMarks() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('SUBJECT RESULTS', FeatherIcons.bookOpen),
          // Table header
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.primary.withValues(alpha: 0.07),
            child: Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: Text('Subject',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary)),
                ),
                ...[
                  _colHead('BOT'),
                  _colHead('MOT'),
                  _colHead('EOT'),
                  _colHead('Total'),
                  _colHead('Grade'),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          // Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.border),
            itemBuilder: (_, i) => _buildSubjectRow(_items[i]),
          ),
        ],
      ),
    );
  }

  Widget _colHead(String label) {
    return SizedBox(
      width: 38,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildSubjectRow(_SubjectMark item) {
    final total = double.tryParse(item.total) ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Subject name
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.subjectName,
                  style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.remarks.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.remarks,
                      style: TextStyle(
                          fontSize: 9,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
          // BOT
          _markCell(item.botMark, item.didBot),
          // MOT
          _markCell(item.motMark, item.didMot),
          // EOT
          _markCell(item.eotMark, item.didEot),
          // Total
          SizedBox(
            width: 38,
            child: Text(
              item.total.isNotEmpty ? item.total : '—',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: total > 0 ? _markColor(item.total) : AppColors.textSecondary,
              ),
            ),
          ),
          // Grade badge
          SizedBox(
            width: 38,
            child: item.grade.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: _gradeColor(item.grade).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                          color: _gradeColor(item.grade).withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      item.grade,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _gradeColor(item.grade)),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _markCell(String mark, bool submitted) {
    final hasValue = submitted && mark.isNotEmpty && mark != '0';
    return SizedBox(
      width: 38,
      child: Text(
        hasValue ? mark : '—',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
          color: hasValue ? _markColor(mark) : Colors.grey.shade400,
        ),
      ),
    );
  }

  // ── Comments ──────────────────────────────────────────────────────────────

  Widget _buildComments() {
    final comments = <_CommentData>[];
    if (_card.class_teacher_comment.isNotEmpty) {
      comments.add(_CommentData(
          'Class Teacher', _card.class_teacher_comment, FeatherIcons.user));
    }
    if (_card.head_teacher_comment.isNotEmpty) {
      comments.add(_CommentData(
          'Head Teacher', _card.head_teacher_comment, FeatherIcons.briefcase));
    }
    if (_card.sports_comment.isNotEmpty) {
      comments.add(_CommentData(
          'Sports', _card.sports_comment, FeatherIcons.activity));
    }
    if (_card.mentor_comment.isNotEmpty) {
      comments.add(_CommentData(
          'Mentor', _card.mentor_comment, FeatherIcons.heart));
    }
    if (_card.nurse_comment.isNotEmpty) {
      comments.add(
          _CommentData('Nurse', _card.nurse_comment, FeatherIcons.plus));
    }

    if (comments.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('COMMENTS', FeatherIcons.messageSquare),
          ...comments
              .map((c) => _buildCommentTile(c.role, c.text, c.icon)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildCommentTile(String role, String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(color: AppColors.border, width: 0.8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, size: 14, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      letterSpacing: 0.4),
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── PDF action buttons ────────────────────────────────────────────────────

  Widget _buildPdfActions() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_card.hasPdf) ...[
            // Primary: open existing PDF
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
              ),
              onPressed: _openPdf,
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              label: const Text('Open Report Card PDF',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 8),
          ],
          // Secondary: generate / regenerate
          _generatingPdf
              ? Container(
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary)),
                      const SizedBox(width: 12),
                      const Text('Generating PDF…',
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                )
              : OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                        color: _card.hasPdf
                            ? Colors.orange.shade700
                            : AppColors.primary),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                  ),
                  onPressed: _generatePdf,
                  icon: Icon(
                    _card.hasPdf
                        ? Icons.refresh
                        : Icons.picture_as_pdf_outlined,
                    color: _card.hasPdf
                        ? Colors.orange.shade700
                        : AppColors.primary,
                    size: 18,
                  ),
                  label: Text(
                    _card.hasPdf ? 'Regenerate PDF' : 'Generate PDF',
                    style: TextStyle(
                      color: _card.hasPdf
                          ? Colors.orange.shade700
                          : AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 0.8,
              fontSize: 11,
            ),
          ),
        ],
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
