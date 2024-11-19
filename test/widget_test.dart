import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ups_monitoring/main.dart'; // ตรวจสอบให้แน่ใจว่าเส้นทางถูกต้อง

void main() {
  testWidgets('Login screen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2)); // จำนวนฟิลด์ข้อความที่คาดไว้
    expect(find.byType(ElevatedButton), findsOneWidget); // จำนวนปุ่มที่คาดไว้
  });

  testWidgets('Login button works', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    await tester.enterText(find.byType(TextField).first, 'testuser');
    await tester.enterText(find.byType(TextField).at(1), 'password123');

    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    // ตรวจสอบหลังจากการเข้าสู่ระบบ
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
