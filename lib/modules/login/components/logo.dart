import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo();

  @override
  build(BuildContext context) => Hero(
        tag: 'hero',
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 48.0,
            child: Image.asset('assets/school.png'),
          ),
        ),
      );
}
