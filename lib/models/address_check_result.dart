import 'package:check_network/check_network.dart';

/// Helper class that contains the address options and indicates whether
/// opening a socket to it succeeded or not.
class AddressCheckResult {
  /// Constructor for AddressCheckResult.
  /// [options] is the options used to check for a connection.
  /// [status] is the status of the check.
  ///
  AddressCheckResult(
    this.options,
    this.status,
  );

  /// The options used to check for a connection.
  final AddressCheckOptions options;

  /// The status of the check.
  final AddressCheckResultStatus status;

  @override
  String toString() => 'AddressCheckResult($options $status)';
}
