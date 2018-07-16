import 'package:corrida_urbana/util/custom_decoration.dart';
import 'package:corrida_urbana/util/custom_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';


class ConverterPaceScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterPaceScreen> {
  final List<ItemSwiper> distancias = [
    ItemSwiper('1k', 1000),
    ItemSwiper('5k', 5000),
    ItemSwiper('10k', 10000),
    ItemSwiper('Meia-maratona', 21097),
    ItemSwiper('Maratona', 42195),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinity Loop Items'),
      ),
      body: Column(
        children: <Widget>[
          _buildSwiperField(distancias, 'Distâncias: '),
          _buildSwiperField(distancias),
          _buildSwiperField(distancias),
          _buildSwiperField(distancias),
          _buildSwiperField(distancias),
        ],
      ),  
    
    );
  }

   Widget swiper(List list) {
  return  Swiper(
        itemCount: list.length,
     viewportFraction: 0.3,
     outer: true,
     scale: 0.5,
        scrollDirection: Axis.vertical,
        physics: FixedExtentScrollPhysics(),
        control: SwiperControl(
            size: 20.0, color: Colors.grey, padding: EdgeInsets.all(0.0)),
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Container(
              child: Text(
                list[index].label,
                style: TextStyle(fontSize: 26.0),
              ),
            ),
          );
        },
  );


}

  _buildSwiperField( List list, [String label]) {

 return Row(

   children: <Widget>[
label != null ? Text('Distancias:') :Container() ,
  
          Container(
            height: 200.0,
              width: 200.0,             
              padding: EdgeInsets.all(10.0),
              child: 
               swiper(distancias),
              )
   ],
 );
  }

}

class ItemSwiper {
  int value;
  String label;

  ItemSwiper(this.label, this.value);
}
