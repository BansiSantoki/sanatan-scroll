import 'package:flutter_test/flutter_test.dart';
import 'package:sanatan_scroll/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const SanatanScrollApp(),
    );
    await tester.pump();
    expect(find.text('Sanatan Scroll'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });
}
