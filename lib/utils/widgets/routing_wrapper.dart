import 'package:flutter/material.dart';

class RoutingWrapper extends StatelessWidget {
  final Widget child;
  final String route;
  final bool pop;

  const RoutingWrapper({Key key, this.route, this.child, this.pop = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (route != null) Navigator.pushReplacementNamed(context, route);
      if (pop) Navigator.pop(context);
    });
    return child;
  }
}
