import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Corrida {
  String title;
  String date;
  String estado;
  List<String> distancias;

  Corrida([this.title, this.date, this.estado, this.distancias]);

  Future<List<Corrida>> loadData() async {
    List<Corrida> corridas = new List<Corrida>();

    try {
      final response = await http
          .get("https://www.corridaurbana.com.br/wp-json/wp/v2/corrida?_embed");
      final responseJson = json.decode(response.body);

      for (var corridaJson in responseJson) {
        Corrida corrida = new Corrida();

        corrida.title = corridaJson["title"]["rendered"];
        var terms = corridaJson["_embedded"]["wp:term"];

        for (var dados in terms) {
          corrida.distancias = new List<String>();

          for (var dado in dados) {
            if (dado["taxonomy"] == "estado") {
              corrida.estado = dado["name"];
            }
            if (dado["taxonomy"] == "distancia") {
              corrida.distancias.add(dado["name"]);
            }
          }
        }

        corridas.add(corrida);
      }
    } catch (e) {
      print(e.toString());
    }

    return corridas;
  }
}

main() {
  Future<List<Corrida>> corridasList = new Corrida().loadData();
  corridasList.then((List<Corrida> corridas) =>
      corridas.forEach((corrida) => print(corrida.title)));
}
