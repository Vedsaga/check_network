import 'package:flutter/material.dart';
import 'package:check_network/check_network.dart';

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
    // A Scaffold with StreamBuilder to that receives the streams from
    // [InternetStatusProvider.of(context).onStatusChange] and recall a function
    // that return a widget based on the current internet status.
    return Scaffold(
      body: StreamBuilder<InternetStatus>(
        // access the current internet status from the provider
        stream: InternetStatusProvider.of(context).onStatusChange,
        builder: (context, snapshot) {
          // rebuild the widget as new internet status is received
          return Center(child: internetStatusWidgetBuilder(snapshot.data));
        },
      ),
    );
  }

  // A function that take `InternetStatus` as a parameter and return a widget.
  Widget internetStatusWidgetBuilder(InternetStatus? status) {
    switch (status) {
      case InternetStatus.available:
        return const Text(
          'Internet is now available',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        );
      case InternetStatus.unavailable:
        return const Text(
          'Internet is unavailable',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        );
      case InternetStatus.checking:
        return const Text(
          'Checking internet status',
          style: TextStyle(
            color: Colors.lightBlue,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        );
      case InternetStatus.connected:
        return const Text(
          'Internet connection is confirmed',
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        );
      default:
        return const Text(
          'Disconnected from internet',
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        );
    }
  }
}
