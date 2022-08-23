import 'package:check_network/check_network.dart';
import 'package:flutter/material.dart';

/// InternetStatusHeader is a widget that will show the internet status.
/// as internet status changes, it will show different colors for the status.
/// This could be used at the top of AppBar inside the nested scroll view.
class InternetStatusHeader extends SliverPersistentHeaderDelegate {
  /// This is the constructor of the [InternetStatusHeader] class.
  InternetStatusHeader(
    this.context, {
    required this.statusWidget,
    double? headerHeight,
  }) : _headerHeight = headerHeight ?? kToolbarHeight;

  /// We need build context to know the current state of the internet.
  /// so, as the internet status changes, we need to rebuild the widget.
  final BuildContext context;

  /// a function that take internet status and return the widget.
  final Widget Function(InternetStatus?) statusWidget;

  /// Expected height of the header.
  final double _headerHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return StreamBuilder<InternetStatus>(
      stream: InternetStatusProvider.of(context).onStatusChange,
      builder: (context, snapshot) {
        /// We are warping the wiDgetBuilder function with the Align widget
        /// because there is known issue which is "layoutExtent exceeds
        ///  the paintExtent when animating pinned SliverPersistentHeader".
        /// For more details check the issue here: https://github.com/flutter/flutter/issues/78748
        return Align(child: statusWidget(snapshot.data));
      },
    );
  }

  @override
  double get maxExtent {
    var maxHeight = _headerHeight;
    InternetStatusProvider.of(context).onStatusChange.listen((status) {
      if (status == InternetStatus.available) {
        maxHeight = 0;
      }
    });
    return maxHeight;
  }

  @override
  double get minExtent {
    var minHeight = _headerHeight;
    InternetStatusProvider.of(context).onStatusChange.listen((status) {
      if (status == InternetStatus.available) {
        minHeight = 0;
      }
    });

    return minHeight;
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
