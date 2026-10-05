import 'package:flutter_test/flutter_test.dart';
import 'package:nadiku/main.dart';

void main() {
  testWidgets('VidyaMedic app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VidyaMedicApp());
    expect(find.text('VidyaMedic'), findsWidgets);
  });
}
