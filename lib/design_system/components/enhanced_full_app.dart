import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import '../../controllers/MainController.dart';
import 'navigation_components.dart';
import '../colors/app_colors.dart';
// Note: Import actual screen files from your project
// import '../../screens/full_app/section/AccountSection.dart';
// import '../../screens/full_app/section/SectionDashboard.dart';
// import '../../screens/posts/PostModelsScreen.dart';

/// Enhanced Full App with Material Design 3 Navigation
/// Replaces the custom TabBar with modern navigation components
class EnhancedFullApp extends StatefulWidget {
  static const String tag = "EnhancedFullApp";

  const EnhancedFullApp({super.key});

  @override
  State<EnhancedFullApp> createState() => _EnhancedFullAppState();
}

class _EnhancedFullAppState extends State<EnhancedFullApp> {
  final MainController mainController = Get.put(MainController());
  final EnhancedNavigationController navigationController =
      EnhancedNavigationController();

  // Navigation items for the app
  final List<NavigationItem> navigationItems = [
    const NavigationItem(
      label: 'Home',
      icon: FeatherIcons.home,
      selectedIcon: Icons.home,
      tooltip: 'Home Dashboard',
    ),
    const NavigationItem(
      label: 'Noticeboard',
      icon: Icons.chrome_reader_mode_outlined,
      selectedIcon: Icons.chrome_reader_mode,
      tooltip: 'School Notices',
    ),
    const NavigationItem(
      label: 'Events',
      icon: FeatherIcons.calendar,
      selectedIcon: Icons.event,
      tooltip: 'Upcoming Events',
    ),
    const NavigationItem(
      label: 'News',
      icon: Icons.newspaper,
      selectedIcon: Icons.newspaper,
      tooltip: 'Latest News',
    ),
    const NavigationItem(
      label: 'Account',
      icon: FeatherIcons.user,
      selectedIcon: Icons.person,
      tooltip: 'User Account',
    ),
  ];

  // Screens corresponding to navigation items
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    // Initialize screens - replace with your actual screen widgets
    screens = [
      const Center(
          child: Text('Dashboard Screen', style: TextStyle(fontSize: 24))),
      const Center(
          child: Text('Notice Screen', style: TextStyle(fontSize: 24))),
      const Center(
          child: Text('Events Screen', style: TextStyle(fontSize: 24))),
      const Center(child: Text('News Screen', style: TextStyle(fontSize: 24))),
      const Center(
          child: Text('Account Screen', style: TextStyle(fontSize: 24))),
    ];

    // Setup navigation controller
    navigationController.setItems(navigationItems);
  }

  @override
  void dispose() {
    navigationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: navigationController,
      builder: (context, child) {
        return AdaptiveNavigation(
          items: navigationItems,
          selectedIndex: navigationController.selectedIndex,
          onIndexChanged: navigationController.selectIndex,
          child: Scaffold(
            body: IndexedStack(
              index: navigationController.selectedIndex,
              children: screens,
            ),
          ),
        );
      },
    );
  }
}

/// Alternative implementation for custom navigation bar only
/// Use this if you want to keep the existing screen structure
class FullAppWithEnhancedNavigation extends StatefulWidget {
  static const String tag = "FullAppWithEnhancedNavigation";

  const FullAppWithEnhancedNavigation({super.key});

  @override
  State<FullAppWithEnhancedNavigation> createState() =>
      _FullAppWithEnhancedNavigationState();
}

class _FullAppWithEnhancedNavigationState
    extends State<FullAppWithEnhancedNavigation>
    with SingleTickerProviderStateMixin {
  final MainController mainController = Get.put(MainController());
  late TabController tabController;

  // Navigation destinations for Material Design 3 navigation
  final List<NavigationDestination> destinations = [
    const NavigationDestination(
      icon: Icon(FeatherIcons.home),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
      tooltip: 'Home Dashboard',
    ),
    const NavigationDestination(
      icon: Icon(Icons.chrome_reader_mode_outlined),
      selectedIcon: Icon(Icons.chrome_reader_mode),
      label: 'Noticeboard',
      tooltip: 'School Notices',
    ),
    const NavigationDestination(
      icon: Icon(FeatherIcons.calendar),
      selectedIcon: Icon(Icons.event),
      label: 'Events',
      tooltip: 'Upcoming Events',
    ),
    const NavigationDestination(
      icon: Icon(Icons.newspaper),
      selectedIcon: Icon(Icons.newspaper),
      label: 'News',
      tooltip: 'Latest News',
    ),
    const NavigationDestination(
      icon: Icon(FeatherIcons.user),
      selectedIcon: Icon(Icons.person),
      label: 'Account',
      tooltip: 'User Account',
    ),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabController,
              children: [
                const Center(
                    child: Text('Dashboard Screen',
                        style: TextStyle(fontSize: 24))),
                const Center(
                    child:
                        Text('Notice Screen', style: TextStyle(fontSize: 24))),
                const Center(
                    child:
                        Text('Events Screen', style: TextStyle(fontSize: 24))),
                const Center(
                    child: Text('News Screen', style: TextStyle(fontSize: 24))),
                const Center(
                    child:
                        Text('Account Screen', style: TextStyle(fontSize: 24))),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationComponents.buildNavigationBar(
        destinations: destinations,
        selectedIndex: tabController.index,
        onDestinationSelected: _onDestinationSelected,
        backgroundColor: AppColors.surface,
        height: 80,
      ),
    );
  }
}

/// Example of navigation with tabs for internal screens
class TabbedNavigationExample extends StatefulWidget {
  const TabbedNavigationExample({super.key});

  @override
  State<TabbedNavigationExample> createState() =>
      _TabbedNavigationExampleState();
}

class _TabbedNavigationExampleState extends State<TabbedNavigationExample>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> tabs = [
    const Tab(
      icon: Icon(Icons.dashboard),
      text: 'Overview',
    ),
    const Tab(
      icon: Icon(Icons.analytics),
      text: 'Analytics',
    ),
    const Tab(
      icon: Icon(Icons.settings),
      text: 'Settings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabbed Navigation'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: NavigationComponents.buildTabIndicator(
            controller: _tabController,
            tabs: tabs,
            indicatorColor: AppColors.primary,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const Center(child: Text('Overview Content')),
          const Center(child: Text('Analytics Content')),
          const Center(child: Text('Settings Content')),
        ],
      ),
    );
  }
}

/// Navigation rail example for tablet/desktop layouts
class NavigationRailExample extends StatefulWidget {
  const NavigationRailExample({super.key});

  @override
  State<NavigationRailExample> createState() => _NavigationRailExampleState();
}

class _NavigationRailExampleState extends State<NavigationRailExample> {
  int selectedIndex = 0;

  final List<NavigationRailDestination> destinations = [
    const NavigationRailDestination(
      icon: Icon(Icons.dashboard),
      selectedIcon: Icon(Icons.dashboard),
      label: Text('Dashboard'),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.people),
      selectedIcon: Icon(Icons.people),
      label: Text('Students'),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.school),
      selectedIcon: Icon(Icons.school),
      label: Text('Classes'),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.assessment),
      selectedIcon: Icon(Icons.assessment),
      label: Text('Reports'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationComponents.buildNavigationRail(
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            extended: MediaQuery.of(context).size.width > 1200,
          ),
          Expanded(
            child: Center(
              child: Text(
                'Content for ${destinations[selectedIndex].label}',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
