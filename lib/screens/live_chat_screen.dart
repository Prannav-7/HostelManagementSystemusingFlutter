import 'package:flutter/material.dart';

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Hello! Welcome to Grand Plaza Hotel support. How can I assist you today?',
      isFromSupport: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      senderName: 'Sarah (Support)',
    ),
  ];

  bool _isTyping = false;
  bool _isOnline = true;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Chat Support',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _isOnline ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _isOnline ? 'Support Online' : 'Support Offline',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.green[700],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: _makePhoneCall,
            tooltip: 'Call Support',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'history',
                  child: Row(
                    children: [
                      Icon(Icons.history, size: 20),
                      SizedBox(width: 8),
                      Text('Chat History'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'email',
                  child: Row(
                    children: [
                      Icon(Icons.email, size: 20),
                      SizedBox(width: 8),
                      Text('Email Transcript'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'end',
                  child: Row(
                    children: [
                      Icon(Icons.call_end, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('End Chat', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Actions Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              border: Border(bottom: BorderSide(color: Colors.green[200]!)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickActionChip('Room Service', Icons.room_service),
                  _buildQuickActionChip(
                    'Housekeeping',
                    Icons.cleaning_services,
                  ),
                  _buildQuickActionChip('Billing', Icons.receipt),
                  _buildQuickActionChip('Facilities', Icons.pool),
                  _buildQuickActionChip('Emergency', Icons.emergency),
                ],
              ),
            ),
          ),

          // Chat Messages
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[100]),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return _buildTypingIndicator();
                  }
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.green[600]),
                  onPressed: _attachFile,
                  tooltip: 'Attach File',
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.green[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: Colors.green[500]!,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  onPressed: _sendMessage,
                  backgroundColor: Colors.green[600],
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(icon, size: 16, color: Colors.green[700]),
        label: Text(label),
        onPressed: () => _sendQuickMessage(label),
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.green[300]!),
        labelStyle: TextStyle(color: Colors.green[700]),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isFromUser = !message.isFromSupport;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isFromUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isFromUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green[600],
              child: const Icon(
                Icons.support_agent,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isFromUser ? Colors.green[600] : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isFromUser
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: isFromUser
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isFromUser && message.senderName != null) ...[
                    Text(
                      message.senderName!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isFromUser ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: isFromUser ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFromUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[600],
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.green[600],
            child: const Icon(
              Icons.support_agent,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                20,
              ).copyWith(bottomLeft: const Radius.circular(4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey[500],
        shape: BoxShape.circle,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isFromSupport: false,
          timestamp: DateTime.now(),
        ),
      );
      _messageController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate support response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(
            ChatMessage(
              text: _generateSupportResponse(text),
              isFromSupport: true,
              timestamp: DateTime.now(),
              senderName: 'Sarah (Support)',
            ),
          );
        });
        _scrollToBottom();
      }
    });
  }

  void _sendQuickMessage(String category) {
    final text = 'I need help with $category';
    _messageController.text = text;
    _sendMessage();
  }

  String _generateSupportResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('room service')) {
      return 'I can help you with room service. What specific assistance do you need? I can help with ordering food, requesting amenities, or resolving any issues with your recent order.';
    } else if (lowerMessage.contains('housekeeping')) {
      return 'I\'ll connect you with our housekeeping team. Are you requesting additional cleaning, fresh towels, or reporting an issue with your room\'s cleanliness?';
    } else if (lowerMessage.contains('billing') ||
        lowerMessage.contains('payment')) {
      return 'I can assist with billing inquiries. Are you looking to review charges, dispute a charge, or need help with payment methods?';
    } else if (lowerMessage.contains('emergency')) {
      return 'For emergencies, please call our emergency line immediately at +1 (555) 123-4567. For non-urgent matters, I\'m here to help. What do you need assistance with?';
    } else if (lowerMessage.contains('wifi') ||
        lowerMessage.contains('internet')) {
      return 'I can help with WiFi issues. The hotel WiFi network is "GrandPlaza_Guest". Are you having trouble connecting or experiencing slow speeds?';
    } else if (lowerMessage.contains('checkout') ||
        lowerMessage.contains('check out')) {
      return 'Checkout time is 11:00 AM. If you need a late checkout, I can request that for you. Would you like me to check availability for your room?';
    } else {
      return 'Thank you for your message. I understand you need assistance. Let me connect you with the appropriate department or provide more specific help. Could you please provide more details about your request?';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _attachFile() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Attach File',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Colors.blue),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _handleFileAttachment('Camera');
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _handleFileAttachment('Gallery');
                },
              ),
              ListTile(
                leading: const Icon(Icons.description, color: Colors.orange),
                title: const Text('Document'),
                onTap: () {
                  Navigator.pop(context);
                  _handleFileAttachment('Document');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleFileAttachment(String type) {
    setState(() {
      _messages.add(
        ChatMessage(
          text: '📎 Attachment sent: $type',
          isFromSupport: false,
          timestamp: DateTime.now(),
        ),
      );
    });

    _scrollToBottom();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text:
                  'I\'ve received your attachment. Thank you for providing this information. I\'ll review it and get back to you shortly.',
              isFromSupport: true,
              timestamp: DateTime.now(),
              senderName: 'Sarah (Support)',
            ),
          );
        });
        _scrollToBottom();
      }
    });
  }

  void _makePhoneCall() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Call Support'),
          content: const Text(
            'Would you like to call our support team?\n\nPhone: +1 (555) 123-4567\nAvailable: 24/7',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dialing support number...'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Call Now'),
            ),
          ],
        );
      },
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'history':
        _showChatHistory();
        break;
      case 'email':
        _emailTranscript();
        break;
      case 'end':
        _endChat();
        break;
    }
  }

  void _showChatHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat history feature coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _emailTranscript() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Transcript'),
          content: const Text(
            'Would you like to email a copy of this chat transcript to your registered email address?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat transcript sent to your email'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _endChat() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('End Chat'),
          content: const Text(
            'Are you sure you want to end this chat session?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to home
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat session ended. Thank you!'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('End Chat'),
            ),
          ],
        );
      },
    );
  }
}

class ChatMessage {
  final String text;
  final bool isFromSupport;
  final DateTime timestamp;
  final String? senderName;

  ChatMessage({
    required this.text,
    required this.isFromSupport,
    required this.timestamp,
    this.senderName,
  });
}
