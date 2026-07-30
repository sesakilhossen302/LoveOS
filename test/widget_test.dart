import 'package:flutter_test/flutter_test.dart';
import 'package:love_os/core/app_state.dart';
import 'package:love_os/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('LoveOS Smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LoveAppState(),
        child: const LoveOSApp(),
      ),
    );
    // Advance timers so periodic loading animation completes
    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(LoveOSApp), findsOneWidget);
  });
}
