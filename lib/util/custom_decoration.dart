import 'package:flutter/material.dart';

class UtilDecoration{

 static BoxDecoration gradientBackgroundLight =

   new BoxDecoration(
        gradient: new RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.0),
          ],
        ),
      );



static BoxDecoration gradientBackgroundDark =

   new BoxDecoration(
        gradient: new RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [
            Colors.blueGrey.withOpacity(0.5),
            Colors.blueGrey.withOpacity(0.0),
          ],
        ),
      );


  
}