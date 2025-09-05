import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessMenuScreen extends StatefulWidget {
  const MessMenuScreen({super.key});

  @override
  State<MessMenuScreen> createState() => _MessMenuScreenState();
}

class _MessMenuScreenState extends State<MessMenuScreen> {
  DateTime selectedDate = DateTime.now();

  // Weekly menu data
  Map<String, Map<String, Map<String, List<String>>>> weeklyMenu = {
    'Monday': {
      'Breakfast': {
        'Main': ['Idli', 'Sambar', 'Coconut Chutney'],
        'Beverages': ['Tea', 'Coffee', 'Milk'],
        'Extras': ['Boiled Eggs', 'Bread', 'Butter'],
      },
      'Lunch': {
        'Main': ['Rice', 'Dal', 'Vegetable Curry', 'Chapati'],
        'Sides': ['Pickle', 'Yogurt', 'Papad'],
        'Extras': ['Chicken Curry', 'Fish Fry'],
      },
      'Dinner': {
        'Main': ['Rice', 'Rasam', 'Dry Vegetable', 'Chapati'],
        'Sides': ['Pickle', 'Yogurt'],
        'Extras': ['Egg Curry', 'Chicken Biryani'],
      },
    },
    'Tuesday': {
      'Breakfast': {
        'Main': ['Dosa', 'Sambar', 'Tomato Chutney'],
        'Beverages': ['Tea', 'Coffee', 'Milk'],
        'Extras': ['Boiled Eggs', 'Bread', 'Jam'],
      },
      'Lunch': {
        'Main': ['Rice', 'Dal', 'Mixed Vegetable', 'Chapati'],
        'Sides': ['Pickle', 'Buttermilk', 'Papad'],
        'Extras': ['Mutton Curry', 'Fish Curry'],
      },
      'Dinner': {
        'Main': ['Rice', 'Vegetable Sambar', 'Beans Curry', 'Chapati'],
        'Sides': ['Pickle', 'Yogurt'],
        'Extras': ['Chicken Fry', 'Egg Biryani'],
      },
    },
    'Wednesday': {
      'Breakfast': {
        'Main': ['Upma', 'Coconut Chutney', 'Pickle'],
        'Beverages': ['Tea', 'Coffee', 'Milk'],
        'Extras': ['Boiled Eggs', 'Bread', 'Butter'],
      },
      'Lunch': {
        'Main': ['Rice', 'Dal', 'Cabbage Curry', 'Chapati'],
        'Sides': ['Pickle', 'Yogurt', 'Papad'],
        'Extras': ['Chicken Curry', 'Prawn Curry'],
      },
      'Dinner': {
        'Main': ['Rice', 'Rasam', 'Potato Curry', 'Chapati'],
        'Sides': ['Pickle', 'Buttermilk'],
        'Extras': ['Fish Fry', 'Mutton Biryani'],
      },
    },
    'Thursday': {
      'Breakfast': {
        'Main': ['Poha', 'Boiled Peanuts', 'Lime'],
        'Beverages': ['Tea', 'Coffee', 'Milk'],
        'Extras': ['Boiled Eggs', 'Bread', 'Jam'],
      },
      'Lunch': {
        'Main': ['Rice', 'Dal', 'Okra Curry', 'Chapati'],
        'Sides': ['Pickle', 'Yogurt', 'Papad'],
        'Extras': ['Chicken Curry', 'Fish Curry'],
      },
      'Dinner': {
        'Main': ['Rice', 'Tomato Rasam', 'Drumstick Curry', 'Chapati'],
        'Sides': ['Pickle', 'Yogurt'],
        'Extras': ['Egg Curry', 'Chicken Biryani'],
      },
    },
    'Friday': {
      'Breakfast': {
        'Main': ['Idli', 'Vada', 'Sambar', 'Coconut Chutney'],
        'Beverages': ['Tea', 'Coffee', 'Milk'],
        'Extras': ['Boiled Eggs', 'Bread', 'Butter'],
      },
      'Lunch': {
        'Main': ['Rice', 'Dal', 'Brinjal Curry', 'Chapati'],
        'Sides': ['Pickle', 'Buttermilk', 'Papad'],
        'Extras': ['Mutton Curry', 'Prawn Fry'],
      },
      'Dinner': {
        'Main': ['Rice', 'Vegetable Sambar', 'Carrot Beans', 'Chapati'],
        'Sides': ['Pickle', 'Yogurt'],
        'Extras': ['Fish Curry', 'Egg Biryani'],
      },
    },
    'Saturday': {
      'Breakfast': {
        'Main': ['Dosa', 'Uttapam', 'Sambar', 'Tomato Chutney'],
        'Beverages': ['Tea', 'Coffee', 'Milk'],
        'Extras': ['Boiled Eggs', 'Bread', 'Jam'],
      },
      'Lunch': {
        'Main': ['Rice', 'Dal', 'Cauliflower Curry', 'Chapati'],
        'Sides': ['Pickle', 'Yogurt', 'Papad'],
        'Extras': ['Chicken Curry', 'Fish Fry'],
      },
      'Dinner': {
        'Main': ['Rice', 'Rasam', 'Mixed Vegetable', 'Chapati'],
        'Sides': ['Pickle', 'Buttermilk'],
        'Extras': ['Mutton Fry', 'Chicken Biryani'],
      },
    },
    'Sunday': {
      'Breakfast': {
        'Main': ['Puri', 'Chole', 'Pickle'],
        'Beverages': ['Tea', 'Coffee', 'Milk'],
        'Extras': ['Boiled Eggs', 'Bread', 'Butter'],
      },
      'Lunch': {
        'Main': ['Rice', 'Dal', 'Special Curry', 'Chapati'],
        'Sides': ['Pickle', 'Yogurt', 'Papad'],
        'Extras': ['Special Chicken', 'Fish Curry'],
      },
      'Dinner': {
        'Main': ['Rice', 'Sambar', 'Vegetable Curry', 'Chapati'],
        'Sides': ['Pickle', 'Yogurt'],
        'Extras': ['Egg Curry', 'Special Biryani'],
      },
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mess Menu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: _selectDate,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Selection Card
            Card(
              color: Colors.indigo[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.restaurant, color: Colors.indigo[600], size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE').format(selectedDate),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo[700],
                            ),
                          ),
                          Text(
                            DateFormat('MMMM dd, yyyy').format(selectedDate),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.indigo[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isToday())
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Menu for selected day
            ..._buildMenuForDay(),

            const SizedBox(height: 24),

            // Mess Timings Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.indigo[600]),
                        const SizedBox(width: 8),
                        const Text(
                          'Mess Timings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTimingRow(
                      'Breakfast',
                      '7:00 AM - 9:30 AM',
                      Icons.breakfast_dining,
                    ),
                    _buildTimingRow(
                      'Lunch',
                      '12:30 PM - 2:30 PM',
                      Icons.lunch_dining,
                    ),
                    _buildTimingRow(
                      'Dinner',
                      '7:30 PM - 9:30 PM',
                      Icons.dinner_dining,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Mess Rules Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.rule, color: Colors.indigo[600]),
                        const SizedBox(width: 8),
                        const Text(
                          'Mess Rules',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildRuleItem('• Carry your mess card at all times'),
                    _buildRuleItem('• No outside food in the mess'),
                    _buildRuleItem('• Clean your plate after eating'),
                    _buildRuleItem('• Maintain silence during meals'),
                    _buildRuleItem('• Report any issues to mess committee'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMenuForDay() {
    String dayName = DateFormat('EEEE').format(selectedDate);
    Map<String, Map<String, List<String>>>? dayMenu = weeklyMenu[dayName];

    if (dayMenu == null) {
      return [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Icon(Icons.no_meals, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No menu available for this day',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    List<Widget> mealCards = [];

    dayMenu.forEach((mealType, mealData) {
      mealCards.add(_buildMealCard(mealType, mealData));
      mealCards.add(const SizedBox(height: 16));
    });

    return mealCards;
  }

  Widget _buildMealCard(String mealType, Map<String, List<String>> mealData) {
    IconData mealIcon;
    Color mealColor;

    switch (mealType) {
      case 'Breakfast':
        mealIcon = Icons.breakfast_dining;
        mealColor = Colors.orange[600]!;
        break;
      case 'Lunch':
        mealIcon = Icons.lunch_dining;
        mealColor = Colors.green[600]!;
        break;
      case 'Dinner':
        mealIcon = Icons.dinner_dining;
        mealColor = Colors.purple[600]!;
        break;
      default:
        mealIcon = Icons.restaurant;
        mealColor = Colors.grey[600]!;
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(mealIcon, color: mealColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  mealType,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: mealColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: mealColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getMealTime(mealType),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: mealColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...mealData.entries.map(
              (entry) => _buildMealSection(entry.key, entry.value, mealColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSection(
    String sectionName,
    List<String> items,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: items.map((item) => _buildMenuItem(item)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        item,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTimingRow(String meal, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              '$meal:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String rule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        rule,
        style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4),
      ),
    );
  }

  String _getMealTime(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return '7:00 - 9:30 AM';
      case 'Lunch':
        return '12:30 - 2:30 PM';
      case 'Dinner':
        return '7:30 - 9:30 PM';
      default:
        return '';
    }
  }

  bool _isToday() {
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
