// import 'package:flutter_test/flutter_test.dart';

// import 'package:pro_navigator/pro_navigator.dart';

// void main() {
//   test('adds one to input values', () {
//     // final calculator = Calculator();
//     expect(calculator.addOne(2), 3);
//     expect(calculator.addOne(-7), -6);
//     expect(calculator.addOne(0), 1);
//   });
// }

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pro_navigator/pro_navigator.dart';

void main() {
  test('adds one to input values', () {
    testWidgets('push opens the provided page', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Builder(builder: _HomePage.new)),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Details'), findsOneWidget);
    });
  });
}

class _HomePage extends StatelessWidget {
  const _HomePage(this.context);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        ImproNavigator.push(context, const Scaffold(body: Text('Details')));
      },
      child: const Text('Open'),
    );
  }
}
