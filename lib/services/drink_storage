import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/drink_entry.dart';

/// Saves and loads the drink history permanently using SharedPreferences.
class DrinkStorage {
  static const String _key = 'drink_entries';

  Future<List<DrinkEntry>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) => DrinkEntry.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Corrupted data: start fresh instead of crashing the app.
      return [];
    }
  }

  Future<void> save(List<DrinkEntry> drinks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(drinks.map((d) => d.toJson()).toList()));
  }
}
