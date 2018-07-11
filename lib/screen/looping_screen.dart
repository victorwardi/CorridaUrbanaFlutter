import 'dart:convert';

import 'package:corrida_urbana/util/Picker.dart';
import 'package:flutter/material.dart';

class Looping extends StatefulWidget {
  @override
  LoopingState createState() {
    return new LoopingState();
  }
}

class LoopingState extends State<Looping> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<Widget> numeros = [];
    items.forEach((i) => numeros.add(Text(i.toString())));
    return Scaffold(
      body: Center(
        child: Container(
          height: 200.0,
          color: Colors.amber,
          child: getPages(),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: RaisedButton(
          child: Text('Picker Show Modal'),
          onPressed: () {
            showPickerModal(context);
          },
        ),
      ),
    );
  }

  showPickerModal(BuildContext context) {
    new Picker<String>(
        itemExtent: 100.0,
        pickerdata: json.decode(dataJson),
        changeToFirst: true,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.adapter.text);
        }).showModal(_scaffoldKey.currentState);
  }

  List<int> items = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  Widget lista(BuildContext context) {
    int count = 0;

    return ListView.builder(
        padding: EdgeInsets.all(0.0),
        //itemExtent: 380.0,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          print('index: $index');
          print('counter: $count');

          //contador chegou no final, volta pro 0
          if (count == items.length) {
            count = 0;
          }

          //chegou no final da lista, remove o primeiro e adiciona no final
          if (index >= items.length) {
            items.removeAt(0);
            items.add(count);
          }

          var item = itemBuilder(count.toString());

          print('lista size: ${items.length}');
          count++;

          return item;
        });
  }

  Widget itemBuilder(String number) {
    var retorno = Padding(
      padding: const EdgeInsets.all(18.0),
      child: Text(
        number,
        style: TextStyle(fontSize: 50.0),
        textAlign: TextAlign.center,
      ),
    );

    return retorno;
  }

  Widget getPages() {
    final _controller = new PageController(viewportFraction: 0.5);

    final _kDuration = const Duration(milliseconds: 200);

    final _kCurve = Curves.ease;

    return PageView.builder(
      physics: new AlwaysScrollableScrollPhysics(),
      controller: _controller,
      scrollDirection: Axis.vertical,
      pageSnapping: false,

      itemBuilder: (BuildContext context, int index) {

        //Show the fist element from the list
        final _itemBuilder = itemBuilder(items[0].toString());  
        //remove it and add to the end 
        items.add(items.removeAt(0));
        items.insert(0, items.removeLast());
     
        return _itemBuilder;
      },
      //  pageSnapping: false,
      onPageChanged: (page) {
        _controller.animateToPage(
          page,
          duration: _kDuration,
          curve: _kCurve,
        );

      
      },
    );
  }

Widget _buildWheelScrollView(){

   List<int> items = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

   List<Widget> listItems =  new List<Widget>();

   items.forEach((item){
        listItems.add(Text(item.toString()));
   });

return ListWheelScrollView(

  
  itemExtent: 20.0,
  children: listItems,
  onSelectedItemChanged: (item){
setState(() {
 listItems.add(listItems.removeAt(0));
  
});
  },
);

}
  

  final dataJson = '''
[
    {
        "a": [
            {
                "a1": [
                    1,
                    2,
                    3,
                    4
                ]
            },
            {
                "a2": [
                    5,
                    6,
                    7,
                    8
                ]
            },
          
        ]
    },
    {
        "b": [
            {
                "b1": [
                    11,
                    "oioioi",
                    33,
                    44
                ]
            },
            {
                "b2": [
                    55,
                    66,
                    77,
                    88
                ]
            },
            {
                "b3": [
                    99,
                    1010,
                    1111,
                    1212
                ]
            }
        ]
    },
    {
        "c": [
            {
                "c1": [
                    "a",
                    "b",
                    "c"
                ]
            },
            {
                "c2": [
                    "aa",
                    "bb",
                    "cc"
                ]
            },
            {
                "c3": [
                    "aaa",
                    "bbb",
                    "ccc"
                ]
            }
        ]
    },
    {
        "d": [
            {
                "Victor": [
                    "a",
                    "b",
                    "c"
                ]
            },
            {
                "Wardi": [
                    "aa",
                    "bb",
                    "cc"
                ]
            },
            {
                "Ursula": [
                    "aaa",
                    "bbb",
                    "ccc"
                ]
            }
        ]
    }
]
    ''';
}
