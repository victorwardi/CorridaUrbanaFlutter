import 'package:flutter/material.dart';

class Looping extends StatelessWidget {



List<int> items = [1,2,3,4,5,6,7,8,9];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Padding(
        
        padding: const EdgeInsets.all(40.0),
        child: Container(height: 200.0, child: lista(context)),
      ),
    );

      
    
  }


  Widget lista(BuildContext context){

 return ListView.builder(
      padding: EdgeInsets.all(0.0),    
      //itemExtent: 380.0,
      itemCount: items == null ? 0 : items.length,
      itemBuilder: (BuildContext context, int index) => itemBuilder(items, index));
  }

  Widget itemBuilder(List<int> items, int index ){

     if(index == (items.length - 1)){
        index = 0;
       }

        var retorno =  Padding(
          padding: const EdgeInsets.all(28.0),
          child: Text(items[index].toString()),
        );

      

       return retorno;


  }
}