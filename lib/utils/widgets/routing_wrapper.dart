import 'package:flutter/material.dart';

enum RoutingAction { replace, pop }

class RoutingWrapper extends StatelessWidget {
  final Widget child;
  final String route;
  final RoutingAction action;

  const RoutingWrapper({Key key, this.route, this.child, this.action = RoutingAction.replace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (action != null) {
        switch (action) {
          case RoutingAction.replace:
            if (route != null) Navigator.pushReplacementNamed(context, route);
            break;
          case RoutingAction.pop:
            Navigator.pop(context);
        }
      }
    });
    return child;
  }
}
