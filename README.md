# Pro Navigator

A lightweight and easy-to-use Flutter navigation helper package that simplifies navigation using clean and reusable methods.

## Features

* Push a new screen
* Push replacement
* Push and remove all previous routes
* Push named routes
* Push replacement named routes
* Pop current route
* Pop until first route
* Pop until a named route
* Check if a route can be popped
* Maybe pop current route

## Installation

Add the package to your `pubspec.yaml`.

```yaml
dependencies:
  pro_navigator: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

Import the package:

```dart
import 'package:pro_navigator/pro_navigator.dart';
```

Push a screen:

```dart
ProNavigator.push(
  context,
  const HomeScreen(),
);
```

Replace a screen:

```dart
ProNavigator.pushReplacement(
  context,
  const LoginScreen(),
);
```

Pop a screen:

```dart
ProNavigator.pop(context);
```

Push a named route:

```dart
ProNavigator.pushNamed(
  context,
  '/home',
);
```

Remove all previous routes:

```dart
ProNavigator.pushAndRemoveUntil(
  context,
  const DashboardScreen(),
);
```

## Additional Information

This package is designed to make Flutter navigation cleaner and more readable by reducing repetitive `Navigator` code.

Contributions, feature requests, and bug reports are welcome.
