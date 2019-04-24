import 'package:flutter/material.dart';

class AgendaHeader extends StatelessWidget {
  final String weekDay;
  final String formatedDate;
  const AgendaHeader({
    Key key,
    this.weekDay,
    this.formatedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          height: 44.0,
          width: 60.0,
          child: GestureDetector(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  weekDay,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(formatedDate),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
