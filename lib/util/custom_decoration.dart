import 'package:flutter/material.dart';

class UtilDecoration{

 static final BoxDecoration radialGradiente =

   new BoxDecoration(
        gradient: new RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [
            Color.fromRGBO(0, 200, 170, 1.0),
            Color.fromRGBO(0, 130, 120, 1.0),
          ],
        ),
      );

static final BoxDecoration linearGradient =

new BoxDecoration(
        shape: BoxShape.rectangle,
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: <Color>[
            Color.fromRGBO(0, 130, 120, 1.0),
            Color.fromRGBO(0, 200, 170, 1.0),
           
          ],
          //tileMode: TileMode.repeated
        ),
      );
  
}