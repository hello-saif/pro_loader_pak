import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pro_loader/pro_loader.dart';

void main() {
  test('ProLoaderType has 50 loaders', () {
    expect(ProLoaderType.values.length, 50);
  });

  testWidgets('ProLoader renders every loader type', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Wrap(
          children: [
            for (final type in ProLoaderType.values)
              ProLoader(type: type, size: 32),
          ],
        ),
      ),
    );

    expect(find.byType(ProLoader), findsNWidgets(50));
  });

  testWidgets('ProLoadingButton swaps child with loader', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProLoadingButton(
          isLoading: true,
          onPressed: () {},
          child: const Text('Submit'),
        ),
      ),
    );

    expect(find.byType(ProLoader), findsOneWidget);
    expect(find.text('Submit'), findsNothing);
  });

  testWidgets('ProLoaderOverlay shows and hides loader', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => ProLoaderOverlay.show(context),
              child: const Text('Show'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();

    expect(ProLoaderOverlay.isShowing, isTrue);
    expect(find.byType(ProLoader), findsOneWidget);

    ProLoaderOverlay.hide();
    await tester.pump();

    expect(ProLoaderOverlay.isShowing, isFalse);
    expect(find.byType(ProLoader), findsNothing);
  });
}
