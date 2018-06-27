import 'package:flutter/material.dart';

import '../model/corrida.dart';

import 'package:map_view/map_view.dart';

var MAP_API_KEY = "AIzaSyBTjNYNzWAsFzlgd7qewvbUBK87gidS-YA";

class CorridaDetail extends StatefulWidget {
  final Corrida corrida;

  CorridaDetail(this.corrida);

  @override
  CorridaDetailState createState() {
    return new CorridaDetailState();
  }
}

class CorridaDetailState extends State<CorridaDetail> {
  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var staticMapProvider = new StaticMapProvider(MAP_API_KEY);
  Uri staticMapUri;

  @override
  initState() {
    super.initState();

    Location local =
        new Location(widget.corrida.mapaLatitude, widget.corrida.mapaLongitude);
    cameraPosition = new CameraPosition(local, 2.0);

    staticMapUri = staticMapProvider.getStaticUri(local, 12,
        width: 900, height: 400, mapType: StaticMapViewType.roadmap);
  }

  @override
  Widget build(BuildContext context) {
    var map = new InkWell(
      child: new Center(
        child: new Image.network(staticMapUri.toString()),
      ),
    );

    var card = new Container(
      
      child: 
        new Column(
          children: [
            new Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Text(
                widget.corrida.titulo,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0, color: Colors.red),
              ),
            ),
            _itemCorrida("Data", widget.corrida.data, Icons.date_range),
            _itemCorrida("Local", widget.corrida.local, Icons.place),
            _itemCorrida("Horário", widget.corrida.horario, Icons.access_time),
            _itemCorrida("Distância(s)", widget.corrida.distancias, Icons.directions_run),
            _itemCorrida("Valor", widget.corrida.valor, Icons.monetization_on),
            
          ],
          
        ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.corrida.titulo),
      ),
      body: new Container ( child: card
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
            icon: new Icon(Icons.local_activity),
            title: new Text("Se Inscrever"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.share),
            title: new Text("Compartilhar"),
          ),
        ],
      ),
    );
  }

  Widget _itemCorrida(String tipoItem, String item, IconData icon) {
    return item == "Verifique no site oficial."?  new Container( width: 0.0, height: 0.0,) : 
    new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: Row(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: new Icon(icon),
                ),
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(tipoItem),
                ),
              ],
            ),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(item),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
