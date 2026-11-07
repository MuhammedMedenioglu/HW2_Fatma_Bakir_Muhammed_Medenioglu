import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home_controller/main.dart';

void main() {
  testWidgets('Device controls update status without creating more devices', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 780));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const SmartHomeApp());

    expect(find.text('Total Devices: 3'), findsOneWidget);
    expect(find.text('Brightness · 0%'), findsOneWidget);
    expect(find.text('Status: Off'), findsOneWidget);
    expect(find.text('Target · 22 °C'), findsOneWidget);
    expect(find.text('Status: Paused'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(find.text('Brightness · 75%'), findsOneWidget);
    expect(find.text('Status: On'), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(find.text('Status: Off'), findsOneWidget);

    final decrease = find.byWidgetPredicate(
      (widget) =>
          widget is IconButton && widget.tooltip == 'Decrease temperature',
    );
    final increase = find.byTooltip('Increase temperature');
    await tester.tap(increase);
    await tester.pumpAndSettle();
    expect(find.text('Target · 23 °C'), findsOneWidget);
    for (var step = 0; step < 7; step++) {
      await tester.tap(decrease);
      await tester.pumpAndSettle();
    }
    expect(find.text('Target · 16 °C'), findsOneWidget);
    expect(find.text('Status: Cooling'), findsOneWidget);
    expect(tester.widget<IconButton>(decrease).onPressed, isNull);

    await tester.tap(find.byTooltip('Play speaker'));
    await tester.pumpAndSettle();
    expect(find.text('Status: Playing'), findsOneWidget);
    await tester.tap(find.byTooltip('Pause speaker'));
    await tester.pumpAndSettle();
    expect(find.text('Status: Paused'), findsOneWidget);
    expect(find.text('Total Devices: 3'), findsOneWidget);
  });
}
