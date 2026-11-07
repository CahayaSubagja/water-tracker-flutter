import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_tracker/main.dart';

void main() {
  testWidgets('Water Tracker opens correctly', (tester) async {
    await tester.pumpWidget(const WaterTrackerApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);
  });
}
