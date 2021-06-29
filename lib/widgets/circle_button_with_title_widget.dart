import 'package:flutter/material.dart';

import 'circle_button_widget.dart';

class CircleButtonWithTitle extends StatelessWidget {
  CircleButtonWithTitle({this.icon, this.title});

  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleButtonWidget(
          child: Icon(icon),
        ),
        SizedBox(height: 12),
        Text(title),
      ],
    );
    ;
  }
}
