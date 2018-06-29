import 'package:corrida_urbana/dao/corrida_dao.dart';
import 'package:corrida_urbana/model/corrida.dart';
import 'package:corrida_urbana/model/mes.dart';
import 'package:corrida_urbana/screen/corrida_screen.dart';
import 'package:flutter/material.dart';

CorridaDao corridaDao = new CorridaDao();


class CorridasMeses extends StatelessWidget {
  const CorridasMeses({
    Key key,
    @required this.corridas,
    @required this.meses,
  
  }) : super(key: key);

  final List<Mes> meses;
  final List<Corrida> corridas;

 

  @override
  Widget build(BuildContext context) {
    return Expanded(child: getListExpansion());
  }

//show runs in a Expandable List
  Widget getListExpansion() {
     
    //show open only the first month  
    bool mostraCorridas = true;

    return new ListView.builder(
      shrinkWrap: true,
      itemCount: meses == null ? 0 : meses.length,
      itemBuilder: (BuildContext context, int index) {
        //check if there is any corrida in this month
        List<Corrida> corridasMes = this
            .corridas
            .where((c) => corridaDao.filtrarPorMes(c, meses[index].numero))
            .toList();

        if (corridasMes.length != 0) {
          var retorno = Column(
            children: <Widget>[
              ExpansionTile(
                initiallyExpanded: mostraCorridas,
                leading: Icon(Icons.date_range),
                title: Padding(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        meses[index].nome,
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                children: <Widget>[
                  getListViewCorridasPorMes(corridasMes),
                ],
              ),
            ],
          );

          //close all otther months
          mostraCorridas = false;
          return retorno;
        } else {
          return Container(width: 0.0, height: 0.0);
        }
      },
    );
  }

// get all runs for each month
  Widget getListViewCorridasPorMes(List<Corrida> corridasMes) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemExtent: 80.0,
      itemCount: corridasMes.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new ListTile(
              title: _corrida(corridasMes[index]),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new CorridaDetail(corridasMes[index])));
              },
            ),
          ],
        );
      },
    );
  }

//build how the runs will be show in interface
  Widget _corrida(Corrida corrida) {
    return Container(
      child: Center(
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(0.0),
              height: 50.0,
              width: 50.0,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      corrida.mesExtenso.substring(0, 3).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.teal,
                    constraints: BoxConstraints.expand(height: 20.0),
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    corrida.dia,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  corrida.titulo,
                  softWrap: true,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//Show  runs  in a list view - this is not used
  Widget getListView() {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: meses == null ? 0 : meses.length,
      itemBuilder: (BuildContext context, int index) {
        //check if there is any corrida in this month
        List<Corrida> corridasMes = this
            .corridas
            .where((c) => corridaDao.filtrarPorMes(c, meses[index].numero))
            .toList();

        return corridasMes.length == 0
            ? Container(width: 0.0, height: 0.0)
            : Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          meses[index].nome,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      decoration: new BoxDecoration(),
                      constraints: BoxConstraints.expand(height: 60.0),
                    ),
                  ),
                  getListViewCorridasPorMes(corridasMes)
                ],
              );
      },
    );
  }
}
