import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CustomSwiper extends StatelessWidget {

  final List list;
  final String label;
  final String unit;
  final double width;
  final double height;
  final double fontSize;
  final ValueChanged<int> onIndexChanged;
    final Axis scrollDirection;
  

  CustomSwiper({
    this.list,
    this.label,
    this.unit,
    this.width = 200.0,
    this.height = 200.0,
    this.fontSize = 25.0,
    this.onIndexChanged,
    this.scrollDirection = Axis.vertical


  });


  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        label != null ? Text(label) : Container(),
        Container(
          height: height,
          width: width,
          padding: EdgeInsets.all(10.0),
          child: swiper(list),
        ),
        unit != null ? Text(unit) : Container(),
      ],
    );
  }


    Widget swiper(List list) {
    return Swiper(
    
      itemCount: list.length,
      viewportFraction: 0.3,
      outer: true,
      scale: 0.5,
      scrollDirection: this.scrollDirection,
      physics: FixedExtentScrollPhysics(),
      control: SwiperControl(
          size: 20.0, color: Colors.grey, padding: EdgeInsets.all(0.0)),
      itemBuilder: (BuildContext context, int index) {
        return Center(
          child: Container(
            child: Text(
              list[index].label,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        );
      }
      , onIndexChanged: onIndexChanged
    );
  }


}






class ItemSwiper {
  var value;
  var label;

  ItemSwiper(this.label, this.value);
}



