import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Loading2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown,
      child: Opacity(
        opacity: 0.3,
        child: Center(
          child: SpinKitChasingDots(
            color: Color(0xfff7892b),
            size: 70,
          ),
        ),
      ),
    );
  }
}
