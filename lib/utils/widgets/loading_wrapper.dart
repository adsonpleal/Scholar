import 'package:flutter/material.dart';

class LoadingWrapper extends StatelessWidget {
  final bool isLoading;
  final bool ignoreActions;
  final Widget child;

  LoadingWrapper({
    @required this.isLoading,
    @required this.child,
    this.ignoreActions = true,
  });

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          IgnorePointer(
            ignoring: ignoreActions && isLoading,
            child: child,
          ),
          _showCircularProgress(),
        ],
      );

  Widget _showCircularProgress() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}
