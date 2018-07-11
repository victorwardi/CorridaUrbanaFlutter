import 'package:flutter/material.dart';

class Looping extends StatelessWidget {



List<int> items = [0,1,2,3,4,5,6,7,8,9];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Padding(
        
        padding: const EdgeInsets.all(40.0),
        
        child: Container(child: lista(context), color: Colors.amberAccent,),
      ),
    );

      
    
  }


  Widget lista(BuildContext context){

    int count = 0;

  List cards = new List.generate(20, (i)=>itemBuilder(i.toString())).toList();

  return ListView(
    children: cards
  );

 return ListView.builder(
      padding: EdgeInsets.all(0.0),    
      //itemExtent: 380.0,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        print('index: $index');
        print('counter: $count');

          //contador chegou no final, volta pro 0
          if(count == items.length ){ 
              count = 0;          
          }

          //chegou no final da lista, remove o primeiro e adiciona no final
          if(index >= items.length){
            items.removeAt(0); 
            items.add(count);
          }

        var  item = itemBuilder(count.toString());
             
              print('lista size: ${items.length}');
              count++;
              
            return item;
      } );
  }

  Widget itemBuilder(String number ){
        var retorno =  Padding(
          padding: const EdgeInsets.all(28.0),
          child: Text(number, style: TextStyle( fontSize: 50.0 ), textAlign: TextAlign.center,),
        );

      

       return retorno;


  }
}