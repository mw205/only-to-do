import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cubits/auth/auth_cubit.dart';
import '../cubits/auth/auth_state.dart';

// Original pages
import 'dashboard/dashboard_page.dart';
import 'events/add_edit_event_page.dart';
import 'events/events_list_page.dart';
import 'pomodoro/pomodoro_page.dart';

// New pages
import 'calendar/monthly_view_page.dart';
import 'calendar/weekly_view_page.dart';
import 'mailboxes/mailboxes_page.dart';
import 'tasks/edit_task_page.dart';
import 'tasks/tasks_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isOriginalLayout = true; // Controls which layout to show

  // Original layout pages
  final List<Widget> _originalPages = [
    const EventsListPage(),
    const PomodoroPage(),
    const DashboardPage(),
  ];

  // New layout pages
  final List<Widget> _newPages = [
    const TasksPage(),
    const MailboxesPage(),
    const WeeklyViewPage(),
    const MonthlyViewPage(),
  ];

  final List<String> _newTitles = [
    'Tasks',
    'Mailboxes',
    'Weekly View',
    'Monthly View',
  ];
  final List<String> _originalTitles = ['Events', 'Pomodoro', 'Dashboard'];

  @override
  void initState() {
    super.initState();
    _loadLayoutPreference();
  }

  Future<void> _loadLayoutPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isOriginalLayout = prefs.getBool('is_original_layout') ?? true;
      _selectedIndex = 0;
    });
  }

  Future<void> _saveLayoutPreference(bool isOriginal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_original_layout', isOriginal);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffeee9ff),
          elevation: 0, // Flat look as in the image
          toolbarHeight: 100,
          title: Text(
            _isOriginalLayout
                ? _originalTitles[_selectedIndex]
                : _newTitles[_selectedIndex],
            style: const TextStyle(
              fontSize: 24, // Increase title font size
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20), // Keep the rounded bottom corners
            ),
          ),
          iconTheme: const IconThemeData(
            size: 24, // Increase icon size
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isOriginalLayout ? Icons.view_module : Icons.view_agenda,
              ),
              onPressed: _toggleLayout,
              tooltip: 'Switch layout',
            ),
          ],
        ),
        drawer: _buildDrawer(),
        body:
            _isOriginalLayout
                ? _originalPages[_selectedIndex]
                : _newPages[_selectedIndex],
        bottomNavigationBar:
            _isOriginalLayout
                ? _buildOriginalBottomNav()
                : _buildNewBottomNav(),
        floatingActionButton:
            _shouldShowFAB()
                ? FloatingActionButton(
                  onPressed: () {
                    if (_isOriginalLayout) {
                      if (_selectedIndex == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddEditEventPage(),
                          ),
                        );
                      }
                    } else {
                      if (_selectedIndex == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditTaskPage(),
                          ),
                        );
                      }
                    }
                  },
                  tooltip:
                      _isOriginalLayout ? 'إضافة حدث جديد' : 'إضافة مهمة جديدة',
                  child: const Icon(Icons.add),
                )
                : null,
      ),
    );
  }

  bool _shouldShowFAB() {
    if (_isOriginalLayout) {
      return _selectedIndex == 0;
    } else {
      return _selectedIndex == 0;
    }
  }

  // Toggle between layouts
  void _toggleLayout() {
    setState(() {
      _isOriginalLayout = !_isOriginalLayout;
      _selectedIndex = 0;
    });
    _saveLayoutPreference(_isOriginalLayout);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Switched to ${_isOriginalLayout ? 'Events' : 'Tasks'} layout',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Build the drawer with options for both layouts
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _isOriginalLayout ? Icons.timer : Icons.task_alt,
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(height: 12),
                Text(
                  _isOriginalLayout ? 'Event Countdown' : 'Task Manager',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _isOriginalLayout
                      ? 'Track events & boost productivity'
                      : 'Organize tasks and schedules',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          // Layout switch option
          ListTile(
            leading: Icon(
              _isOriginalLayout ? Icons.view_module : Icons.view_agenda,
            ),
            title: Text(
              'Switch to ${_isOriginalLayout ? 'Tasks' : 'Events'} Layout',
            ),
            onTap: () {
              Navigator.pop(context);
              _toggleLayout();
            },
          ),
          const Divider(),
          // Original layout options
          if (_isOriginalLayout) ...[
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Events'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Pomodoro'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
          ],
          // New layout options
          if (!_isOriginalLayout) ...[
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Tasks'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.mail),
              title: const Text('Mailboxes'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_week),
              title: const Text('Weekly View'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Monthly View'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
    );
  }

  // Original layout bottom navigation
  Widget _buildOriginalBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Pomodoro'),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
      ],
    );
  }

  // New layout bottom navigation
  Widget _buildNewBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Mailboxes'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_view_week),
          label: 'Weekly',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Monthly',
        ),
      ],
    );
  }

  // Handle bottom navigation item tap
  void _onItemTapped(int index) {
    // Check if index is valid for current layout
    if (_isOriginalLayout && index < _originalPages.length) {
      setState(() {
        _selectedIndex = index;
      });
    } else if (!_isOriginalLayout && index < _newPages.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Show logout confirmation dialog
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AuthCubit>().signOut();
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
