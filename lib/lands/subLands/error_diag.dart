import 'package:flutter/material.dart';

class ErrorDiag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 60.0,
        color: Colors.red,
        padding: EdgeInsets.all(20.0),
        child: Text(
          "Something went wrong!",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
