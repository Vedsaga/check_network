import 'dart:io';

/// Default values to use when no value is provided.
class Default {
  /// This is the default port to use when checking for a connection.
  /// More info on why default port is 53
  /// here:
  /// - https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
  /// - https://www.google.com/search?q=dns+server+portSD);
  static const int defaultPort = 53;

  /// Predefined reliable addresses. This is opinionated
  /// but should be enough. See https://www.dnsperf.com/#!dns-resolvers
  ///
  /// Addresses info:
  ///
  /// | Address               | Provider    | Info                        |
  /// |:----------------------|:------------|:----------------------------|
  /// | 1.1.1.1               | CloudFlare  | https://1.1.1.1                                 |
  /// | 8.8.8.8               | Google      | https://developers.google.com/speed/public-dns/ |
  /// | 208.67.220.220        | OpenDNS     | https://use.opendns.com/                        |
  /// | 2001:4860:4860::8888  | Google      | https://developers.google.com/speed/public-dns/docs/using|
  /// | 2620:fe::fe:11        | Quad9       | https://quad9.net/                     |
  /// | 2606:4700:4700::1111  | CloudFlare  | https://www.cloudflare.com/               |
  ///
  /// The list of default addresses is based on the following criteria:
  /// - The address is reliable.
  /// - The address is not a VPN address.
  /// - The address is not a local address.
  /// - The address is not a link-local address.
  /// - The address is not a site-local address.
  /// - The address is not a private address.
  /// - The address is not a reserved address.
  ///
  /// Below list is unmodifiable.
  static List<InternetAddress> reliableAddresses = List.unmodifiable([
    InternetAddress('8.8.8.8', type: InternetAddressType.IPv4),
    InternetAddress('208.67.220.220', type: InternetAddressType.IPv4),
    InternetAddress('2001:4860:4860::8888', type: InternetAddressType.IPv6),
    InternetAddress('2620:fe::fe:11', type: InternetAddressType.IPv6),
    InternetAddress('2606:4700:4700::1111', type: InternetAddressType.IPv6),
  ]);

  /// Default interval is 10 seconds
  /// Interval is the number of seconds between each check
  /// of next address in the list of reliable addresses.
  static const Duration defaultInterval = Duration(seconds: 10);

  /// Default timeout is 10 seconds
  /// Timeout is the number of seconds to wait for a connection.
  /// If no connection is made, the check will fail.
  /// If no timeout is provided, the check will wait forever.
  static const Duration defaultTimeout = Duration(seconds: 10);
}
