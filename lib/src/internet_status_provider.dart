import 'package:check_network/check_network.dart';
import 'package:flutter/material.dart';

/// Material app widget should be wrapped with
/// this widget InternetStatusProvider so, that CurrentInternetStatus
/// can be accessed from anywhere in the app using
///  InternetStatusProvider.of(context)
class InternetStatusProvider extends InheritedWidget {
  /// This is the constructor of the [InternetStatusProvider] class.
  /// It initializes the [InternetStatusProvider] with the [child]
  /// and the [CurrentInternetStatus] instance.
  const InternetStatusProvider({
    required this.currentInternetStatus,
    required super.child,
    super.key,
  });

  /// This is the [CurrentInternetStatus] instance.
  final CurrentInternetStatus currentInternetStatus;

  /// static method to get the value of the [InternetStatus] from the
  static CurrentInternetStatus of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InternetStatusProvider>()!
        .currentInternetStatus;
  }

  @override
  bool updateShouldNotify(InternetStatusProvider oldWidget) {
    return true;
  }
}
