import 'package:flutter/material.dart';
import 'package:tennis_pottema3/models/partidos.dart';
import 'package:tennis_pottema3/presentation/screens/home_screen.dart';
import 'package:tennis_pottema3/services/partidos_service.dart';

class ArbitroScreen extends StatefulWidget {
  const ArbitroScreen({super.key, required this.partido});

  final Partidos partido;

  @override
  State<ArbitroScreen> createState() => _ArbitroScreenState();
}

class _ArbitroScreenState extends State<ArbitroScreen> {
  //Variables de lógica general del partido
  int setsJ1 = 0;
  int setsJ2 = 0;
  int juegosJ1 = 0;
  int juegosJ2 = 0;
  int puntosJ1 = 0;
  int puntosJ2 = 0;
  //Variable String para enviar resultado a la api, en el caso de que el usuario quiera
  String resultadoPartido = "";

  String? recibirNombreGanador() {
    if (setsJ1 == 3)
      return widget.partido.jugador1;
    else if (setsJ2 == 3)
      return widget.partido.jugador2;
    return null;
  }

  void _dialogCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Estás seguro de cancelar este partido?'),
        content: Text('No se pueden recuperar los resultados'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text('Soy consciente y salir'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Seguir arbitrando'),
          ),
        ],
      ),
    );
  }

  void _dialogWinner(BuildContext context, String resultadoFinal) {
    showDialog(
      context: context,
      barrierDismissible: false, //Para evitar toque accidental fuera
      builder: (context) => AlertDialog(
        title: Text('Fin el partido con victoria de ${recibirNombreGanador()}'),
        content: Text('''¿Desea guardar el resultado en la base de datos? --> $resultadoFinal
        La acción tardará aproximadamente 1 segundo en completarse'''),
        actions: [
          TextButton(
            onPressed: () async {
              await PartidosService().guardarResultadoPartido(resultadoFinal, widget.partido);
              await Future.delayed(Duration(milliseconds: 500)); //Añado tiempo para evitar bugs al volver a la pantalla principal en producción
              
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text('Si, guardar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
              );
            },
            child: Text('No, salir sin guardar resultado'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _dialogCancel(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Text(
                    widget.partido.torneo,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(widget.partido.ronda, style: TextStyle(fontSize: 20)),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    image: NetworkImage(widget.partido.fotoJugador1),
                    height: 200,
                  ),
                  Column(
                    children: [
                      Text(
                        widget.partido.jugador1,
                        style: TextStyle(fontSize: 25),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            setsJ1.toString(),
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            juegosJ1.toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                          SizedBox(width: 10),
                          Text(
                            puntosJ1 == 41 ? 'AD' : puntosJ1.toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        widget.partido.jugador2,
                        style: TextStyle(fontSize: 25),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            setsJ2.toString(),
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            juegosJ2.toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                          SizedBox(width: 10),
                          Text(
                            puntosJ2 == 41 ? 'AD' : puntosJ2.toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Image(
                    image: NetworkImage(widget.partido.fotoJugador2),
                    height: 200,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    //Botón adición puntos jugador 1
                    onPressed: () {
                      if (juegosJ1 != 6 || juegosJ2 != 6) {
                        switch (puntosJ1) {
                          case 0:
                          case 15:
                            puntosJ1 += 15;
                            break;
                          case 30:
                            puntosJ1 += 10;
                            break;
                          case 40: // Comprobaciones deuce jugador 1
                            // Si ambos están en 40, ventaja para el jugador 1
                            if (puntosJ2 == 40) {
                              puntosJ1 = 41;
                              puntosJ2 = 40;
                            }
                            // Si el jugador 2 tenía ventaja volvemos a deuce
                            else if (puntosJ2 == 41) {
                              puntosJ2 = 40;
                              puntosJ1 = 40;
                            }
                            //Si no hay deuce
                            else {
                              juegosJ1++;
                              puntosJ1 = 0;
                              puntosJ2 = 0;
                            }
                            break;
                          case 41:
                            // Si nuestro jugador ya estaba en ventaja de antes gana el juego
                            juegosJ1++;
                            puntosJ1 = 0;
                            puntosJ2 = 0;
                            break;
                        }
                      } else {
                        //En este caso tiebreak
                        puntosJ1++;
                        if ((puntosJ1 > 7 && puntosJ2 == puntosJ1 - 2) ||
                            (puntosJ1 == 7 && puntosJ2 <= 5)) {
                          //Si los puntos son mayores o iguales a
                          juegosJ1++;
                          setsJ1++;
                          resultadoPartido += '$juegosJ1/$juegosJ2,';
                          puntosJ1 = 0;
                          puntosJ2 = 0;
                          juegosJ1 = 0;
                          juegosJ2 = 0;
                        }
                      }
                      if (juegosJ1 == 6 && juegosJ2 <= 4) {
                        //Si hay diferencia de se añade el set ganado
                        
                        setsJ1++;
                        resultadoPartido += '$juegosJ1/$juegosJ2,';
                        juegosJ2 = 0;
                        juegosJ1 = 0;
                      } else if (juegosJ1 == 7 && juegosJ2 <= 5) {
                        //Si hay diferencia de se añade el set ganado
                        setsJ1++;
                        resultadoPartido += '$juegosJ1/$juegosJ2,';
                        juegosJ2 = 0;
                        juegosJ1 = 0;
                      }

                      if (setsJ1 == 2){
                        resultadoPartido = resultadoPartido.substring(0, resultadoPartido.length - 1);
                        _dialogWinner(context, resultadoPartido);
                      } 
                      setState(() {});
                    },
                    child: Text('Añadir punto'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(20.0),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  TextButton(
                    //Botón adición puntos jugador 2
                    onPressed: () {
                      if (juegosJ1 != 6 || juegosJ2 != 6) {
                        switch (puntosJ2) {
                          case 0:
                          case 15:
                            puntosJ2 += 15;
                            break;
                          case 30:
                            puntosJ2 += 10;
                            break;
                          case 40: // Comprobaciones deuce jugador 2
                            // Si ambos están en 40, ventaja para el jugador 2
                            if (puntosJ1 == 40) {
                              puntosJ2 = 41;
                              puntosJ1 = 40;
                            }
                            // Si el jugador 1 tenía ventaja volvemos a deuce
                            else if (puntosJ1 == 41) {
                              puntosJ1 = 40;
                              puntosJ2 = 40;
                            }
                            //Si no hay deuce
                            else {
                              juegosJ2++;
                              puntosJ1 = 0;
                              puntosJ2 = 0;
                            }
                            break;
                          case 41:
                            // Si nuestro jugador ya estaba en ventaja de antes gana el juego
                            juegosJ2++;
                            puntosJ1 = 0;
                            puntosJ2 = 0;
                            break;
                        }
                      } else {
                        //En este caso tiebreak
                        puntosJ2++;
                        if ((puntosJ2 > 7 && puntosJ1 == puntosJ2 - 2) ||
                            (puntosJ2 == 7 && puntosJ1 <= 5)) {
                          //Si los puntos son mayores o iguales a
                          juegosJ2++;
                          setsJ2++;
                          resultadoPartido += '$juegosJ1/$juegosJ2,';
                          puntosJ1 = 0;
                          puntosJ2 = 0;
                          juegosJ1 = 0;
                          juegosJ2 = 0;
                        }
                      }

                      if (juegosJ2 == 6 && juegosJ1 <= 4) {
                        //Si hay diferencia de se añade el set ganado
                        setsJ2++;
                        resultadoPartido += '$juegosJ1/$juegosJ2,';
                        juegosJ2 = 0;
                        juegosJ1 = 0;
                      } else if (juegosJ2 == 7 && juegosJ1 <= 5) {
                        //Si hay diferencia de se añade el set ganado
                        setsJ2++;
                        resultadoPartido += '$juegosJ1/$juegosJ2,';
                        juegosJ2 = 0;
                        juegosJ1 = 0;
                      }

                      if (setsJ2 == 2){
                        resultadoPartido = resultadoPartido.substring(0, resultadoPartido.length - 1);

                        _dialogWinner(context, resultadoPartido);
                      } 
                      setState(() {});
                    },
                    child: Text('Añadir punto'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(20.0),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
