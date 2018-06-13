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
      final response = await http.get("https://www.corridaurbana.com.br/wp-json/wp/v2/corrida?_embed");
      final responseJson = json.decode(response.body);

      for (var corridaJson in responseJson) {

        this.title = corridaJson["title"]["rendered"];
        var terms = corridaJson["_embedded"]["wp:term"];

        for (var dados in terms) {

         this.distancias = new List<String>();

          for (var dado in dados) {
            if (dado["taxonomy"] == "estado") {
              this.estado = dado["name"];
            }
            if (dado["taxonomy"] == "distancia") {
             this.distancias.add(dado["name"]);
            }
          }
        }  

        break;      
      }
    } catch (e) {
      print(e.toString());
    }

return corridas;
    
  }
}

main() {
  Future<List<Corrida>>  corridasList = new Corrida().loadData();

  print("Titulo: " + " -");
}
