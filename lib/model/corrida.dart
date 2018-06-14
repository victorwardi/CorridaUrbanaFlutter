import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../dao/corrida_dao.dart';

class Corrida {

/*   "id": 12943,
        "titulo": "Circuito das Estações 2018 - Primavera - RJ",
        "link": "https://www.corridaurbana.com.br/corrida/circuito-das-estacoes-primavera-rj/",
        "dia": "30",
        "mes": "09",
        "ano": "18",
        "mesExtenso": "setembro",
        "data": "30/09/18",
        "cidade": " Rio de Janeiro",
        "estado": "Rio de Janeiro",
        "uf": "RJ",
        "local": " Rio de Janeiro - RJ",
        "endereco": "Aterro do Flamengo - Rio de Janeiro",
        "imagem": false
 */

  String titulo;
  String estado;
  String mes;
  String mesExtenso;
  String dia;
  String data;
  String cidade;
  String uf;
  String local;
  String endereco;
  String distancias;
  String valor;
  String site;
  String horario;
  double mapaLatitude;
  double mapaLongitude;
 
}

main() {
  CorridaDao dao = new CorridaDao();
  Future<List<Corrida>> corridasList = dao.getCorridasPorEstado('RJ');

  corridasList.then((List<Corrida> corridas) =>corridas.forEach((corrida) => print(corrida.mapa)));
}
