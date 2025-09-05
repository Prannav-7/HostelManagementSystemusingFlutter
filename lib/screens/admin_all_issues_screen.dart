import 'package:flutter/material.dart';
import '../services/student_service.dart';
import '../services/complaint_service.dart';

class AdminAllIssuesScreen extends StatefulWidget {
  const AdminAllIssuesScreen({super.key});

  @override
  State<AdminAllIssuesScreen> createState() => _AdminAllIssuesScreenState();
}

class _AdminAllIssuesScreenState extends State<AdminAllIssuesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'All Issues & Requests',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[700],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.assignment), text: 'Leave'),
            Tab(icon: Icon(Icons.bed), text: 'Rooms'),
            Tab(icon: Icon(Icons.local_laundry_service), text: 'Laundry'),
            Tab(icon: Icon(Icons.report_problem), text: 'Issues'),
            Tab(icon: Icon(Icons.feedback), text: 'Complaints'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaveRequestsTab(),
          _buildRoomBookingsTab(),
          _buildLaundryRequestsTab(),
          _buildRoomIssuesTab(),
          _buildComplaintsTab(),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestsTab() {
    final requests = StudentService.getAllLeaveRequests();

    if (requests.isEmpty) {
      return _buildEmptyState('No leave requests', Icons.assignment);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        final student = StudentService.getStudentById(request.studentId);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.assignment, color: Colors.blue[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        student?.name ?? 'Unknown Student',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildStatusChip(request.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Room: ${student?.roomNumber ?? 'N/A'}'),
                Text(
                  'Dates: ${_formatDate(request.startDate)} - ${_formatDate(request.endDate)}',
                ),
                Text('Reason: ${request.reason}'),
                if (request.adminComments != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Admin: ${request.adminComments}'),
                  ),
                ],
                if (request.status == 'Pending') ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              _updateLeaveRequest(request.id, 'Approved'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Approve',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              _updateLeaveRequest(request.id, 'Rejected'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'Reject',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoomBookingsTab() {
    final bookings = StudentService.getAllRoomBookings();

    if (bookings.isEmpty) {
      return _buildEmptyState('No room booking requests', Icons.bed);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final student = StudentService.getStudentById(booking.studentId);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bed, color: Colors.green[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        student?.name ?? 'Unknown Student',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildStatusChip(booking.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Current Room: ${booking.currentRoom}'),
                Text('Requested Room: ${booking.requestedRoom}'),
                Text('Reason: ${booking.reason}'),
                Text('Requested: ${_formatDate(booking.requestDate)}'),
                if (booking.status == 'Pending') ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _approveRoomBooking(booking),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Approve',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _rejectRoomBooking(booking.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'Reject',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLaundryRequestsTab() {
    final requests = StudentService.getAllLaundryRequests();

    if (requests.isEmpty) {
      return _buildEmptyState(
        'No laundry requests',
        Icons.local_laundry_service,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_laundry_service,
                      color: Colors.purple[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        request.studentName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildStatusChip(request.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Room: ${request.roomNumber}'),
                Text('Service: ${request.serviceType}'),
                Text(
                  'Pickup: ${_formatDate(request.pickupDate)} at ${request.pickupTime}',
                ),
                Text(
                  'Items (${request.items.length}): ${request.items.join(', ')}',
                ),
                if (request.cost != null)
                  Text('Cost: \$${request.cost!.toStringAsFixed(2)}'),
                if (request.specialInstructions.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('Instructions: ${request.specialInstructions}'),
                ],
                if (request.status == 'Pending') ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              _updateLaundryStatus(request.id, 'In Progress'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            'Start',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              _updateLaundryStatus(request.id, 'Ready'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Mark Ready',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoomIssuesTab() {
    final issues = StudentService.getAllRoomIssues();

    if (issues.isEmpty) {
      return _buildEmptyState('No room issues reported', Icons.report_problem);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];

        Color priorityColor;
        switch (issue.priority) {
          case 'Low':
            priorityColor = Colors.green;
            break;
          case 'Medium':
            priorityColor = Colors.orange;
            break;
          case 'High':
            priorityColor = Colors.red;
            break;
          case 'Urgent':
            priorityColor = Colors.purple;
            break;
          default:
            priorityColor = Colors.grey;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.report_problem, color: Colors.red[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        issue.studentName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        issue.priority,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: priorityColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusChip(issue.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Room: ${issue.roomNumber}'),
                Text('Type: ${issue.issueType}'),
                Text('Description: ${issue.description}'),
                Text('Reported: ${_formatDate(issue.reportedDate)}'),
                if (issue.adminResponse != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Admin Response: ${issue.adminResponse}'),
                  ),
                ],
                if (issue.status == 'Open') ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _respondToIssue(issue.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            'Respond',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _resolveIssue(issue.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Resolve',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildComplaintsTab() {
    final complaints = ComplaintService.getAllComplaints();

    if (complaints.isEmpty) {
      return _buildEmptyState('No complaints submitted', Icons.feedback);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        final complaint = complaints[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.feedback, color: Colors.orange[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        complaint.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildStatusChip(complaint.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Room: ${complaint.roomNumber}'),
                Text('Category: ${complaint.category}'),
                Text('Priority: ${complaint.priority}'),
                Text('Description: ${complaint.description}'),
                Text('Submitted: ${_formatDate(complaint.submittedDate)}'),
                if (complaint.response != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Response: ${complaint.response}'),
                  ),
                ],
                if (complaint.status == 'Pending') ...[
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _respondToComplaint(complaint.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Respond',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
      case 'open':
        color = Colors.orange;
        break;
      case 'approved':
      case 'resolved':
      case 'ready':
        color = Colors.green;
        break;
      case 'rejected':
      case 'closed':
        color = Colors.red;
        break;
      case 'in progress':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _updateLeaveRequest(String id, String status) {
    StudentService.updateLeaveRequestStatus(id, status);
    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Leave request $status')));
  }

  void _approveRoomBooking(RoomBooking booking) {
    // Here you would normally update the student's room number
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Room booking approved for ${booking.requestedRoom}'),
      ),
    );
  }

  void _rejectRoomBooking(String id) {
    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Room booking rejected')));
  }

  void _updateLaundryStatus(String id, String status) {
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Laundry status updated to $status')),
    );
  }

  void _respondToIssue(String issueId) {
    _showResponseDialog('Respond to Issue', (response) {
      StudentService.updateRoomIssueStatus(
        issueId,
        'In Progress',
        adminResponse: response,
      );
      setState(() {});
    });
  }

  void _resolveIssue(String issueId) {
    _showResponseDialog('Resolve Issue', (response) {
      StudentService.updateRoomIssueStatus(
        issueId,
        'Resolved',
        adminResponse: response,
      );
      setState(() {});
    });
  }

  void _respondToComplaint(String complaintId) {
    _showResponseDialog('Respond to Complaint', (response) {
      ComplaintService.updateComplaintStatus(
        complaintId,
        'Resolved',
        response: response,
      );
      setState(() {});
    });
  }

  void _showResponseDialog(String title, Function(String) onSubmit) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter your response...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSubmit(controller.text.trim());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Response submitted')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
