import 'package:flutter/material.dart';
import 'models/drink_entry.dart';
import 'screens/home_screen.dart';
import 'screens/input_screen.dart';
import 'screens/weekly_screen.dart';
import 'screens/monthly_screen.dart';

void main() {
  runApp(const WaterTrackerApp());
}

class WaterTrackerApp extends StatelessWidget {
  const WaterTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Tracker',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F6F8),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF83AFE9)),
        fontFamily: 'Roboto',
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedPage = 0;
  final int dailyGoal = 2000;
  final List<DrinkEntry> drinks = [];

  void addDrink(int amount, DateTime time) {
    setState(() {
      drinks.add(DrinkEntry(amount: amount, time: time));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$amount ml added!')),
    );
  }

  void openInput() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InputScreen(onSave: addDrink),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    if (selectedPage == 0) {
      page = HomeScreen(drinks: drinks, dailyGoal: dailyGoal, onAdd: openInput);
    } else if (selectedPage == 1) {
      page = WeeklyScreen(drinks: drinks, dailyGoal: dailyGoal);
    } else {
      page = MonthlyScreen(drinks: drinks, dailyGoal: dailyGoal);
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      tabButton('D', 0),
                      tabButton('W', 1),
                      tabButton('M', 2),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(child: page),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tabButton(String text, int index) {
    bool active = selectedPage == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPage = index;
        });
      },
      child: Container(
        width: 65,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: active ? Colors.black : Colors.black54),
        ),
      ),
    );
  }
}
