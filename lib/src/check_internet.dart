import 'dart:async';
import 'dart:io';

import 'package:check_network/check_network.dart';

/// This is a singleton that can be accessed like a regular constructor
/// i.e. CheckInternet() always returns the same instance.
/// When [hasConnection] or [connectionStatus] is called,
/// this utility class tries to ping every address in this list
/// until it finds one which is reachable or runs out of addresses.
class CheckInternet {
  /// This is the singleton instance.
  factory CheckInternet() => _instance;

  CheckInternet._() {
    // immediately perform an initial check so we know the last status?
    connectionStatus.then((status) => _lastStatus = status);

    // start sending status updates to onStatusChange when there are listeners
    // (emits only if there's any change since the last status update)
    _statusController
      ..onListen = _maybeEmitStatusUpdate
      // stop sending status updates when no one is listening
      ..onCancel = () {
        _timerHandle?.cancel();
        // reset last status
        _lastStatus = null;
      };
  }

  /// Function return list of [AddressCheckOptions] that get called when
  /// address are not provided.
  static List<AddressCheckOptions> defaultAddress() {
    /// loop over the list of default addresses
    ///  and create a list of AddressCheckOptions
    /// with the default port and timeout
    ///
    final options = <AddressCheckOptions>[];
    for (final address in Default.reliableAddresses) {
      options.add(
        AddressCheckOptions(
          address,
        ),
      );
    }
    return options;
  }

  /// A list of internet addresses (with port and timeout) to ping.
  /// These should be globally available destinations.
  final List<AddressCheckOptions> addresses = defaultAddress();

  /// This is a singleton that can be accessed like a regular constructor
  /// i.e. CheckInternet() always returns the same instance.
  static final CheckInternet _instance = CheckInternet._();

  /// Ping a single address and return the result.
  Future<AddressCheckResult> isHostReachable(
    AddressCheckOptions options,
  ) async {
    Socket? sock;
    try {
      sock = await Socket.connect(
        options.address,
        options.port,
        timeout: options.timeout,
      )
        ..destroy();
      return AddressCheckResult(options, AddressCheckResultStatus.success);
    } catch (e) {
      sock?.destroy();
      return AddressCheckResult(options, AddressCheckResultStatus.failed);
    }
  }

  /// Returns the results from the last check.
  /// The list is populated only when [hasConnection]
  /// (or [connectionStatus]) is called.
  List<AddressCheckResult> get lastTryResults => _lastTryResults;
  final List<AddressCheckResult> _lastTryResults = <AddressCheckResult>[];

  /// Initiates a request to each address in [addresses].
  /// The provided addresses should be good enough to test for data connection.
  /// If at least one of the addresses is reachable
  /// we assume an internet connection is available and return `true`.
  /// otherwise we return `false`.
  Future<bool> get hasConnection async {
    final result = Completer<bool>();
    var length = addresses.length;

    for (final addressOptions in addresses) {
      await isHostReachable(addressOptions).then(
        (AddressCheckResult request) {
          length -= 1;
          if (!result.isCompleted) {
            if (request.status == AddressCheckResultStatus.success) {
              result.complete(true);
              return;
            }
            if (length == 0) {
              result.complete(false);
              return;
            }
          }
        },
      );
    }
    return result.future;
  }

  /// Initiates a request to each address in [addresses]. If at least one of the
  ///  addresses is reachable we assume an internet connection is available and
  ///  return  [ConnectionStatus.established] otherwise[ConnectionStatus.failed]
  Future<ConnectionStatus> get connectionStatus async {
    return await hasConnection
        ? ConnectionStatus.established
        : ConnectionStatus.failed;
  }

  /// The interval between periodic checks. Periodic checks are
  /// only made if there's an attached listener to [onStatusChange].
  /// If that's the case [onStatusChange] emits an update only if
  /// there's change from the previous status.
  Duration checkInterval = Default.defaultInterval;

  // Checks the current status, compares it with the last and emits
  // an event only if there's a change and there are attached listeners
  // If there are listeners, a timer is started which runs this function again
  // after the specified time in 'checkInterval'
  Future<void> _maybeEmitStatusUpdate([
    Timer? timer,
  ]) async {
    // just in case
    _timerHandle?.cancel();
    timer?.cancel();

    final currentStatus = await connectionStatus;

    // only send status update if last status differs from current
    // and if someone is actually listening
    if (_lastStatus != currentStatus && _statusController.hasListener) {
      _statusController.add(currentStatus);
    }
    // start new timer only if there are no listeners
    if (!_statusController.hasListener) return;

    // start new timer only if there are listeners
    _timerHandle = Timer(checkInterval, _maybeEmitStatusUpdate);

    // update last status
    _lastStatus = currentStatus;
  }

  // _lastStatus should only be set by _maybeEmitStatusUpdate()
  // and the _statusController's.onCancel event handler
  ConnectionStatus? _lastStatus;
  Timer? _timerHandle;

  // controller for the exposed 'onStatusChange' Stream
  final StreamController<ConnectionStatus> _statusController =
      StreamController.broadcast();

  /// When all the listeners are removed from `onStatusChange`, the internal
  /// timer is cancelled and the stream does not emit events.
  Stream<ConnectionStatus> get onStatusChange => _statusController.stream;

  /// Returns true if there are any listeners attached to [onStatusChange]
  bool get hasListeners => _statusController.hasListener;

  /// Closes the stream and cancels the internal timer.
  /// This should be called when you're done with the stream.
  /// to confirm that the stream is closed you can check [hasListeners].

  void dispose() {
    _statusController.close();
    _timerHandle?.cancel();
  }
}
