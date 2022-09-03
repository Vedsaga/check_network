<p align="center">
<a href="https://pub.dev/packages/check_network"><img src="https://img.shields.io/pub/v/check_network.svg" alt="Pub"></a>
<a href="https://github.com/Vedsaga/check_network"><img src="https://img.shields.io/github/stars/Vedsaga/check_network.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
</p>

# check_network

> Checking Internet availability by pinging DNS servers to check if the Internet connection is available or not.

## Table of contents

- [General info](#general-info)
- [Setup](#setup)
- [Features](#features)
- [How to use](#how-to-use)
    - [Rebuild Widget](#rebuild-widget)
- [Acknowledgements](#acknowledgements)
  

## General info

This package is simply ping DNS sever to check if availability of internet is valid one or not. It is useful because by wrapping `MaterialApp` widget, with `InternetStatusProvider` will give access to Stream of internet status which then can be used to perform any action based on internet status.
  Such as:
  - [Rebuilding Widget if internet is not available](https://github.com/Vedsaga/check_network/tree/master/example/lib/widget_rebuild.dart)
  - [Showing Snackbar if internet is not available](https://github.com/Vedsaga/check_network/tree/master/example/lib/show_snackbar.dart)
  - Showing Dialog if internet is not available
  - Redirecting to another screen if internet is not available
  - check availability of specific domain address
  - etc.
  
  

[Show Snackbar](https://user-images.githubusercontent.com/59083528/187082881-6a1649d8-094d-4f57-a425-fd6786761605.mp4)

[Widget Rebuild](https://user-images.githubusercontent.com/59083528/187082885-66129bc9-6c07-47bf-a818-5e528d68122f.mp4)



  
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
- Add option to check availability of specific domain address


To-do list:

- Support internet speed test
  

## How to use

To see full example, please check the [example](https://github.com/Vedsaga/check_network/tree/master/example/lib) folder.

1. First, you import the package to your dart file.

```dart
import 'package:check_network/check_network.dart';
```

2. Warp the Top Most Widget with the InternetStatusProvider. This will provide the **`Stream of InternetStatus`** to all children widgets.
```dart
InternetStatusProvider(
 currentInternetStatus: CurrentInternetStatus(showConnectedStatusFor: 5),
 child: const MyApp(),
),
```

> Now we will see how to rebuild the widget when internet status changes.

### Rebuild Widget

Have a Scaffold with StreamBuilder pass
**`InternetStatusProvider.of(context).onStatusChange`** to stream parameter that will give access to `Internet Status`. 
And, now simple pass a function that return a widget based on the current internet status which will get recalled when internet status changes.


```dart
 return Scaffold(
      body: StreamBuilder<InternetStatus>(
        stream: InternetStatusProvider.of(context).onStatusChange,
        builder: (context, snapshot) {
          return Center(child: internetStatusWidgetBuilder(snapshot.data));
        },
      ),
    );
```

And, that's it we are done. Now, every time the internet status changes, the widget will be rebuilt.
Please see the example in the [example](https://github.com/Vedsaga/check_network/tree/master/example/lib) for full code and many more examples.


## Acknowledgements

> NOTE: This package is a continuation and took inspiration from [data_connection_checker](https://github.com/komapeb/data_connection_checker).

I would like to appreciate

 - [Dart](https://dart.dev/) team for creating such a great language.

 - [Flutter](https://flutter.dev/) team for creating such a great framework.

 - [Very Good Ventures](https://verygood.ventures/) team for creating such a great open source project and packages.

 - [Flutter Community](https://plus.fluttercommunity.dev/) team for amazing packages and resources.
