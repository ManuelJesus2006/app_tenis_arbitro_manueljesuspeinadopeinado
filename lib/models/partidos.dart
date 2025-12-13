// To parse this JSON data, do
//
//     final partidosResponse = partidosResponseFromJson(jsonString);

import 'dart:convert';

PartidosResponse partidosResponseFromJson(String str) => PartidosResponse.fromJson(json.decode(str));

String partidosResponseToJson(PartidosResponse data) => json.encode(data.toJson());

class PartidosResponse {
    String status;
    List<Partidos> partidos;

    PartidosResponse({
        required this.status,
        required this.partidos,
    });

    factory PartidosResponse.fromJson(Map<String, dynamic> json) => PartidosResponse(
        status: json["status"],
        partidos: List<Partidos>.from(json["data"].map((x) => Partidos.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(partidos.map((x) => x.toJson())),
    };
}

class Partidos {
    int id;
    String torneo;
    String ronda;
    String jugador1;
    String jugador2;
    String fotoJugador1;
    String fotoJugador2;
    String? resultado;

    Partidos({
        required this.id,
        required this.torneo,
        required this.ronda,
        required this.jugador1,
        required this.jugador2,
        required this.fotoJugador1,
        required this.fotoJugador2,
        required this.resultado,
    });

    factory Partidos.fromJson(Map<String, dynamic> json) => Partidos(
        id: json["id"],
        torneo: json["torneo"],
        ronda: json["ronda"],
        jugador1: json["jugador1"],
        jugador2: json["jugador2"],
        fotoJugador1: json["fotoJugador1"],
        fotoJugador2: json["fotoJugador2"],
        resultado: json["resultado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "torneo": torneo,
        "jugador1": jugador1,
        "jugador2": jugador2,
        "fotoJugador1": fotoJugador1,
        "fotoJugador2": fotoJugador2,
        "resultado": resultado,
    };
}
