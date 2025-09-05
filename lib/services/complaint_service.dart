class ComplaintData {
  final String id;
  final String name;
  final String roomNumber;
  final String email;
  final String phone;
  final String category;
  final String priority;
  final String description;
  final DateTime submittedDate;
  final String status;
  final DateTime? resolvedDate;
  final String? response;

  ComplaintData({
    required this.id,
    required this.name,
    required this.roomNumber,
    required this.email,
    required this.phone,
    required this.category,
    required this.priority,
    required this.description,
    required this.submittedDate,
    this.status = 'Pending',
    this.resolvedDate,
    this.response,
  });

  ComplaintData copyWith({
    String? status,
    DateTime? resolvedDate,
    String? response,
  }) {
    return ComplaintData(
      id: id,
      name: name,
      roomNumber: roomNumber,
      email: email,
      phone: phone,
      category: category,
      priority: priority,
      description: description,
      submittedDate: submittedDate,
      status: status ?? this.status,
      resolvedDate: resolvedDate ?? this.resolvedDate,
      response: response ?? this.response,
    );
  }
}

class ComplaintService {
  static final List<ComplaintData> _complaints = [];

  static List<ComplaintData> getAllComplaints() {
    // Sort by submission date (newest first)
    _complaints.sort((a, b) => b.submittedDate.compareTo(a.submittedDate));
    return List.from(_complaints);
  }

  static void addComplaint(ComplaintData complaint) {
    _complaints.insert(0, complaint);
    print('Complaint added: ${complaint.id}'); // Debug log
  }

  static ComplaintData? getComplaintById(String id) {
    try {
      return _complaints.firstWhere((complaint) => complaint.id == id);
    } catch (e) {
      return null;
    }
  }

  static void updateComplaintStatus(
    String id,
    String status, {
    String? response,
  }) {
    final index = _complaints.indexWhere((complaint) => complaint.id == id);
    if (index != -1) {
      _complaints[index] = _complaints[index].copyWith(
        status: status,
        response: response,
        resolvedDate: status == 'Resolved' ? DateTime.now() : null,
      );
    }
  }

  static String generateComplaintId() {
    return 'CMP-${DateTime.now().millisecondsSinceEpoch}';
  }

  static int getComplaintCount() {
    return _complaints.length;
  }

  static int getPendingComplaintCount() {
    return _complaints.where((c) => c.status == 'Pending').length;
  }

  static List<ComplaintData> getComplaintsByStatus(String status) {
    return _complaints.where((c) => c.status == status).toList();
  }

  static List<ComplaintData> getRecentComplaints({int limit = 5}) {
    final sorted = List<ComplaintData>.from(_complaints);
    sorted.sort((a, b) => b.submittedDate.compareTo(a.submittedDate));
    return sorted.take(limit).toList();
  }
}
