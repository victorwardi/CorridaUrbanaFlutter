import 'package:flutter/material.dart';

import '../model/corrida.dart';

import 'package:map_view/map_view.dart';

var MAP_API_KEY = "AIzaSyBTjNYNzWAsFzlgd7qewvbUBK87gidS-YA";

class CorridaDetail extends StatefulWidget {
  final Corrida corrida;

  Color _corIcone = Colors.teal[500];

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
  
    Location local = new Location(widget.corrida.mapaLatitude, widget.corrida.mapaLongitude);
    cameraPosition = new CameraPosition(local, 2.0);

    staticMapUri = staticMapProvider.getStaticUri(local, 12,
        width: 900, height: 400, mapType: StaticMapViewType.roadmap);
  }

  @override
  Widget build(BuildContext context) {
    var card = new SizedBox(
      child: new Card(
        child: new Column(
          children: [
            new ListTile(
              title: new Text(
                widget.corrida.titulo,
                style: new TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ),
            ),
            new Divider(),
            new InkWell(
              child: new Center(
                child: new Image.network(staticMapUri.toString()),
              ),
            ),
            new ListTile(
              title: new Text(
                widget.corrida.data,
                style: new TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: new Icon(
                Icons.date_range,
                color: widget._corIcone,
              ),
            ),
            new ListTile(
              title: new Text(
                widget.corrida.endereco,
                style: new TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(widget.corrida.local),
              ),
              leading: new Icon(
                Icons.location_on,
                color: widget._corIcone,
              ),
            ),
            new ListTile(
              title: new Text(widget.corrida.distancias),
              leading: new Icon(
                Icons.directions,
                color: widget._corIcone,
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.corrida.titulo),
      ),
      body: card,
    );
  }
}
