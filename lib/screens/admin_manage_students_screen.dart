import 'package:flutter/material.dart';
import 'admin_add_student_screen.dart';
import 'admin_edit_student_screen.dart';
import '../services/student_service.dart';

class AdminManageStudentsScreen extends StatefulWidget {
  const AdminManageStudentsScreen({super.key});

  @override
  State<AdminManageStudentsScreen> createState() =>
      _AdminManageStudentsScreenState();
}

class _AdminManageStudentsScreenState extends State<AdminManageStudentsScreen> {
  List<Student> students = [];
  List<Student> filteredStudents = [];
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'name';
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
    _searchController.addListener(_filterStudents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadStudents() {
    setState(() {
      students = StudentService.getAllStudents();
      filteredStudents = List.from(students);
      _sortStudents();
    });
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredStudents = List.from(students);
      } else {
        filteredStudents = students.where((student) {
          return student.name.toLowerCase().contains(query) ||
              student.email.toLowerCase().contains(query) ||
              student.studentId.toLowerCase().contains(query) ||
              student.roomNumber.toLowerCase().contains(query);
        }).toList();
      }
      _sortStudents();
    });
  }

  void _sortStudents() {
    filteredStudents.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'studentId':
          comparison = a.studentId.compareTo(b.studentId);
          break;
        case 'roomNumber':
          comparison = a.roomNumber.compareTo(b.roomNumber);
          break;
        case 'dateAdded':
          comparison = a.dateAdded.compareTo(b.dateAdded);
          break;
        default:
          comparison = a.name.compareTo(b.name);
      }
      return _isAscending ? comparison : -comparison;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Manage Students',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[700],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadStudents,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _navigateToAddStudent(),
            tooltip: 'Add Student',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search students by name, ID, email, or room...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.indigo[600]!,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Sort Options
                Row(
                  children: [
                    const Text('Sort by: '),
                    DropdownButton<String>(
                      value: _sortBy,
                      onChanged: (value) {
                        setState(() {
                          _sortBy = value!;
                          _sortStudents();
                        });
                      },
                      items: const [
                        DropdownMenuItem(value: 'name', child: Text('Name')),
                        DropdownMenuItem(
                          value: 'studentId',
                          child: Text('Student ID'),
                        ),
                        DropdownMenuItem(
                          value: 'roomNumber',
                          child: Text('Room'),
                        ),
                        DropdownMenuItem(
                          value: 'dateAdded',
                          child: Text('Date Added'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        _isAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: Colors.indigo[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _isAscending = !_isAscending;
                          _sortStudents();
                        });
                      },
                      tooltip: _isAscending ? 'Ascending' : 'Descending',
                    ),
                    const Spacer(),
                    Text(
                      '${filteredStudents.length} students',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Students List
          Expanded(
            child: filteredStudents.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];
                      return _buildStudentCard(student);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddStudent(),
        backgroundColor: Colors.indigo[600],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            students.isEmpty ? Icons.person_add : Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            students.isEmpty
                ? 'No students registered yet'
                : 'No students found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            students.isEmpty
                ? 'Add your first student to get started'
                : 'Try adjusting your search criteria',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          if (students.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddStudent(),
              icon: const Icon(Icons.add),
              label: const Text('Add First Student'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStudentCard(Student student) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showStudentDetails(student),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.indigo[100],
                    radius: 25,
                    child: Text(
                      student.name.isNotEmpty
                          ? student.name[0].toUpperCase()
                          : 'S',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${student.studentId}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, student),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility, size: 20),
                            SizedBox(width: 8),
                            Text('View Details'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(Icons.email, student.email),
                  const SizedBox(width: 12),
                  _buildInfoChip(Icons.phone, student.phoneNumber),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildInfoChip(Icons.bed, 'Room ${student.roomNumber}'),
                  const SizedBox(width: 12),
                  _buildInfoChip(
                    Icons.calendar_today,
                    'Added ${_formatDate(student.dateAdded)}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToAddStudent() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AdminAddStudentScreen()),
    );

    if (result == true) {
      _loadStudents();
    }
  }

  void _handleMenuAction(String action, Student student) {
    switch (action) {
      case 'view':
        _showStudentDetails(student);
        break;
      case 'edit':
        _editStudent(student);
        break;
      case 'delete':
        _deleteStudent(student);
        break;
    }
  }

  void _showStudentDetails(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Student Details - ${student.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Student ID:', student.studentId),
            _buildDetailRow('Name:', student.name),
            _buildDetailRow('Email:', student.email),
            _buildDetailRow('Phone:', student.phoneNumber),
            _buildDetailRow('Room Number:', student.roomNumber),
            _buildDetailRow('Date Added:', _formatDate(student.dateAdded)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _editStudent(Student student) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AdminEditStudentScreen(student: student),
      ),
    );

    // If the student was updated, refresh the list
    if (result == true) {
      _loadStudents();
    }
  }

  void _deleteStudent(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text(
          'Are you sure you want to delete ${student.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              StudentService.deleteStudent(student.studentId);
              Navigator.of(context).pop();
              _loadStudents();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${student.name} has been deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
