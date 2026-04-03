import 'package:flutter/material.dart';
import 'api_client.dart';
import 'screens/landing_page.dart';
import 'screens/scoreboard_screen.dart';
import 'screens/leads_screen.dart';
import 'screens/activity_screen.dart';

void main() {
  runApp(const HackathonDashboardApp());
}

// =============================================================================
// APP ROOT
// =============================================================================
class HackathonDashboardApp extends StatefulWidget {
  const HackathonDashboardApp({super.key});

  @override
  State<HackathonDashboardApp> createState() => _HackathonDashboardAppState();
}

class _HackathonDashboardAppState extends State<HackathonDashboardApp> {
  late final ApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
  }

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dOrg Sales Agent Hackathon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        // Semi-transparent so the Game of Life canvas shows through
        scaffoldBackgroundColor: const Color(0xDD121218),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF5865F2),
          secondary: Color(0xFF5865F2),
          surface: Color(0xFF1E1E2E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF16161E),
          indicatorColor: const Color(0xFF5865F2).withAlpha(40),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: Color(0xFF5865F2),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              );
            }
            return TextStyle(
              color: Colors.white.withAlpha(100),
              fontSize: 12,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Color(0xFF5865F2), size: 24);
            }
            return IconThemeData(color: Colors.white.withAlpha(100), size: 24);
          }),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final name = settings.name ?? '/';
        Widget page;
        switch (name) {
          case '/scoreboard':
            page = _DashboardShell(
              apiClient: _apiClient,
              currentRoute: '/scoreboard',
            );
          case '/leads':
            page = _DashboardShell(
              apiClient: _apiClient,
              currentRoute: '/leads',
            );
          case '/activity':
            page = _DashboardShell(
              apiClient: _apiClient,
              currentRoute: '/activity',
            );
          case '/':
          default:
            page = _DashboardShell(
              apiClient: _apiClient,
              currentRoute: '/',
            );
        }
        return MaterialPageRoute(
          builder: (_) => page,
          settings: settings,
        );
      },
    );
  }
}

// =============================================================================
// DASHBOARD SHELL - Responsive nav wrapper
// =============================================================================
class _DashboardShell extends StatelessWidget {
  final ApiClient apiClient;
  final String currentRoute;

  const _DashboardShell({
    required this.apiClient,
    required this.currentRoute,
  });

  static const _blurple = Color(0xFF5865F2);

  bool get _isLanding => currentRoute == '/';

  int get _dashboardIndex {
    switch (currentRoute) {
      case '/scoreboard':
        return 0;
      case '/leads':
        return 1;
      case '/activity':
        return 2;
      default:
        return -1;
    }
  }

  String get _title {
    switch (currentRoute) {
      case '/scoreboard':
        return 'Scoreboard';
      case '/leads':
        return 'Leads';
      case '/activity':
        return 'Activity';
      default:
        return '';
    }
  }

  void _navigate(BuildContext context, String route) {
    if (route != currentRoute) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 800;

    Widget body;
    if (_isLanding) {
      body = const LandingPage();
    } else {
      switch (currentRoute) {
        case '/scoreboard':
          body = ScoreboardScreen(apiClient: apiClient);
        case '/leads':
          body = LeadsScreen(apiClient: apiClient);
        case '/activity':
          body = ActivityScreen(apiClient: apiClient);
        default:
          body = const LandingPage();
      }
    }

    return Scaffold(
      appBar: _buildAppBar(context, isDesktop),
      body: body,
      bottomNavigationBar:
          (!isDesktop && !_isLanding) ? _buildBottomNav(context) : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDesktop) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: _buildLogoSection(context),
      actions: [
        if (isDesktop) ...[
          _NavTextButton(
            label: 'Home',
            isActive: currentRoute == '/',
            onTap: () => _navigate(context, '/'),
          ),
          _NavTextButton(
            label: 'Scoreboard',
            isActive: currentRoute == '/scoreboard',
            onTap: () => _navigate(context, '/scoreboard'),
          ),
          _NavTextButton(
            label: 'Leads',
            isActive: currentRoute == '/leads',
            onTap: () => _navigate(context, '/leads'),
          ),
          _NavTextButton(
            label: 'Activity',
            isActive: currentRoute == '/activity',
            onTap: () => _navigate(context, '/activity'),
          ),
          const SizedBox(width: 8),
          if (_isLanding)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: FilledButton(
                onPressed: () => _navigate(context, '/scoreboard'),
                style: FilledButton.styleFrom(
                  backgroundColor: _blurple,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Open Scoreboard',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            )
          else
            const SizedBox(width: 16),
        ] else ...[
          if (_isLanding)
            IconButton(
              onPressed: () => _navigate(context, '/scoreboard'),
              icon: const Icon(Icons.leaderboard, color: _blurple),
              tooltip: 'Scoreboard',
            ),
        ],
      ],
    );
  }

  Widget _buildLogoSection(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigate(context, '/'),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5865F2), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  const Icon(Icons.smart_toy, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isLanding ? 'dOrg Hackathon' : _title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (!_isLanding)
                  Text(
                    'dOrg Sales Agent Hackathon',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withAlpha(80),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return NavigationBar(
      height: 68,
      selectedIndex: _dashboardIndex.clamp(0, 2),
      onDestinationSelected: (index) {
        final routes = ['/scoreboard', '/leads', '/activity'];
        _navigate(context, routes[index]);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.leaderboard_outlined),
          selectedIcon: Icon(Icons.leaderboard),
          label: 'Scoreboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_search_outlined),
          selectedIcon: Icon(Icons.person_search),
          label: 'Leads',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: 'Activity',
        ),
      ],
    );
  }
}

// =============================================================================
// NAV TEXT BUTTON (desktop top bar)
// =============================================================================
class _NavTextButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTextButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor:
            isActive ? const Color(0xFF5865F2) : Colors.white.withAlpha(180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}
