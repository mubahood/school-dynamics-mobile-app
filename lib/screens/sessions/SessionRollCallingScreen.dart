import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../models/SessionLocal.dart';
import '../../models/TemporaryModel.dart';
import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';
import 'QRCodeScannerScreen.dart';

class SessionRollCallingScreen extends StatefulWidget {
  final dynamic data;
  SessionRollCallingScreen({Key? key, this.data}) : super(key: key);

  @override
  SessionRollCallingScreenState createState() =>
      SessionRollCallingScreenState();
}

class SessionRollCallingScreenState extends State<SessionRollCallingScreen>
    with SingleTickerProviderStateMixin {
  late SessionLocal item;
  late TabController _tabController;

  // for manual search
  final TextEditingController _searchController = TextEditingController();
  List<TemporaryModel> _displayedMembers = [];

  // guard against double QR callbacks
  bool _scanProcessed = false;

  String error_message = "";
  bool is_loading = false;

  @override
  void initState() {
    super.initState();

    // set up your TabController (even though you use DefaultTabController,
    // we need it to reset the scan flag when switching tabs)
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (_tabController.index == 1) {
          // entering SCAN tab → allow a fresh scan
          _scanProcessed = false;
        }
      });

    // initial session data + manual list
    _initSession();

    // wire up search filter
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _initSession() async {
    // same guard you had
    if (widget.data.runtimeType != SessionLocal) {
      Utils.toast('Data not found.');
      Get.back();
      return;
    }

    item = widget.data as SessionLocal;

    // load your lists (these may be sync or async; kept as you wrote)
    await item.getExpectedMembers();
    await item.getPresentMembers();
    await item.getAbsentMembers();

    // show all by default
    _displayedMembers = List.from(item.expectedMembers);

    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  // filter by name OR by ID substring
  void _onSearchChanged() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _displayedMembers = List.from(item.expectedMembers);
      } else {
        _displayedMembers = item.expectedMembers.where((m) {
          final name = m.title.toLowerCase();
          final id = m.id.toString();
          return name.contains(q) || id.contains(q);
        }).toList();
      }
    });
  }

  Future<void> submit_form() async {
    item.closed = 'yes';
    await item.save();

    if (await Utils.is_connected()) {
      Utils.showLoader(true);
      try {
        Utils.toast("Uploading session...");
        await item.submitSelf();
      } catch (e) {
        Utils.toast("Failed to upload session: ${e.toString()}");
      }
      Utils.hideLoader();
    } else {
      Utils.toast("Saved for later upload.");
      await _doSave(true);
      Utils.boot_system();
    }

    Get.back();
  }

  Future<void> _doSave(bool isFinal) async {
    item.closed = isFinal ? 'yes' : 'no';
    item.present = jsonEncode(item.presentMembers);
    item.absent = jsonEncode(item.absentMembers);
    await item.save();
  }

  Future<void> pause_session() async {
    await _doSave(false);
    Utils.toast("Roll call paused.");
  }

  void _addToPresent(int id) async {
    if (!item.presentMembers.contains(id)) item.presentMembers.add(id);
    item.absentMembers.remove(id);
    await _doSave(false);
    setState(() {});
  }

  void _addToAbsent(int id) async {
    if (!item.absentMembers.contains(id)) item.absentMembers.add(id);
    item.presentMembers.remove(id);
    await _doSave(false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          toolbarHeight: 65,
          actions: [
            IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Delete Session",
                  middleText: "Are you sure you want to delete this session?",
                  textConfirm: "Yes",
                  textCancel: "No",
                  confirmTextColor: Colors.white,
                  buttonColor: CustomTheme.primary,
                  onConfirm: () async {
                    await item.deleteSelf();
                    Get.back(); // close dialog
                    Get.back(); // pop screen
                  },
                );
              },
              icon:
                  const Icon(Icons.delete_forever, color: Colors.red, size: 35),
            )
          ],
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /*   FxText.bodySmall(
                '${item.title} - Roll call',
                color: Colors.white,
                fontWeight: 700,
                height: .9,
                textAlign: TextAlign.center,
              ),*/
              FxText.bodySmall(
                'Expected: ${item.expectedMembers.length}, '
                'Present: ${item.presentMembers.length}, '
                'Absent: ${item.absentMembers.length}',
                color: Colors.white,
              ),
              TabBar(
                controller: _tabController,
                labelColor: CustomTheme.primary,
                indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(color: Colors.white, width: 4)),
                tabs: [
                  Tab(
                    child: FxText.bodySmall("MANUAL",
                        height: 1, fontWeight: 600, color: Colors.white),
                  ),
                  Tab(
                    child: FxText.bodySmall("SCAN",
                        height: 1, fontWeight: 600, color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // ─────────── MANUAL TAB ───────────
            Column(
              children: [
                // SEARCH BAR
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name or ID...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                // MEMBER LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: _displayedMembers.length,
                    itemBuilder: (ctx, i) {
                      final m = _displayedMembers[i];
                      return Container(
                        color: item.presentMembers.contains(m.id)
                            ? Colors.green.shade50
                            : item.absentMembers.contains(m.id)
                                ? Colors.red.shade50
                                : Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                        child: Row(
                          children: [
                            roundedImage(m.image.toString(), 5, 5),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FxText.titleLarge(
                                '${m.title}\n${m.details}',
                                fontSize: 16,
                                color: Colors.grey.shade900,
                                fontWeight: 600,
                              ),
                            ),
                            // PRESENT / ABSENT toggles
                            Row(
                              children: [
                                // PRESENT
                                InkWell(
                                  onTap: () => _addToPresent(m.id),
                                  child: Column(
                                    children: [
                                      FxText.bodySmall(
                                        'PRESENT',
                                        fontWeight: 700,
                                        color: Colors.green.shade900,
                                      ),
                                      const SizedBox(height: 4),
                                      FxContainer(
                                        width: 24,
                                        height: 24,
                                        bordered: true,
                                        borderRadiusAll: 12,
                                        color:
                                            item.presentMembers.contains(m.id)
                                                ? Colors.green.shade700
                                                : Colors.white,
                                        borderColor: Colors.green.shade900,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // ABSENT
                                InkWell(
                                  onTap: () => _addToAbsent(m.id),
                                  child: Column(
                                    children: [
                                      FxText.bodySmall(
                                        'ABSENT',
                                        fontWeight: 700,
                                        color: Colors.red.shade900,
                                      ),
                                      const SizedBox(height: 4),
                                      FxContainer(
                                        width: 24,
                                        height: 24,
                                        bordered: true,
                                        borderRadiusAll: 12,
                                        color: item.absentMembers.contains(m.id)
                                            ? Colors.red.shade700
                                            : Colors.white,
                                        borderColor: Colors.red.shade800,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: FxButton.outlined(
                          borderColor: CustomTheme.primary,
                          onPressed: pause_session,
                          child: FxText.titleMedium(
                            'PAUSE',
                            color: CustomTheme.primary,
                            fontWeight: 800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FxButton.block(
                          borderColor: CustomTheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          onPressed: () {
                            if (item.presentMembers.isEmpty) {
                              Utils.toast("No members marked present.");
                              return;
                            }
                            Get.defaultDialog(
                              title: "Submit Roll Call",
                              middleText:
                                  "Are you sure you want to submit this roll call?",
                              textConfirm: "Yes",
                              textCancel: "No",
                              confirmTextColor: Colors.white,
                              buttonColor: CustomTheme.primary,
                              onConfirm: () async {
                                Get.back();
                                await submit_form();
                              },
                            );
                          },
                          child: FxText.titleMedium(
                            'SUBMIT',
                            color: Colors.white,
                            fontWeight: 800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),

            // ─────────── SCAN TAB ───────────
            QRCodeScannerScreen((String? code) {
              if (code == null || _scanProcessed) return;
              _scanProcessed = true;

              final x = code.toUpperCase().trim();
              final found = item.expectedMembers
                  .where((e) => e.details.toUpperCase().trim() == x);

              if (found.isNotEmpty) {
                Utils.toast("Found ${found.first.title} – $x",
                    color: Colors.green.shade900);
                _addToPresent(found.first.id);
              } else {
                Utils.toast("Student $x not found.",
                    color: Colors.red.shade900);
              }
              // allow next scan after a short pause
              Future.delayed(const Duration(seconds: 2), () {
                _scanProcessed = false;
              });
            }),
          ],
        ),
      ),
    );
  }
}