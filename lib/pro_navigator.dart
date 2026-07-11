import 'package:flutter/material.dart';

/// A lightweight navigation helper for Flutter.
///
/// Example:
/// ```dart
/// ProNavigator.push(
///   context,
///   const HomeScreen(),
/// );
/// ```
///
final class ProNavigator {
  const ProNavigator._();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState? get _navigator => navigatorKey.currentState;

  static PageRouteBuilder<T> _route<T>({
    required Widget page,
    required RouteTransitionsBuilder transition,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: transition,
    );
  }

  static Future<T?> fade<T>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.push(
      context,
      _route(
        page: page,
        duration: duration,
        transition: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  static Future<T?> slideFromRight<T>(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      _route(
        page: page,
        transition: (_, animation, __, child) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  static Future<T?> scale<T>(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      _route(
        page: page,
        transition: (_, animation, __, child) {
          return ScaleTransition(scale: animation, child: child);
        },
      ),
    );
  }

  static void popTimes(BuildContext context, int count) {
    int current = 0;

    Navigator.popUntil(context, (_) => current++ == count);
  }

  static Future<T?> pushWithoutContext<T>(Widget page) {
    return _navigator!.push<T>(MaterialPageRoute(builder: (_) => page));
  }

  static void popWithoutContext<T>([T? result]) {
    _navigator?.pop(result);
  }

  static Future<T?> replaceAll<T>(BuildContext context, Widget page) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (_) => false,
    );
  }

  /// Push a new page.
  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.push<T>(context, MaterialPageRoute(builder: (_) => page));
  }

  /// Replace current page.
  static Future<T?> pushReplacement<T, TO>(BuildContext context, Widget page) {
    return Navigator.pushReplacement<T, TO>(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Push and remove all previous routes.
  static Future<T?> pushAndRemoveUntil<T>(BuildContext context, Widget page) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  /// Push named route.
  static Future<T?> pushNamed<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  /// Replace with named route.
  static Future<T?> pushReplacementNamed<T, TO>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Push named route and remove previous routes.
  static Future<T?> pushNamedAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Pop current route.
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  /// Pop until first route.
  static void popUntilFirst(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  /// Pop until a named route.
  static void popUntilNamed(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  /// Returns true if navigator can pop.
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// Maybe pop current route.
  static Future<bool> maybePop(BuildContext context) {
    return Navigator.maybePop(context);
  }
}
