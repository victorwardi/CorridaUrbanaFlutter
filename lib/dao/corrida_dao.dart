import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/corrida.dart';

class CorridaDao {

  Future<List<Corrida>> getCorridasPorEstado(String estado) async {

    List<Corrida> corridas;

    try {

      final response = await http.get("https://www.corridaurbana.com.br/wp-json/calendario/estado/" + estado);
      corridas = _buildCorridaList(response);

    } catch (e) {
      print(e.toString());
    }
    return corridas;
  }

  List<Corrida> _buildCorridaList(http.Response response) {

    List<Corrida> corridas = new List<Corrida>();

    final responseJson = json.decode(response.body);  

    print(responseJson);

    for (var corridaJson in responseJson) {
      Corrida corrida = new Corrida();   

      corrida.titulo = corridaJson["titulo"];
      corrida.dia = corridaJson["dia"];
      corrida.mes = corridaJson["mes"];
      corrida.mesExtenso = corridaJson["mesExtenso"];
      corrida.data = corridaJson["data"];
      corrida.cidade = corridaJson["cidade"];
      corrida.estado = corridaJson["estado"];
      corrida.uf = corridaJson["uf"];
      corrida.local = corridaJson["local"];
      corrida.endereco = corridaJson["endereco"];
      corrida.distancias = corridaJson["distancias"];
      corrida.valor = corridaJson["valor"];
      corrida.site = corridaJson["site"];
      corrida.horario = corridaJson["horario"];

      if(corridaJson["mapa"]["latitude"] != null){
        corrida.mapaLatitude = double.tryParse(corridaJson["mapa"]["latitude"] );
      }

       if(corridaJson["mapa"]["longitude"] != null){
        corrida.mapaLongitude = double.tryParse(corridaJson["mapa"]["longitude"] );
      }
   
      corridas.add(corrida);
    }

corridas.forEach((corrida) => print(corrida.titulo));

    return corridas;
  }
}
