import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import '../model/corrida.dart';

const MAP_API_KEY = "AIzaSyBTjNYNzWAsFzlgd7qewvbUBK87gidS-YA";

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
      child: new Column(
        children: [
          new Padding(
            padding: const EdgeInsets.all(12.0),
            child: new Text(
              widget.corrida.titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: Colors.teal[900]),
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
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share('Se inscreva na corrida: $widget.corrida.site');
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(child: card),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton.icon(
                  icon: new Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Icon(
                      Icons.local_activity,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  label: Text(
                    "Inscreva-se",
                   style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.teal,               
                  onPressed: () {
                    _launchURL(widget.corrida.site);
                  },
                ),
          )
        ],
      ),
     
    );
  }

  Widget _itemCorrida(String tipoItem, String item, IconData icon) {
    return item == "Verifique no site oficial."
        ? new Container(
            width: 0.0,
            height: 0.0,
          )
        : new Padding(
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
