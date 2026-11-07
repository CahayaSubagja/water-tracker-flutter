import 'package:flutter/material.dart';
import '../models/drink_entry.dart';

class HomeScreen extends StatefulWidget {
  final List<DrinkEntry> drinks;
  final int dailyGoal;
  final VoidCallback onAdd;

  const HomeScreen({
    super.key,
    required this.drinks,
    required this.dailyGoal,
    required this.onAdd,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.now();

  bool sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String timeText(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    List<DrinkEntry> todayDrinks = widget.drinks
        .where((drink) => sameDay(drink.time, selectedDay))
        .toList();
    todayDrinks.sort((a, b) => b.time.compareTo(a.time));
    int total = todayDrinks.fold(0, (sum, drink) => sum + drink.amount);
    double progress = (total / widget.dailyGoal).clamp(0.0, 1.0).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Daily Water Tracker', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text('Stay hydrated, stay on track', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 20),
          SizedBox(
            height: 68,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                DateTime day = DateTime.now().subtract(Duration(days: 6 - index));
                bool chosen = sameDay(day, selectedDay);
                const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return GestureDetector(
                  onTap: () => setState(() => selectedDay = day),
                  child: Container(
                    width: 53,
                    margin: const EdgeInsets.only(right: 4),
                    child: Column(
                      children: [
                        Text(names[day.weekday - 1], style: const TextStyle(fontSize: 11)),
                        const SizedBox(height: 6),
                        CircleAvatar(
                          radius: 19,
                          backgroundColor: chosen ? const Color(0xFF83AFE9) : const Color(0xFFE4E4E4),
                          child: Text('${day.day}', style: const TextStyle(color: Colors.black87)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFFE1E1E1), borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Water intake', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 7),
                Text('$total ml / ${widget.dailyGoal} ml', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                LinearProgressIndicator(value: progress, minHeight: 12, borderRadius: BorderRadius.circular(12), color: const Color(0xFF83AFE9), backgroundColor: Colors.white),
                const SizedBox(height: 8),
                Text('${(total / widget.dailyGoal * 100).round()}% of your daily goal', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Drink history', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: todayDrinks.isEmpty
                ? const Center(child: Text('No drinks yet. Tap + Drink to start!', style: TextStyle(color: Colors.black54)))
                : ListView.builder(
                    itemCount: todayDrinks.length,
                    itemBuilder: (context, index) {
                      final drink = todayDrinks[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(color: const Color(0xFFE1E1E1), borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: const Icon(Icons.water_drop_outlined, color: Color(0xFF699EE2)),
                          title: Text(timeText(drink.time), style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text('Water added'),
                          trailing: Text('${drink.amount} ml', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Drink'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF83AFE9), foregroundColor: Colors.black87, padding: const EdgeInsets.all(16)),
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
