import 'dart:math' show sqrt;

import 'package:flutter/material.dart';

class BottomPopupRoute<T> extends PopupRoute<T> {
  BottomPopupRoute({
    @required this.builder,
    RouteSettings settings,
    this.barrierLabel = 'Dismiss',
    this.barrierColor = const Color(0x80000000),
    this.padding,
  }) : super(settings: settings);

  final WidgetBuilder builder;

  @override
  final barrierDismissible = true;

  @override
  final String barrierLabel;

  @override
  final barrierColor;

  @override
  final transitionDuration = const Duration(milliseconds: 400);

  final EdgeInsetsGeometry padding;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final padding = mediaQuery.padding;
    final paddingV = padding.top + padding.bottom;
    final maxHeight = height - paddingV - 24;
    return Semantics(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          _Pan(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  bottom: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  padding: this.padding ?? const EdgeInsets.all(16),
                  child: Material(
                    color: Colors.transparent,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: maxHeight),
                      child: builder(context),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      scopesRoute: true,
      explicitChildNodes: true,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: animation
          .drive(
            // isCurrent: true -> push | false -> pop
            CurveTween(
              curve: isCurrent ? const ElasticOutCurve(0.8) : Curves.easeInOut,
            ),
          )
          .drive(
            Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ),
          ),
      child: child,
    );
  }
}

class _Pan extends StatefulWidget {
  const _Pan({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _PanState createState() => _PanState();
}

class _PanState extends State<_Pan> {
  double _offsetY = 0;
  double _lastOffsetY = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final panThreshold = height * 0.2;
    return AnimatedPositioned(
      duration: Duration(
        milliseconds: _offsetY == 0 ? (_lastOffsetY * 0.3).toInt().abs() : 0,
      ),
      left: 0,
      right: 0,
      bottom: -_offsetY,
      child: GestureDetector(
        onPanUpdate: (g) {
          var delta = g.delta.dy;
          if (_offsetY < 0 && delta < 0) {
            delta = -sqrt(delta.abs());
          }
          setState(() {
            _offsetY += delta;
          });
        },
        onPanEnd: (g) {
          if (_offsetY > panThreshold) {
            Navigator.of(context).pop();
          } else {
            _cancel();
          }
        },
        onPanCancel: _cancel,
        child: widget.child,
      ),
    );
  }

  void _cancel() {
    setState(() {
      _lastOffsetY = _offsetY;
      _offsetY = 0;
    });
  }
}