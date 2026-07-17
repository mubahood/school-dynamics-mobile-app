import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:schooldynamics/models/ProgressiveReportModel.dart';
import 'package:schooldynamics/models/RespondModel.dart';
import 'package:schooldynamics/models/UserModel.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../theme/custom_theme.dart';
import 'PdfViewer.dart';

class ProgressiveReportsScreen extends StatefulWidget {
  /// Pass a [UserModel] to show reports for a specific student (employee view).
  /// Pass null to show the logged-in parent's children's reports.
  final UserModel? student;

  const ProgressiveReportsScreen({super.key, this.student});

  @override
  State<ProgressiveReportsScreen> createState() =>
      _ProgressiveReportsScreenState();
}

class _ProgressiveReportsScreenState extends State<ProgressiveReportsScreen> {
  List<ProgressiveReportModel> reports = [];
  bool isLoading = true;
  bool isSyncing = false;
  bool isGeneratingPdf = false;
  int generatingId = 0;
  String lastSyncedAt = '';
  LoggedInUserModel loggedInUser = LoggedInUserModel();

  @override
  void initState() {
    super.initState();
    _load();
  }

  String get _whereClause {
    if (widget.student != null) {
      return "student_id = '${widget.student!.id}'";
    }
    return '1';
  }

  Future<void> _load() async {
    loggedInUser = await LoggedInUserModel.getLoggedInUser();

    // Step 1 — show cached data immediately so the screen is never blank
    final cached =
        await ProgressiveReportModel.getLocalData(where: _whereClause);
    if (mounted) {
      setState(() {
        if (cached.isNotEmpty) {
          reports = cached;
          isLoading = false;
          // Carry forward the last-synced timestamp if available
          final ts = cached.first.local_synced_at;
          if (ts.isNotEmpty) {
            lastSyncedAt = _formatSyncTime(ts);
          }
        }
        isSyncing = true;
      });
    }

    // Step 2 — background sync from API
    final params = <String, dynamic>{};
    if (widget.student != null) {
      params['student_id'] = widget.student!.id.toString();
    }
    final raw = await Utils.http_get('student-progressive-reports', params);
    final resp = RespondModel(raw);

    if (resp.code == 1 && resp.data is List) {
      // Persist to SQLite so future offline loads have fresh data
      await ProgressiveReportModel.saveItems(resp.data as List);
      final fresh =
          await ProgressiveReportModel.getLocalData(where: _whereClause);
      final now = DateTime.now();
      final timeStr =
          '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
      if (mounted) {
        setState(() {
          reports = fresh;
          isLoading = false;
          isSyncing = false;
          lastSyncedAt = timeStr;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
          isSyncing = false;
        });
      }
    }
  }

  String _formatSyncTime(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  Future<void> _generatePdf(ProgressiveReportModel report) async {
    setState(() {
      isGeneratingPdf = true;
      generatingId = report.id;
    });
    Utils.toast('Generating PDF, please wait…');

    final raw = await Utils.http_post(
        'make-pa-pdf/${report.id}', {});
    final resp = RespondModel(raw);

    if (resp.code == 1 && resp.data != null) {
      final fullUrl = Utils.to_str(resp.data['full_url'], '');
      setState(() {
        final idx = reports.indexWhere((r) => r.id == report.id);
        if (idx >= 0) {
          reports[idx].pdf_url =
              Utils.to_str(resp.data['pdf_url'], report.pdf_url);
        }
        isGeneratingPdf = false;
        generatingId = 0;
      });
      if (fullUrl.isNotEmpty) {
        Get.to(() => PdfViewerScreen(fullUrl, report.assessmentTitle));
      }
    } else {
      setState(() {
        isGeneratingPdf = false;
        generatingId = 0;
      });
      Utils.toast(resp.message.isNotEmpty
          ? resp.message
          : 'Failed to generate PDF. Please try again.');
    }
  }

  // ── UI helpers ─────────────────────────────────────────────────────────────

  Color _gradeColor(String grade) {
    switch (grade.toUpperCase()) {
      case '1':
        return Colors.green.shade700;
      case '2':
        return Colors.lightGreen.shade600;
      case '3':
        return Colors.amber.shade700;
      case '4':
        return Colors.orange.shade700;
      case 'U':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  String _gradeLabel(String grade) {
    switch (grade.toUpperCase()) {
      case '1':
        return 'Distinction';
      case '2':
        return 'Merit';
      case '3':
        return 'Credit';
      case '4':
        return 'Pass';
      case 'U':
        return 'Ungraded';
      default:
        return grade.isNotEmpty ? grade : '—';
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final title = widget.student != null
        ? '${widget.student!.name} — PA Reports'
        : 'Progressive Assessment Reports';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        systemOverlayStyle: Utils.get_theme(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.titleMedium(title,
                color: Colors.white, fontWeight: 700, fontSize: 16),
            if (lastSyncedAt.isNotEmpty)
              FxText.labelSmall('Last synced: $lastSyncedAt',
                  color: Colors.white70),
          ],
        ),
        actions: [
          if (isSyncing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white70),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _load,
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reports.isEmpty
              ? _buildEmpty()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: reports.length,
                    itemBuilder: (ctx, i) => _buildReportCard(reports[i]),
                  ),
                ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.assessment_outlined,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          FxText.bodyLarge('No progressive reports found',
              color: Colors.grey.shade600),
          const SizedBox(height: 8),
          FxText.bodySmall('Reports appear here once assessments are published.',
              color: Colors.grey.shade500, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style:
                ElevatedButton.styleFrom(backgroundColor: CustomTheme.primary),
            onPressed: _load,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: FxText.bodyMedium('Refresh', color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(ProgressiveReportModel rep) {
    final grade = rep.grade;
    final gradeColor = _gradeColor(grade);
    final totalMarks =
        rep.total_marks.isNotEmpty ? double.tryParse(rep.total_marks) ?? 0 : 0;
    final pos = rep.position.isNotEmpty ? rep.position : '—';
    final total = rep.total_students.isNotEmpty ? rep.total_students : '—';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: CustomTheme.primary,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FxText.titleSmall(rep.assessmentTitle,
                          color: Colors.white, fontWeight: 700),
                      const SizedBox(height: 2),
                      FxText.bodySmall(
                          rep.academic_class_text.isNotEmpty
                              ? rep.academic_class_text
                              : (rep.student_text.isNotEmpty
                                  ? rep.student_text
                                  : ''),
                          color: Colors.white70),
                    ],
                  ),
                ),
                // Grade badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: gradeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FxText.titleMedium(
                    grade.isNotEmpty ? 'DIV $grade' : '—',
                    color: Colors.white,
                    fontWeight: 900,
                  ),
                ),
              ],
            ),
          ),

          // ── Stats row ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                _statChip(Icons.score, '${totalMarks.toStringAsFixed(0)} marks',
                    Colors.blue.shade700),
                const SizedBox(width: 8),
                _statChip(Icons.leaderboard, '$pos / $total',
                    Colors.purple.shade700),
                const SizedBox(width: 8),
                _statChip(Icons.grade, _gradeLabel(grade), gradeColor),
              ],
            ),
          ),

          // ── Subject scores ─────────────────────────────────────────────
          if (rep.items.isNotEmpty) ...[
            const Divider(height: 16, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FxText.labelSmall('SUBJECT SCORES',
                  color: Colors.grey.shade500, letterSpacing: 1.2),
            ),
            const SizedBox(height: 6),
            ...rep.items.map((item) => _buildSubjectRow(item, rep.numTests)),
          ],

          // ── Comments ───────────────────────────────────────────────────
          if (rep.class_teacher_comment.isNotEmpty ||
              rep.head_teacher_comment.isNotEmpty) ...[
            const Divider(height: 16, indent: 16, endIndent: 16),
            if (rep.class_teacher_comment.isNotEmpty)
              _commentTile(
                  'Class Teacher', rep.class_teacher_comment, Icons.person),
            if (rep.head_teacher_comment.isNotEmpty)
              _commentTile(
                  'Head Teacher', rep.head_teacher_comment, Icons.school),
          ],

          // ── Action buttons ─────────────────────────────────────────────
          const Divider(height: 16, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                if (rep.hasPdf)
                  Expanded(
                    child: _actionButton(
                      icon: Icons.picture_as_pdf,
                      label: 'View PDF',
                      color: Colors.red.shade700,
                      onTap: () => Get.to(() =>
                          PdfViewerScreen(rep.getPdf(), rep.assessmentTitle)),
                    ),
                  ),
                if (rep.hasPdf) const SizedBox(width: 8),
                Expanded(
                  child: isGeneratingPdf && generatingId == rep.id
                      ? Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2)),
                              const SizedBox(width: 8),
                              FxText.bodySmall('Generating…',
                                  color: Colors.grey.shade600),
                            ],
                          ),
                        )
                      : _actionButton(
                          icon: rep.hasPdf
                              ? Icons.refresh
                              : Icons.picture_as_pdf_outlined,
                          label: rep.hasPdf ? 'Regenerate' : 'Generate PDF',
                          color: rep.hasPdf
                              ? Colors.orange.shade700
                              : CustomTheme.primary,
                          onTap: () => _generatePdf(rep),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectRow(ProgressiveReportItem item, int numTests) {
    final avg = double.tryParse(item.average_mark) ?? 0;
    final pct = avg.clamp(0, 100) / 100;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: FxText.bodySmall(item.displayName,
                    fontWeight: 600, color: Colors.grey.shade800),
              ),
              FxText.bodySmall('${avg.toStringAsFixed(0)}%',
                  color: avg >= 60
                      ? Colors.green.shade700
                      : avg >= 40
                          ? Colors.orange.shade700
                          : Colors.red.shade700,
                  fontWeight: 700),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: avg >= 60
                      ? Colors.green.shade50
                      : avg >= 40
                          ? Colors.orange.shade50
                          : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: avg >= 60
                        ? Colors.green.shade300
                        : avg >= 40
                            ? Colors.orange.shade300
                            : Colors.red.shade300,
                  ),
                ),
                child: FxText.labelSmall(item.grade_name.isNotEmpty
                    ? item.grade_name
                    : '—'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: pct,
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(avg >= 60
                ? Colors.green.shade500
                : avg >= 40
                    ? Colors.orange.shade500
                    : Colors.red.shade500),
          ),
          // Individual test scores
          if (item.test_scores_parsed.isNotEmpty && numTests > 1)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                spacing: 6,
                children: List.generate(item.test_scores_parsed.length,
                    (i) {
                  final s = item.test_scores_parsed[i];
                  final score = s['score'];
                  final submitted = s['submitted'] == 'Yes';
                  return Chip(
                    label: FxText.labelSmall(
                      'T${i + 1}: ${submitted && score != null ? '$score' : '—'}',
                      color:
                          submitted ? CustomTheme.primary : Colors.grey.shade500,
                    ),
                    backgroundColor: submitted
                        ? CustomTheme.primary.withValues(alpha: 0.08)
                        : Colors.grey.shade100,
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          FxText.labelSmall(label, color: color, fontWeight: 600),
        ],
      ),
    );
  }

  Widget _commentTile(String role, String comment, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.labelSmall('$role Comment',
                    color: Colors.grey.shade500, letterSpacing: 0.5),
                FxText.bodySmall(comment, color: Colors.grey.shade800),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.6)),
          borderRadius: BorderRadius.circular(8),
          color: color.withValues(alpha: 0.06),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            FxText.bodySmall(label, color: color, fontWeight: 600),
          ],
        ),
      ),
    );
  }
}
