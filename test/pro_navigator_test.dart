import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pro_navigator/pro_navigator.dart';

void main() {
  testWidgets('push opens the provided page', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Builder(builder: _HomePage.new)),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Details'), findsOneWidget);
  });
}

class _HomePage extends StatelessWidget {
  const _HomePage(this.context);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        ProNavigator.push(context, const Scaffold(body: Text('Details')));
      },
      child: const Text('Open'),
    );
  }
}
