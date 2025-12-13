import 'dart:convert';

import 'package:http/http.dart';
import 'package:tennis_pottema3/models/partidos.dart';

class PartidosService {
  final String _url = 'https://backendtenis-production-96a9.up.railway.app/api/v1/partidos';
  Future<List<Partidos>> getPartidosSinJugar() async {
    List<Partidos> partidos = [];
    Uri uri = Uri.parse(_url);
    Response response = await get(uri);
    if (response.statusCode != 200) return partidos;
    PartidosResponse partidosResponse = partidosResponseFromJson(response.body);
    partidos.addAll(
      partidosResponse.partidos.where((partido) => partido.resultado == null),
    );
    return partidos;
  }

  Future<int> guardarResultadoPartido(String resultado, Partidos partido) async{
    Uri uri = Uri.parse('$_url/${partido.id}');
    Response response = await patch(uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"resultado":resultado})
    ); 
    return response.statusCode;
  }
}
