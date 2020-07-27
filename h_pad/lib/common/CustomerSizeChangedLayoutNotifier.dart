import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CustomerSizeChangedLayoutNotifier extends SingleChildRenderObjectWidget {
  /// Creates a [SizeChangedLayoutNotifier] that dispatches layout changed
  /// notifications when [child] changes layout size.
  const CustomerSizeChangedLayoutNotifier({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  _CustomerRenderSizeChangedWithCallback createRenderObject(BuildContext context) {
    return _CustomerRenderSizeChangedWithCallback(onLayoutChangedCallback: () {
      SizeChangedLayoutNotification().dispatch(context);
    });
  }
}

class _CustomerRenderSizeChangedWithCallback extends RenderProxyBox {
  _CustomerRenderSizeChangedWithCallback({
    RenderBox child,
    @required this.onLayoutChangedCallback,
  })  : assert(onLayoutChangedCallback != null),
        super(child);

  // There's a 1:1 relationship between the _RenderSizeChangedWithCallback and
  // the `context` that is captured by the closure created by createRenderObject
  // above to assign to onLayoutChangedCallback, and thus we know that the
  // onLayoutChangedCallback will never change nor need to change.

  final VoidCallback onLayoutChangedCallback;

  Size _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    // Don't send the initial notification, or this will be SizeObserver all
    // over again!
    if (size != _oldSize) //_oldSize != null &&
      onLayoutChangedCallback();
      _oldSize = size;
  }
}
