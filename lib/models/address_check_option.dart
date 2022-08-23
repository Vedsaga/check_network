import 'dart:io';

import 'package:check_network/check_network.dart';

/// This class should be pretty self-explanatory.
/// It
class AddressCheckOptions {
  /// constructor for AddressCheckOptions
  /// [address] is the address to check for a connection.
  /// [port] is the port to use when checking for a connection.
  /// [timeout] is the timeout to use when checking for a connection.
  /// If [port] or [timeout] are not specified,
  /// they both fallback to the default values.
  ///
  AddressCheckOptions(
    this.address, {
    this.port = Default.defaultPort,
    this.timeout = Default.defaultTimeout,
  });

  /// This take InternetAddress
  final InternetAddress address;

  /// This is the port to use when checking for a connection.
  final int port;

  /// This is the timeout to use when checking for a connection.
  final Duration timeout;

  @override
  String toString() => 'AddressCheckOptions($address, $port, $timeout)';
}
