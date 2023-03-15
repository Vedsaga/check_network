import 'package:flutter/material.dart';
import 'package:check_network/check_network.dart';
import 'package:flutter/scheduler.dart';

void main() {
  /// add below code to insure WidgetsFlutterBinding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    /// Warp the Top Most Widget with the InternetStatusProvider.
    /// This will provide the current internet status to the whole app.
    InternetStatusProvider(
      currentInternetStatus:
          CurrentInternetStatus(waitOnConnectedStatusInSeconds: 5),
      child: const MyApp(),
    ),
  );
}

/// This is the [MaterialApp] that is used to display the [MyApp] widget.
class MyApp extends StatelessWidget {
  /// This is the [MaterialApp] that is used to display the [MyApp] widget.
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true),
      home: const CheckNetworkDemo(),
    );
  }
}

class CheckNetworkDemo extends StatelessWidget {
  const CheckNetworkDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<InternetStatus>(
        // access the current internet status from the provider
        stream: InternetStatusProvider.of(context).onStatusChange,
        builder: (context, snapshot) {
          final color = _getColor(snapshot.data);
          final message = _showMessage(snapshot.data);
          final icon = _getIcon(snapshot.data);
          final emoji = _showEmoji(snapshot.data);
          final duration = _showDuration(snapshot.data);
          SchedulerBinding.instance.addPostFrameCallback((_) {
            simpleSnackbarMessage(context,
                message: message, icon: icon, color: color, duration: duration);
          });
          return Center(
            child: Text.rich(
              TextSpan(
                text: "Current Internet Status: ",
                children: [
                  TextSpan(
                    text: emoji,
                    style: TextStyle(
                      fontSize: 16,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}

ScaffoldMessengerState simpleSnackbarMessage(
  BuildContext context, {
  required String message,
  required IconData icon,
  required Color color,
  required Duration duration,
}) {
  return ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: duration,
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: color,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
}

IconData _getIcon(InternetStatus? type) {
  switch (type) {
    case InternetStatus.available:
      return Icons.signal_wifi_4_bar;
    case InternetStatus.unavailable:
      return Icons.signal_wifi_bad;
    case InternetStatus.checking:
      return Icons.wifi_find_rounded;
    case InternetStatus.connected:
      return Icons.signal_wifi_4_bar;
    default:
      return Icons.signal_wifi_off_rounded;
  }
}

Color _getColor(InternetStatus? type) {
  switch (type) {
    case InternetStatus.available:
      return Colors.black;
    case InternetStatus.unavailable:
      return Colors.orange;
    case InternetStatus.checking:
      return Colors.lightBlue;
    case InternetStatus.connected:
      return Colors.green;
    default:
      return Colors.red;
  }
}

// return emoji + " " + message;
String _showEmoji(InternetStatus? type) {
  switch (type) {
    case InternetStatus.available:
      // share emoji
      return "Connect to the 🌐";
    case InternetStatus.unavailable:
      // disappointed emoji
      return "Slow internet 😞";
    case InternetStatus.checking:
      // thinking emoji
      return "Checking for valid connection 🤔";
    case InternetStatus.connected:
      // happy emoji
      return "Connected to internet 😃";
    default:
      // sad emoji
      return "Disconnected 😢";
  }
}

String _showMessage(InternetStatus? type) {
  switch (type) {
    case InternetStatus.available:
      return "Internet is available";
    case InternetStatus.unavailable:
      return "Internet is slow";
    case InternetStatus.checking:
      return "Checking internet...";
    case InternetStatus.connected:
      return "Internet connection verified";
    default:
      return "No internet connection";
  }
}

Duration _showDuration(InternetStatus? type) {
  switch (type) {
    case InternetStatus.available:
      return const Duration(seconds: 3);
    case InternetStatus.unavailable:
      return const Duration(seconds: 3);
    case InternetStatus.checking:
      return const Duration(seconds: 3);
    case InternetStatus.connected:
      return const Duration(seconds: 3);
    case InternetStatus.disconnected:
      return const Duration(days: 365);
    default:
      // There is no way to show the snackbar for infinite time
      // so we are using 365 days hoping people will not use the app for that long
      return const Duration(days: 365);
  }
}
