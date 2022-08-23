/// These are possible the internet status.
///
enum InternetStatus {
  /// If the internet is not connected.
  /// This represents that wifi and mobile data is off.
  disconnected,

  /// If the internet is checking.
  /// This represents that wifi or mobile data is on and
  ///  internet is getting checked.
  checking,

  /// If the internet is connected.
  /// This represents that wifi or mobile data is on
  /// and internet connection is confirmed that it is working.
  connected,

  /// If the internet is unavailable.
  /// This represents that wifi or mobile data is on
  /// and internet connection is not working.
  /// either due to slow internet or not enough data.
  unavailable,

  /// If the internet is available.
  /// This represents that wifi or mobile data is on
  /// and internet connection is available currently.
  available,
}
