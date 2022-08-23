import 'package:check_network/check_network.dart';
import 'package:flutter/material.dart';

void main() {
  /// add below code to insure WidgetsFlutterBinding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    /// Warp the App with the InternetStatusProvider.
    /// This will provide the current internet status to the whole app.
    InternetStatusProvider(
        currentInternetStatus: CurrentInternetStatus(showConnectedStatusFor: 5),
        child: const MyApp()),
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
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const CheckNetworkDemo(),
    );
  }
}

/// class MyHomePage extends StatefulWidget
class CheckNetworkDemo extends StatefulWidget {
  /// This is the  instance that is used to check the Internet.
  const CheckNetworkDemo({super.key});

  @override
  State<CheckNetworkDemo> createState() => _CheckNetworkDemoState();
}

class _CheckNetworkDemoState extends State<CheckNetworkDemo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    InternetStatusProvider.of(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// To use the InternetStatusHeader, we need to wrap the body with the
      /// NestedScrollView. Because the InternetStatusHeader is a SliverPersistentHeaderDelegate.
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          /// Then to use we need InternetStatusHeader with the SliverPersistentHeader.
          /// so, we could pin the header and show the status of the internet.
          SliverPersistentHeader(
            delegate: InternetStatusHeader(
              context,
              statusWidget: _getWidget,
            ),
            pinned: true,
          ),
        ],
        body: const Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text:
                        'To see the demo, please switch status of the internet from',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: '  on ',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'to off',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' or vice versa',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              )),
        ),
      ),
    );
  }

  /// This method will return the widget based on the [internetStatus].
  /// The [internetStatus] is the current state of the internet.
  Widget _getWidget(InternetStatus? internetStatus) {
    switch (internetStatus) {
      case InternetStatus.checking:
        return const InternetBar(
          message: 'Checking...',
          icon: Icons.wifi_find_rounded,
          iconColor: Colors.white,
          backgroundColor: Colors.lightBlue,
        );

      case InternetStatus.connected:
        return const InternetBar(
          message: 'Connected',
          icon: Icons.signal_wifi_4_bar,
          iconColor: Colors.white,
          backgroundColor: Colors.lightGreen,
        );
      case InternetStatus.available:
        return const SizedBox.shrink();
      case InternetStatus.disconnected:
        return const InternetBar(
          message: 'Disconnected',
          icon: Icons.signal_wifi_off_rounded,
          iconColor: Colors.white,
          backgroundColor: Colors.pink,
        );
      case InternetStatus.unavailable:
        return const InternetBar(
          message: 'Unavailable',
          icon: Icons.signal_wifi_bad,
          iconColor: Colors.white,
          backgroundColor: Colors.orange,
        );
      case null:
        return const InternetBar(
          message: 'Disconnected',
          icon: Icons.signal_wifi_off_rounded,
          iconColor: Colors.white,
          backgroundColor: Colors.red,
        );
    }
  }
}

/// This is the [InternetBar] widget that is used to display the internet status
class InternetBar extends StatelessWidget {
  /// This is the constructor of the [InternetBar] class.
  const InternetBar({
    super.key,
    Color? backgroundColor,
    required this.message,
    required this.icon,
    required this.iconColor,
    this.messageStyle,
  }) : _backgroundColor = backgroundColor ?? Colors.white;

  /// background color of the internet bar.
  final Color _backgroundColor;

  /// message to show in the internet bar.
  final String message;

  /// icon to show in the internet bar.
  final IconData icon;

  /// color of the icon.
  final Color iconColor;

  /// message style.
  final TextStyle? messageStyle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _backgroundColor,
      ),
      // set max height to take all parent height
      child: Padding(
        padding: const EdgeInsets.only(
          top: 28,
          left: 24,
          right: 24,
          bottom: 4,
        ),
        child: Flex(
          direction: Axis.horizontal,
          clipBehavior: Clip.hardEdge,
          children: [
            const Spacer(),
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(width: 8),
            Text(
              message,
              style: messageStyle,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
