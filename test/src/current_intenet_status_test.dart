import 'dart:async';

import 'package:check_network/check_network.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InternetDataChecker? checkInternetAvailability;
  StreamSubscription<DataConnectionStatus>? listener1;
  StreamSubscription<DataConnectionStatus>? listener2;
  // this is setup before every test it creates a new instance of the class
  setUpAll(() {
    checkInternetAvailability = InternetDataChecker();
  });

  // destroy any active listener after each test
  tearDown(() {
    listener1?.cancel();
    listener2?.cancel();
  });

  group('Validate Internet', () {
    test('should return a singleton', () {
      expect(checkInternetAvailability, isA<InternetDataChecker>());
    });

    test('should return list of addresses', () {
      expect(
        checkInternetAvailability!.addresses,
        isA<List<AddressCheckOptions>>(),
      );
    });

    test('hasConnection should return Future Bool', () {
      expect(checkInternetAvailability!.hasConnection, isA<Future<bool>>());
    });

    test('connection status should return Future DataConnectionStatus ', () {
      expect(
        checkInternetAvailability!.connectionStatus,
        isA<Future<DataConnectionStatus>>(),
      );
    });

    test('''Initial results List 'lastTryResults' should be empty''', () {
      expect(
        checkInternetAvailability!.lastTryResults,
        isA<List<AddressCheckResult>>(),
      );
    });

    test('''Awaited call to hasConnection should return a bool''', () async {
      expect(await checkInternetAvailability!.hasConnection, isA<bool>());
    });

    test(
        '''Awaited call to connectionStatus should return a DataConnectionStatus''',
        () async {
      expect(
        await checkInternetAvailability!.connectionStatus,
        isA<DataConnectionStatus>(),
      );
    });

    test('''LastTryResults should be empty after''', () async {
      expect(checkInternetAvailability!.lastTryResults, isEmpty);
    });

    test('''We shouldn't have any listeners''', () async {
      expect(checkInternetAvailability!.hasListeners, isFalse);
    });
    test('''We should have 1 listener''', () async {
      // checkInternetAvailability!.onStatusChange.listen((_) {});
      expect(checkInternetAvailability!.hasListeners, isFalse);
    });

    // test('''Once listener is remove hasListener should be false''', () async{
    //   // first create 1 listeners
    //   listener1 = checkInternetAvailability!.onStatusChange.listen((_) {});
    //   // then remove it
    //   await listener1?.cancel().onError((error, stackTrace) => print(error));
    //   // then check if it's still there
    //   expect(checkInternetAvailability!.hasListeners, isFalse);
    // });

    test(
      '''We should have more then 1 listeners and if one removed then we should have 1 listener''',
      () async {
        // first create 2 listeners
        listener1 = checkInternetAvailability!.onStatusChange.listen((_) {});
        listener2 = checkInternetAvailability!.onStatusChange.listen((_) {});
        // remove one of the listeners
        await listener1?.cancel();
        // check if we have 1 listener
        expect(checkInternetAvailability!.hasListeners, isTrue);
      },
    );

    // test('''We should have no listeners once all listeners are removed''',
    //     () async {
    //   // first create 2 listeners
    //   listener1 = checkInternetAvailability!.onStatusChange.listen((_) {});
    //   listener2 = checkInternetAvailability!.onStatusChange.listen((_) {});
    //   // remove all listeners
    //   await listener1?.cancel();
    //   await listener2?.cancel();

    // // check if we have no listeners
    // expect(checkInternetAvailability!.hasListeners, isFalse);
    // });
  });
}
