import 'package:e_commer/screens/auth_screen.dart';
import 'package:e_commer/widgets/animated_route.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        child: Center(
          child: RaisedButton(
            onPressed: () {
              //replace your material page route with AnimatedRoute
              Navigator.of(context).push(AnimatedRoute(
                  widget: AuthScreen(),
                  curves: Curves.easeInOutCubic,
                  alignment: Alignment.bottomCenter));
            },
          ),
        ),
      ),
    );
  }
}
