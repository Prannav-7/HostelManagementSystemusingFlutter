import 'dart:convert';
import 'package:crypto/crypto.dart';

class Student {
  final String studentId;
  final String name;
  final String email;
  final String phoneNumber;
  final String roomNumber;
  final DateTime dateAdded;
  final String passwordHash;

  Student({
    required this.studentId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.roomNumber,
    required this.dateAdded,
    required this.passwordHash,
  });

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'roomNumber': roomNumber,
      'dateAdded': dateAdded.toIso8601String(),
      'passwordHash': passwordHash,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      roomNumber: json['roomNumber'],
      dateAdded: DateTime.parse(json['dateAdded']),
      passwordHash: json['passwordHash'],
    );
  }
}

class LeaveRequest {
  final String id;
  final String studentId;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status;
  final DateTime submittedDate;
  final String? adminComments;

  LeaveRequest({
    required this.id,
    required this.studentId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.submittedDate,
    this.adminComments,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'reason': reason,
      'status': status,
      'submittedDate': submittedDate.toIso8601String(),
      'adminComments': adminComments,
    };
  }

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'],
      studentId: json['studentId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      reason: json['reason'],
      status: json['status'],
      submittedDate: DateTime.parse(json['submittedDate']),
      adminComments: json['adminComments'],
    );
  }
}

class RoomBooking {
  final String id;
  final String studentId;
  final String currentRoom;
  final String requestedRoom;
  final String reason;
  final String status;
  final DateTime requestDate;

  RoomBooking({
    required this.id,
    required this.studentId,
    required this.currentRoom,
    required this.requestedRoom,
    required this.reason,
    required this.status,
    required this.requestDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'currentRoom': currentRoom,
      'requestedRoom': requestedRoom,
      'reason': reason,
      'status': status,
      'requestDate': requestDate.toIso8601String(),
    };
  }

  factory RoomBooking.fromJson(Map<String, dynamic> json) {
    return RoomBooking(
      id: json['id'],
      studentId: json['studentId'],
      currentRoom: json['currentRoom'],
      requestedRoom: json['requestedRoom'],
      reason: json['reason'],
      status: json['status'],
      requestDate: DateTime.parse(json['requestDate']),
    );
  }
}

class LaundryRequest {
  final String id;
  final String studentId;
  final String studentName;
  final String roomNumber;
  final String serviceType;
  final DateTime pickupDate;
  final String pickupTime;
  final List<String> items;
  final String specialInstructions;
  final String status;
  final DateTime requestDate;
  final double? cost;

  LaundryRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.roomNumber,
    required this.serviceType,
    required this.pickupDate,
    required this.pickupTime,
    required this.items,
    required this.specialInstructions,
    required this.status,
    required this.requestDate,
    this.cost,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'roomNumber': roomNumber,
      'serviceType': serviceType,
      'pickupDate': pickupDate.toIso8601String(),
      'pickupTime': pickupTime,
      'items': items,
      'specialInstructions': specialInstructions,
      'status': status,
      'requestDate': requestDate.toIso8601String(),
      'cost': cost,
    };
  }
}

class RoomIssue {
  final String id;
  final String studentId;
  final String studentName;
  final String roomNumber;
  final String issueType;
  final String priority;
  final String description;
  final DateTime reportedDate;
  final String status;
  final String? adminResponse;
  final DateTime? resolvedDate;

  RoomIssue({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.roomNumber,
    required this.issueType,
    required this.priority,
    required this.description,
    required this.reportedDate,
    required this.status,
    this.adminResponse,
    this.resolvedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'roomNumber': roomNumber,
      'issueType': issueType,
      'priority': priority,
      'description': description,
      'reportedDate': reportedDate.toIso8601String(),
      'status': status,
      'adminResponse': adminResponse,
      'resolvedDate': resolvedDate?.toIso8601String(),
    };
  }
}

class StudentService {
  static final Map<String, Student> _students = {};
  static final Map<String, LeaveRequest> _leaveRequests = {};
  static final Map<String, RoomBooking> _roomBookings = {};
  static final Map<String, LaundryRequest> _laundryRequests = {};
  static final Map<String, RoomIssue> _roomIssues = {};
  static Student? _currentStudent;

  static Future<void> init() async {
    // Initialize service - no sample data
    // Students will be added by admin only
  }

  static String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static List<Student> getAllStudents() {
    return _students.values.toList();
  }

  static Future<bool> addStudent(Student student, String password) async {
    try {
      // Check if student ID already exists
      if (_students.containsKey(student.studentId)) {
        return false;
      }

      final hashedPassword = _hashPassword(password);
      final newStudent = Student(
        studentId: student.studentId,
        name: student.name,
        email: student.email,
        phoneNumber: student.phoneNumber,
        roomNumber: student.roomNumber,
        dateAdded: student.dateAdded,
        passwordHash: hashedPassword,
      );

      _students[student.studentId] = newStudent;
      return true;
    } catch (e) {
      print('Error adding student: $e');
      return false;
    }
  }

  static Future<Student?> authenticateStudent(
    String email,
    String password,
  ) async {
    try {
      final hashedPassword = _hashPassword(password);
      for (var student in _students.values) {
        if (student.email == email && student.passwordHash == hashedPassword) {
          _currentStudent = student;
          return student;
        }
      }
      return null;
    } catch (e) {
      print('Error authenticating student: $e');
      return null;
    }
  }

  static Student? getCurrentStudent() {
    return _currentStudent;
  }

  static void signOut() {
    _currentStudent = null;
  }

  static Future<void> deleteStudent(String studentId) async {
    _students.remove(studentId);
  }

  static Future<bool> updateStudent({
    required String studentId,
    required String name,
    required String email,
    required String phoneNumber,
    required String roomNumber,
    String? password,
  }) async {
    try {
      final existingStudent = _students[studentId];
      if (existingStudent == null) {
        return false;
      }

      // Use existing password if no new password provided
      final passwordHash = password != null
          ? _hashPassword(password)
          : existingStudent.passwordHash;

      final updatedStudent = Student(
        studentId: studentId,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        roomNumber: roomNumber,
        dateAdded: existingStudent.dateAdded,
        passwordHash: passwordHash,
      );

      _students[studentId] = updatedStudent;

      // Update current student if it's the one being edited
      if (_currentStudent?.studentId == studentId) {
        _currentStudent = updatedStudent;
      }

      return true;
    } catch (e) {
      print('Error updating student: $e');
      return false;
    }
  }

  static Student? getStudentById(String studentId) {
    return _students[studentId];
  }

  // Leave Request Methods
  static Future<String> submitLeaveRequest({
    required String studentId,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    final id = 'LR${DateTime.now().millisecondsSinceEpoch}';
    final leaveRequest = LeaveRequest(
      id: id,
      studentId: studentId,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
      status: 'Pending',
      submittedDate: DateTime.now(),
    );

    _leaveRequests[id] = leaveRequest;
    return id;
  }

  static List<LeaveRequest> getLeaveRequestsForStudent(String studentId) {
    return _leaveRequests.values
        .where((request) => request.studentId == studentId)
        .toList();
  }

  static List<LeaveRequest> getAllLeaveRequests() {
    return _leaveRequests.values.toList();
  }

  // Room Booking Methods
  static Future<String> submitRoomBooking({
    required String studentId,
    required String currentRoom,
    required String requestedRoom,
    required String reason,
  }) async {
    final id = 'RB${DateTime.now().millisecondsSinceEpoch}';
    final booking = RoomBooking(
      id: id,
      studentId: studentId,
      currentRoom: currentRoom,
      requestedRoom: requestedRoom,
      reason: reason,
      status: 'Pending',
      requestDate: DateTime.now(),
    );

    _roomBookings[id] = booking;
    return id;
  }

  static List<RoomBooking> getRoomBookingsForStudent(String studentId) {
    return _roomBookings.values
        .where((booking) => booking.studentId == studentId)
        .toList();
  }

  static List<String> getAvailableRooms() {
    // This would typically query a room database
    return [
      'A-101',
      'A-102',
      'A-103',
      'A-201',
      'A-202',
      'A-203',
      'B-101',
      'B-102',
      'B-103',
      'B-201',
      'B-202',
      'B-203',
      'C-101',
      'C-102',
      'C-103',
      'C-201',
      'C-202',
      'C-203',
    ];
  }

  // Statistics
  static int getTotalStudents() {
    return _students.length;
  }

  static int getPendingLeaveRequests() {
    return _leaveRequests.values
        .where((request) => request.status == 'Pending')
        .length;
  }

  static int getPendingRoomBookings() {
    return _roomBookings.values
        .where((booking) => booking.status == 'Pending')
        .length;
  }

  // Laundry Service Methods
  static Future<String> submitLaundryRequest({
    required String studentId,
    required String serviceType,
    required DateTime pickupDate,
    required String pickupTime,
    required List<String> items,
    required String specialInstructions,
  }) async {
    final student = getStudentById(studentId);
    if (student == null) return '';

    final id = 'LR${DateTime.now().millisecondsSinceEpoch}';
    final request = LaundryRequest(
      id: id,
      studentId: studentId,
      studentName: student.name,
      roomNumber: student.roomNumber,
      serviceType: serviceType,
      pickupDate: pickupDate,
      pickupTime: pickupTime,
      items: items,
      specialInstructions: specialInstructions,
      status: 'Pending',
      requestDate: DateTime.now(),
      cost: _calculateLaundryCost(serviceType, items),
    );

    _laundryRequests[id] = request;
    return id;
  }

  static double _calculateLaundryCost(String serviceType, List<String> items) {
    double baseCost = serviceType == 'Express' ? 15.0 : 8.0;
    return baseCost * items.length;
  }

  static List<LaundryRequest> getLaundryRequestsForStudent(String studentId) {
    return _laundryRequests.values
        .where((request) => request.studentId == studentId)
        .toList();
  }

  static List<LaundryRequest> getAllLaundryRequests() {
    return _laundryRequests.values.toList();
  }

  // Room Issues Methods
  static Future<String> submitRoomIssue({
    required String studentId,
    required String issueType,
    required String priority,
    required String description,
  }) async {
    final student = getStudentById(studentId);
    if (student == null) return '';

    final id = 'RI${DateTime.now().millisecondsSinceEpoch}';
    final issue = RoomIssue(
      id: id,
      studentId: studentId,
      studentName: student.name,
      roomNumber: student.roomNumber,
      issueType: issueType,
      priority: priority,
      description: description,
      reportedDate: DateTime.now(),
      status: 'Open',
    );

    _roomIssues[id] = issue;
    return id;
  }

  static List<RoomIssue> getRoomIssuesForStudent(String studentId) {
    return _roomIssues.values
        .where((issue) => issue.studentId == studentId)
        .toList();
  }

  static List<RoomIssue> getAllRoomIssues() {
    return _roomIssues.values.toList();
  }

  // Admin Methods for all requests
  static List<RoomBooking> getAllRoomBookings() {
    return _roomBookings.values.toList();
  }

  static void updateLeaveRequestStatus(
    String id,
    String status, {
    String? adminComments,
  }) {
    if (_leaveRequests.containsKey(id)) {
      final request = _leaveRequests[id]!;
      _leaveRequests[id] = LeaveRequest(
        id: request.id,
        studentId: request.studentId,
        startDate: request.startDate,
        endDate: request.endDate,
        reason: request.reason,
        status: status,
        submittedDate: request.submittedDate,
        adminComments: adminComments,
      );
    }
  }

  static void updateRoomIssueStatus(
    String id,
    String status, {
    String? adminResponse,
  }) {
    if (_roomIssues.containsKey(id)) {
      final issue = _roomIssues[id]!;
      _roomIssues[id] = RoomIssue(
        id: issue.id,
        studentId: issue.studentId,
        studentName: issue.studentName,
        roomNumber: issue.roomNumber,
        issueType: issue.issueType,
        priority: issue.priority,
        description: issue.description,
        reportedDate: issue.reportedDate,
        status: status,
        adminResponse: adminResponse,
        resolvedDate: status == 'Resolved' ? DateTime.now() : null,
      );
    }
  }

  // Enhanced Statistics
  static int getPendingLaundryRequests() {
    return _laundryRequests.values
        .where((request) => request.status == 'Pending')
        .length;
  }

  static int getOpenRoomIssues() {
    return _roomIssues.values.where((issue) => issue.status == 'Open').length;
  }
}
