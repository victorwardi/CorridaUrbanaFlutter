import 'package:flutter/material.dart';

class TextShadowed extends StatelessWidget {
  final String text;
  final double size;
  final Color textColor;
  final Color shadowColor;
  final TextAlign textAlign;
  final FontWeight fontWeight;

  TextShadowed(
      {this.text,
      this.textColor = Colors.white,
      this.shadowColor = Colors.black,
      this.size = 10.0,
      this.textAlign = TextAlign.center,
      this.fontWeight = FontWeight.normal});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
                       left: 2.0,
           
            top: 2.0,
            child: Text(this.text,
                textAlign: this.textAlign,
                style: TextStyle(
                  color: this.shadowColor,
                  fontSize: this.size,
                   fontWeight: this.fontWeight
                ))),
        Text(this.text,
            textAlign: this.textAlign,
            style: TextStyle(
                color: this.textColor,
                fontSize: this.size,
                fontWeight: this.fontWeight)),
      ],
    );
  }
}
