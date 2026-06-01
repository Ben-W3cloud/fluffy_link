import 'package:fluffy_link/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the upload screen', (tester) async {
    await tester.pumpWidget(const PermaLinkApp());

    expect(find.text('Perma.link'), findsOneWidget);
    expect(find.text('Drop your file here'), findsOneWidget);
    expect(find.text('Browse files'), findsOneWidget);
  });
}
