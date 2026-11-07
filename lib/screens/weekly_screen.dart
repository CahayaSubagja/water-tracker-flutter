import 'package:flutter/material.dart';
import '../models/drink_entry.dart';

class WeeklyScreen extends StatelessWidget {
  final List<DrinkEntry> drinks;
  final int dailyGoal;
  const WeeklyScreen({super.key, required this.drinks, required this.dailyGoal});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    List<int> amounts = [];
    for (int i = 0; i < 7; i++) {
      DateTime day = monday.add(Duration(days: i));
      int total = 0;
      for (DrinkEntry drink in drinks) {
        if (drink.time.year == day.year && drink.time.month == day.month && drink.time.day == day.day) {
          total += drink.amount;
        }
      }
      amounts.add(total);
    }
    int weeklyTotal = amounts.fold(0, (sum, value) => sum + value);
    int bestDay = amounts.reduce((a, b) => a > b ? a : b);
    int daysReached = amounts.where((value) => value >= dailyGoal).length;
    String startDate = '${monday.day}/${monday.month}';
    DateTime sunday = monday.add(const Duration(days: 6));
    String endDate = '${sunday.day}/${sunday.month}/${sunday.year}';
    const weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly Recap', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          Text('$startDate - $endDate', style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          Text('${(weeklyTotal / 1000).toStringAsFixed(2)} L', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
          const Text('Total water intake', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            decoration: BoxDecoration(color: const Color(0xFFE1E1E1), borderRadius: BorderRadius.circular(18)),
            child: SizedBox(
              height: 220,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  double height = (amounts[index] / dailyGoal).clamp(0.0, 1.0).toDouble() * 130;
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${(amounts[index] / 1000).toStringAsFixed(1)}', style: const TextStyle(fontSize: 10)),
                        const SizedBox(height: 5),
                        Container(
                          height: 140,
                          width: 24,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            height: height,
                            decoration: BoxDecoration(color: const Color(0xFF83AFE9), borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(weekdays[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: statCard('Average', '${(weeklyTotal / 7000).toStringAsFixed(2)} L', Icons.water_drop_outlined)),
              const SizedBox(width: 9),
              Expanded(child: statCard('Best day', '${(bestDay / 1000).toStringAsFixed(2)} L', Icons.star_border)),
              const SizedBox(width: 9),
              Expanded(child: statCard('Goal hit', '$daysReached/7', Icons.track_changes)),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: const Color(0xFFE1E1E1), borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Weekly Goal Completion', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                LinearProgressIndicator(
                  value: (weeklyTotal / (dailyGoal * 7)).clamp(0.0, 1.0),
                  backgroundColor: Colors.white,
                  color: const Color(0xFF83AFE9),
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 9),
                Text('${(weeklyTotal / (dailyGoal * 7) * 100).round()}% of your weekly goal'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Center(child: Text('“Stay hydrated, stay on track”', style: TextStyle(color: Colors.black54))),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFFE1E1E1), borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 11)),
          const SizedBox(height: 3),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
