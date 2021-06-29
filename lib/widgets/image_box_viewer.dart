import 'package:flutter/material.dart';

class ImageBoxView extends StatelessWidget {
  final Widget child;
  ImageBoxView({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.only(
        top: 20,
        right: 15,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
