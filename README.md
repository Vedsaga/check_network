# check_network

> Checking Internet availability and show status at the header of the screen depending on the status.

## Table of contents

- [General info](#general-info)
- [Setup](#setup)
- [Features](#features)
- [How to use](#how-to-use)
    - [Show InternetStatusHeader](#show-internet-status-header)
    - [Many Other Use](#many-other-use)
- [Acknowledgements](#acknowledgements)
  

## General info

This package is simple script to check internet availability and show status at the header of the screen dynamically depending on the status. This will help you to know the status of your internet connection.

## Setup

To use this package, you need to install it first. You can install it by running this command:

```bash
flutter pub add check_network
```

Or you can add this to your `pubspec.yaml` file:

```yaml
dependencies:

 check_network: ^0.0.1
```

## Features

List of features ready and TODOs for future development

- Check internet availability
- Show status at the header of the screen
  
To-do list:

- Add option to check availability of specific domain name
- Support internet speed test and show the result at the header of the screen
  

## How to use

To see full example, please check the [example](https://githubcomVedsagacheck_networktreemastercheck_network_examples/lib) folder.

1. First, you import the package to your dart file.

```dart
import 'package:check_network/check_network.dart';
```

> Now there are many ways to use this package. Let's start with how to use `InternetStatusHeader` That widget will show the status at the header of the screen. Regardless of any advance use-case or just showing `InternetStatusHeader` you  need to wrap the top most widget with `InternetStatusProvider` it could be `MaterialApp` or any of the widget that is top-most. This will provide the stream of internet status to all children widgets.

2. Warp the Top Most Widget with the InternetStatusProvider.
```dart
InternetStatusProvider(
 currentInternetStatus: CurrentInternetStatus(showConnectedStatusFor: 5),
 child: const MyApp(),
),
```

3. `InternetStatusHeader` widget widget could be used wherever `SliverPersistentHeaderDelegate` could be used. 
    For e.g. `SliverPersistentHeader` takes delegate as a parameter. So, we can pass there.

```dart
Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverPersistentHeader(
            delegate: InternetStatusHeader(
              context,
              internetStatusWidgetBuilder: currentStatusWidget,
            ),
            pinned: true,
          ),
        ],
        body: ...
      ),
    );
```

so, above we can see that, `InternetStatusHeader` takes context and function that accept `InternetStatus` and return a Widget.

So, that `currentStatusWidget` function will be called whenever internet status changes. So, that function could be called whenever internet status changes. Function looks like this:

```dart
  Widget currentStatusWidget(InternetStatus? internetStatus) {
    switch (internetStatus) {
      case InternetStatus.checking:
        return ...;

      case InternetStatus.connected:
        return ...;
      case InternetStatus.available:
        return const SizedBox.shrink();
      case InternetStatus.disconnected:
        return ...;
      case InternetStatus.unavailable:
        return ...;
      case null:
        return ...;
    }
  }
```

Please see the example in the [example](https://githubcomVedsagacheck_networktreemastercheck_network_examples/lib) folder for demonstration.

That's all. Now, you can try to switch on/off the internet connection to see the status at the header of the screen dynamically changing.

## Create Custom Widget
Because `InternetStatusProvider` enable access to Stream of internet status, so like any other stream, you can listen to it and react to it. You can rebuild whole widget tree whenever internet status changes or just rebuild a specific widget. You can also perform some action when internet status changes. 
1. Such as calling a API to sync data with server.
2. Open websocket connection to receive realtime updates.
3. Show a notification when internet is available.
4. Show snackbar or toast message.




## Acknowledgements

> NOTE: This package is a continuation and took inspiration from [data_connection_checker](https://github.com/komapeb/data_connection_checker).

I would like to appreciate

 - [Dart](https://dart.dev/) team for creating such a great language.

 - [Flutter](https://flutter.dev/) team for creating such a great framework.

 - [Very Good Ventures](https://verygood.ventures/) team for creating such a great open source project and packages.

 - [Flutter Community](https://plus.fluttercommunity.dev/) team for amazing packages and resources.