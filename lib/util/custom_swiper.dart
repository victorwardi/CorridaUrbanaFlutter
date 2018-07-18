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

  CustomSwiper(
      {this.list,
      this.label,
      this.unit,
      this.width = 200.0,
      this.height = 100.0,
      this.fontSize = 25.0,
      this.onIndexChanged,
      this.scrollDirection = Axis.vertical});

  @override
  Widget build(BuildContext context) {
    return Container(
  
      width: this.width,
      height: this.height,
      child: Stack(

        //  mainAxisAlignment: MainAxisAlignment.spaceAround,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          this.unit != null
              ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(

                      alignment: Alignment.centerLeft,
                 
                      height: this.height,
                      width: this.width / 2,
                    
                      child: Padding(
                        padding: const EdgeInsets.only(left:15.0),
                        child: Text(
                          this.unit,
                          style: TextStyle(
                            fontSize: this.fontSize, 
                          ),
                        ),
                      )),
                ],
              )
              : Container(),
          Container(
            margin: EdgeInsets.all(10.0), 
            child: swiper(this.list),
          ),
        ],
      ),
    );
  }

  Widget swiper(List list) {
    return Swiper(
        containerWidth: this.width,
        itemCount: list.length,
        viewportFraction: 0.3,
        outer: true,
        scale: 0.3,
        scrollDirection: this.scrollDirection,
        physics: FixedExtentScrollPhysics(),
        // control: SwiperControl(size: 20.0, color: Colors.grey, padding: EdgeInsets.all(0.0)),
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Container(
              child: Text(
                list[index].label,
                style: TextStyle(fontSize: this.fontSize),
              ),
            ),
          );
        },
        onIndexChanged: this.onIndexChanged);
  }
}

class ItemSwiper {
  var value;
  var label;

  ItemSwiper(this.label, this.value);
}
