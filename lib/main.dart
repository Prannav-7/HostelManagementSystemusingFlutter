import 'package:flutter/material.dart';
import 'screens/complaint_form_screen.dart';
import 'screens/complaint_history_screen.dart';
import 'screens/live_chat_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_selection_screen.dart';
import 'services/complaint_service.dart';
import 'services/student_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StudentService.init();
  runApp(HostelManagementApp());
}

class HostelManagementApp extends StatelessWidget {
  const HostelManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostel Management System',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: Colors.indigo[800],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginSelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int complaintCount = 0;
  int pendingCount = 0;
  int totalStudents = 150;
  int availableRooms = 25;
  int maintenanceRequests = 8;

  @override
  void initState() {
    super.initState();
    _loadComplaintCounts();
  }

  void _loadComplaintCounts() {
    setState(() {
      complaintCount = ComplaintService.getComplaintCount();
      pendingCount = ComplaintService.getPendingComplaintCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Hostel Management System',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[800],
        elevation: 2,
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () => _navigateToNotifications(context),
                tooltip: 'Notifications',
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => _navigateToSettings(context),
            tooltip: 'Settings',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo[600]!, Colors.indigo[800]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.indigo),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Room B-205',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              title: 'Home',
              onTap: () => Navigator.of(context).pop(),
            ),
            _buildDrawerItem(
              icon: Icons.bed,
              title: 'Room Allocation',
              onTap: () {
                Navigator.of(context).pop();
                _showComingSoon(context, 'Room Allocation');
              },
            ),
            _buildDrawerItem(
              icon: Icons.people,
              title: 'Student Directory',
              onTap: () {
                Navigator.of(context).pop();
                _showComingSoon(context, 'Student Directory');
              },
            ),
            _buildDrawerItem(
              icon: Icons.report_problem,
              title: 'Submit Issue',
              onTap: () {
                Navigator.of(context).pop();
                _navigateToComplaintForm(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.history,
              title: 'Issue History',
              onTap: () {
                Navigator.of(context).pop();
                _navigateToHistory(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.chat,
              title: 'Warden Chat',
              onTap: () {
                Navigator.of(context).pop();
                _navigateToChat(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.notifications,
              title: 'Notices',
              onTap: () {
                Navigator.of(context).pop();
                _navigateToNotifications(context);
              },
            ),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.restaurant,
              title: 'Mess Menu',
              onTap: () {
                Navigator.of(context).pop();
                _showComingSoon(context, 'Mess Menu');
              },
            ),
            _buildDrawerItem(
              icon: Icons.local_laundry_service,
              title: 'Laundry Service',
              onTap: () {
                Navigator.of(context).pop();
                _showComingSoon(context, 'Laundry Service');
              },
            ),
            _buildDrawerItem(
              icon: Icons.build,
              title: 'Maintenance',
              onTap: () {
                Navigator.of(context).pop();
                _showComingSoon(context, 'Maintenance Requests');
              },
            ),
            _buildDrawerItem(
              icon: Icons.payment,
              title: 'Fee Payment',
              onTap: () {
                Navigator.of(context).pop();
                _showComingSoon(context, 'Fee Payment');
              },
            ),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.of(context).pop();
                _navigateToSettings(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.help,
              title: 'Help & Support',
              onTap: () {
                Navigator.of(context).pop();
                _showContactInfo(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Section
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo[600]!, Colors.indigo[800]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.school, size: 60, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome to Hostel Management',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your home away from home. Manage your hostel life with ease.',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Statistics Cards
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hostel Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Students',
                          totalStudents.toString(),
                          Icons.people,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Available Rooms',
                          availableRooms.toString(),
                          Icons.bed,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Pending Issues',
                          pendingCount.toString(),
                          Icons.report_problem,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Maintenance',
                          maintenanceRequests.toString(),
                          Icons.build,
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Quick Actions Section
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Action Cards Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildActionCard(
                  context,
                  icon: Icons.report_problem,
                  title: 'Report Issue',
                  subtitle: 'Submit hostel issue',
                  color: Colors.red[400]!,
                  onTap: () => _navigateToComplaintForm(context),
                ),
                _buildActionCard(
                  context,
                  icon: Icons.history,
                  title: 'Issue History',
                  subtitle: '$complaintCount total issues',
                  color: Colors.orange[400]!,
                  onTap: () => _navigateToHistory(context),
                ),
                _buildActionCard(
                  context,
                  icon: Icons.chat,
                  title: 'Warden Chat',
                  subtitle: 'Contact warden',
                  color: Colors.green[400]!,
                  onTap: () => _navigateToChat(context),
                ),
                _buildActionCard(
                  context,
                  icon: Icons.phone,
                  title: 'Emergency',
                  subtitle: 'Quick help',
                  color: Colors.blue[400]!,
                  onTap: () => _showContactInfo(context),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Recent Issues Section (if any)
            if (complaintCount > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Issues',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (pendingCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange[300]!),
                      ),
                      child: Text(
                        '$pendingCount pending',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              _buildRecentComplaintsWidget(),
              const SizedBox(height: 32),
            ],

            // Emergency Contact Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.emergency, color: Colors.red[600], size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emergency Contact',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'For urgent matters, call: +1 (555) 123-4567',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Hostel Information
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hostel Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.location_on,
                    'Sunshine Boys Hostel, University Campus',
                  ),
                  _buildInfoRow(
                    Icons.access_time,
                    'Warden Office: 6:00 AM - 10:00 PM',
                  ),
                  _buildInfoRow(Icons.wifi, 'WiFi: SunshineHostel_Students'),
                  _buildInfoRow(
                    Icons.restaurant,
                    'Mess Timing: 7 AM, 1 PM, 8 PM',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToComplaintForm(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ComplaintFormScreen()),
    );
    // Refresh complaint counts when returning from form
    if (result == true || result == null) {
      _loadComplaintCounts();
    }
  }

  void _navigateToHistory(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ComplaintHistoryScreen()),
    );
    // Refresh complaint counts when returning from history
    if (result == true || result == null) {
      _loadComplaintCounts();
    }
  }

  void _navigateToChat(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const LiveChatScreen()));
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const NotificationScreen()));
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SettingsScreen()));
  }

  void _showContactInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.contact_phone, color: Colors.indigo[600]),
              const SizedBox(width: 12),
              const Text('Contact Information'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContactRow(Icons.person, 'Warden', '+1 (555) 123-4567'),
              _buildContactRow(
                Icons.emergency,
                'Emergency',
                '+1 (555) 123-4567',
              ),
              _buildContactRow(Icons.email, 'Email', 'warden@sunshine.edu'),
              _buildContactRow(Icons.security, 'Security', '+1 (555) 123-4568'),
              _buildContactRow(Icons.build, 'Maintenance', '+1 (555) 123-4569'),
              _buildContactRow(
                Icons.restaurant,
                'Mess Manager',
                '+1 (555) 123-4570',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.indigo[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.indigo[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Warden available 6 AM - 10 PM daily',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _makeDirectCall(context);
              },
              icon: const Icon(Icons.phone),
              label: const Text('Call Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[600],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactRow(IconData icon, String label, String contact) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              contact,
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _makeDirectCall(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Service'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCallOption(
                context,
                'Warden',
                '+1 (555) 123-4567',
                Icons.person,
              ),
              _buildCallOption(
                context,
                'Emergency',
                '+1 (555) 123-4567',
                Icons.emergency,
              ),
              _buildCallOption(
                context,
                'Security',
                '+1 (555) 123-4568',
                Icons.security,
              ),
              _buildCallOption(
                context,
                'Maintenance',
                '+1 (555) 123-4569',
                Icons.build,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCallOption(
    BuildContext context,
    String service,
    String number,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[600]),
      title: Text(service),
      subtitle: Text(number),
      onTap: () {
        Navigator.of(context).pop();
        _simulateCall(context, service, number);
      },
    );
  }

  void _simulateCall(BuildContext context, String service, String number) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.phone, color: Colors.green[600]),
              const SizedBox(width: 12),
              Text('Calling $service'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Connecting to $number...'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('End Call'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );

    // Simulate call connection
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connected to $service - $number'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Hang Up',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    });
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo[600]),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(feature),
          content: Text(
            '$feature feature is coming soon! Stay tuned for updates.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecentComplaintsWidget() {
    final recentComplaints = ComplaintService.getRecentComplaints(limit: 3);

    if (recentComplaints.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'No issues reported yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Report your first issue using the button above',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: recentComplaints.map((complaint) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaint.id,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          complaint.category,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildMiniStatusChip(complaint.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                complaint.description.length > 80
                    ? '${complaint.description.substring(0, 80)}...'
                    : complaint.description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    _formatRelativeTime(complaint.submittedDate),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const Spacer(),
                  Text(
                    complaint.priority,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _getPriorityColor(complaint.priority),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMiniStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'Resolved':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        break;
      case 'In Progress':
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[700]!;
        break;
      case 'Pending':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[700]!;
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Urgent':
        return Colors.red[600]!;
      case 'High':
        return Colors.orange[600]!;
      case 'Medium':
        return Colors.blue[600]!;
      case 'Low':
        return Colors.green[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}
