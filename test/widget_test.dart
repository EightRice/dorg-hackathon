import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_dashboard/main.dart';

void main() {
  testWidgets('App renders dashboard shell', (WidgetTester tester) async {
    await tester.pumpWidget(const HackathonDashboardApp());
    expect(find.text('Scoreboard'), findsWidgets);
  });
}
