import 'package:flutter/material.dart';
import '../models/drink_entry.dart';

class MonthlyScreen extends StatefulWidget {
  final List<DrinkEntry> drinks;
  final int dailyGoal;
  const MonthlyScreen({super.key, required this.drinks, required this.dailyGoal});

  @override
  State<MonthlyScreen> createState() => _MonthlyScreenState();
}

class _MonthlyScreenState extends State<MonthlyScreen> {
  DateTime shownMonth = DateTime(DateTime.now().year, DateTime.now().month);
  final monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  int waterOn(int day) {
    int total = 0;
    for (final drink in widget.drinks) {
      if (drink.time.year == shownMonth.year && drink.time.month == shownMonth.month && drink.time.day == day) {
        total += drink.amount;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(shownMonth.year, shownMonth.month + 1, 0).day;
    int offset = (DateTime(shownMonth.year, shownMonth.month, 1).weekday - 1);
    int total = 0;
    int goalDays = 0;
    for (int day = 1; day <= daysInMonth; day++) {
      int amount = waterOn(day);
      total += amount;
      if (amount >= widget.dailyGoal) goalDays++;
    }
    double average = total / daysInMonth / 1000;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Monthly Recap', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          Row(
            children: [
              IconButton(onPressed: () => setState(() => shownMonth = DateTime(shownMonth.year, shownMonth.month - 1)), icon: const Icon(Icons.chevron_left)),
              Expanded(child: Text('${monthNames[shownMonth.month - 1]} ${shownMonth.year}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
              IconButton(onPressed: () => setState(() => shownMonth = DateTime(shownMonth.year, shownMonth.month + 1)), icon: const Icon(Icons.chevron_right)),
            ],
          ),
          Text('${(total / 1000).toStringAsFixed(2)} L', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
          const Text('Total water intake', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFE1E1E1), borderRadius: BorderRadius.circular(18)),
            child: Column(
              children: [
                Row(
                  children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((name) => Expanded(child: Center(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold))))).toList(),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 6, childAspectRatio: 1),
                  itemCount: offset + daysInMonth,
                  itemBuilder: (context, index) {
                    if (index < offset) return const SizedBox();
                    int day = index - offset + 1;
                    int amount = waterOn(day);
                    bool completed = amount >= widget.dailyGoal;
                    bool hasDrink = amount > 0;
                    return Container(
                      decoration: BoxDecoration(
                        color: completed ? const Color(0xFF83AFE9) : hasDrink ? const Color(0xFFC6D9F3) : const Color(0xFFF3F3F3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Text('$day', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: statCard('Avg/day', '${average.toStringAsFixed(2)} L', Icons.water_drop_outlined)),
              const SizedBox(width: 9),
              Expanded(child: statCard('Goal', '${(widget.dailyGoal / 1000).toStringAsFixed(1)} L', Icons.star_border)),
              const SizedBox(width: 9),
              Expanded(child: statCard('Goal hit', '$goalDays days', Icons.track_changes)),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: const Color(0xFFE1E1E1), borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Monthly Goal Completion', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 13),
                LinearProgressIndicator(
                  value: (total / (widget.dailyGoal * daysInMonth)).clamp(0.0, 1.0),
                  backgroundColor: Colors.white,
                  color: const Color(0xFF83AFE9),
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 9),
                Text('${(total / (widget.dailyGoal * daysInMonth) * 100).round()}% of your monthly goal'),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFFE1E1E1), borderRadius: BorderRadius.circular(14)),
      child: Column(children: [
        Icon(icon, size: 24),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 11)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ]),
    );
  }
}
