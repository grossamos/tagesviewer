import 'package:flutter_test/flutter_test.dart';
import 'package:tagesviewer/main.dart';

void main() {
  testWidgets('App renders without crashing', (tester) async {
    await tester.pumpWidget(const TagesviewerApp());
    expect(find.text('tagesviewer'), findsOneWidget);
  });
}
