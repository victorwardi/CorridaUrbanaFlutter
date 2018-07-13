import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

class Looping extends StatefulWidget {
  @override
  LoopingState createState() {
    return new LoopingState();
  }
}

class LoopingState extends State<Looping> {
  List<int> numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  List<String> options = ['A', 'B', 'C', 'D'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinity Loop Items'),
      ),
      body: Center(
        child: Container(
          height: 400.0,
          child: Row(
            children: <Widget>[
              mySwiper(numbers),
              mySwiper(options),
            ],
          ),
        ),
      ),
    );
  }

  Widget mySwiper(List list) {
    return Expanded(
      child: Swiper(
          itemCount: list.length,
   
           layout: SwiperLayout.CUSTOM,
           itemHeight: 20.0,
           itemWidth: 20.0,
           customLayoutOption: CustomLayoutOption(stateCount: 1),

          scrollDirection: Axis.vertical,
          physics: FixedExtentScrollPhysics(),
          control: SwiperControl(
              size: 20.0, color: Colors.grey, padding: EdgeInsets.all(0.0)),
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Container(
                color: Colors.red,
                child: Text(
                  list[index].toString(),
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            );
          }),
    );
  }
}
