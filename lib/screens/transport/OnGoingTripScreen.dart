import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/theme/custom_theme.dart';

import '../../models/TransportParticipantModel.dart';
import '../../models/TripModelLocal.dart';
import '../../sections/widgets.dart';
import '../../utils/Utils.dart';
import 'QRCodeCutScannerScreen.dart';

class OnGoingTripScreen extends StatefulWidget {
  final TripModelLocal item;
  OnGoingTripScreen(this.item, {Key? key}) : super(key: key);

  @override
  _OnGoingTripScreenState createState() => _OnGoingTripScreenState();
}

class _OnGoingTripScreenState extends State<OnGoingTripScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  List<TransportParticipantModel> displayedPassengers = [];
  List<TransportParticipantModel> _allPassengers = [];

  bool loading = false;
  int expected = 0, onboard = 0, arrived = 0, absent = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // wire up search listener
    _searchController.addListener(_onSearchChanged);

    // initial data load
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await widget.item.getPassengers();
    _allPassengers = List.from(widget.item.passengers);
    displayedPassengers = List.from(_allPassengers);

    expected = _allPassengers.length;
    onboard =
        _allPassengers.where((p) => p.status.toLowerCase() == 'onboard').length;
    arrived =
        _allPassengers.where((p) => p.status.toLowerCase() == 'arrived').length;
    absent =
        _allPassengers.where((p) => p.status.toLowerCase() == 'absent').length;

    setState(() {});
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        displayedPassengers = List.from(_allPassengers);
      } else {
        displayedPassengers = _allPassengers
            .where((p) =>
                p.name.toLowerCase().contains(q) ||
                p.student_id.toString().toLowerCase().contains(q))
            .toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    // listener will restore full list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.titleMedium(
              "${widget.item.transport_route_text} - ${widget.item.trip_direction}"
                  .toUpperCase(),
              color: Colors.white,
              fontWeight: 700,
            ),
            FxText.bodySmall(
              'Expected: $expected, Missing: $absent, '
              'Onboard: $onboard, Arrived: $arrived',
              color: Colors.white70,
            ),
          ],
        ),
        backgroundColor: CustomTheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 28),
            onPressed: _loadData,
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(text: 'SCAN QR'),
            Tab(text: 'PASSENGERS'),
          ],
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          labelColor: Colors.white,
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ─────────── Scan QR Tab ───────────
          QRCodeCutScannerScreen((code) {
            _clearSearch();
            _findById(code);
          }),

          // ─────────── Passengers Tab ───────────
          Column(
            children: [
              // Search bar with clear button
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by Name or Student ID Number..',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearch,
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  ),
                ),
              ),

              // Passenger list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: displayedPassengers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (_, i) {
                    final pas = displayedPassengers[i];
                    return _passengerTile(pas);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: loading
          ? const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator()),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: FxButton.block(
                onPressed: _confirmEndSession,
                borderRadiusAll: 8,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: FxText.titleLarge(
                  "END SESSION",
                  color: Colors.white,
                  fontWeight: 700,
                ),
              ),
            ),
    );
  }

  Future<void> _findById(String id) async {
    await widget.item.getPassengers();
    final match = widget.item.passengers.firstWhereOrNull(
      (p) => p.student_id.toString().toUpperCase() == id.toUpperCase(),
    );
    if (match != null) {
      _showPassenger(match);
    } else {
      Utils.toast2("Student with id #$id not found.",
          background_color: CustomTheme.red);
    }
  }

  void _showPassenger(TransportParticipantModel p) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Align(
            alignment: Alignment.topRight,
            child: FxContainer(
              onTap: () => Get.back(),
              padding: const EdgeInsets.all(8),
              borderRadiusAll: 100,
              child: const Icon(Icons.close, color: Colors.red),
            ),
          ),
          FxText.titleLarge('Student Found'),
          const SizedBox(height: 12),
          _passengerTile(p),
        ]),
      ),
    );
  }

  Widget _passengerTile(TransportParticipantModel p) {
    // choose status color
    final statusColor = p.status.toLowerCase() == 'onboard'
        ? Colors.orange
        : p.status.toLowerCase() == 'arrived'
            ? Colors.green
            : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          roundedImage(p.avatar.toString(), 6, 6),

          const SizedBox(width: 12),

          // Name + Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.titleMedium(
                  p.name,
                  fontWeight: 600,
                ),
                FxText.bodyMedium(
                  p.student_id,
                  fontWeight: 600,
                  height: 1,
                  color: Colors.grey,
                ),
                const SizedBox(height: 4),
                FxText.bodySmall(
                  p.status.toUpperCase(),
                  color: statusColor,
                  fontWeight: 700,
                ),
              ],
            ),
          ),

          // Action button (if any)
          if (p.status.toLowerCase() == 'absent') ...[
            FxButton.small(
              onPressed: () => _updateStatus(p, 'Onboard'),
              backgroundColor: Colors.orange,
              borderRadiusAll: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Center(
                child: FxText.bodyMedium(
                  'Onboard\nStudent',
                  fontWeight: 800,
                  textAlign: TextAlign.center,
                  color: Colors.white,
                  height: 1,
                ),
              ),
            ),
          ] else if (p.status.toLowerCase() == 'onboard') ...[
            FxButton.small(
              onPressed: () => _updateStatus(p, 'Arrived'),
              backgroundColor: Colors.green,
              borderRadiusAll: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                child: FxText.bodyMedium(
                  'Student\nHas Arrived',
                  fontWeight: 800,
                  color: Colors.white,
                  height: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _updateStatus(TransportParticipantModel p, String to) {
    Get.dialog(AlertDialog(
      title: Text('$to Confirmation'),
      content: Text('Mark this passenger as $to?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        TextButton(
            onPressed: () async {
              p.status = to;
              if (p.status == 'Onboard') {
                p.start_time = DateTime.now().toString();
                p.end_time = '';
              } else if (p.status == 'Arrived') {
                p.end_time = DateTime.now().toString();
              }
              await p.save();
              await _loadData();
              Get.back();
            },
            child: const Text('Confirm')),
      ],
    ));
  }

  void _confirmEndSession() {
    Get.dialog(AlertDialog(
      title: const Text('End Session Confirmation'),
      content: const Text('Are you sure you want to end this session?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        TextButton(
            onPressed: () async {
              Get.back();
              widget.item.status = 'Closed';
              widget.item.failed_message = '';
              await widget.item.save();

              if (!(await Utils.is_connected())) {
                Utils.toast2('Saved for later submission.');
                Get.back();
                return;
              }

              Utils.toast2("Submitting...");
              setState(() => loading = true);
              final resp = await widget.item.do_submit();
              setState(() => loading = false);

              if (resp.isNotEmpty) {
                Utils.toast2("Failed: $resp",
                    background_color: CustomTheme.red);
              } else {
                Utils.toast2("Success");
                Get.back();
              }
            },
            child: const Text('Confirm')),
      ],
    ));
  }
}