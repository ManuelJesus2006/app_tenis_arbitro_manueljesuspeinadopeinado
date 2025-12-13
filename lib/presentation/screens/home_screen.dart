import 'package:flutter/material.dart';
import 'package:tennis_pottema3/models/partidos.dart';
import 'package:tennis_pottema3/presentation/screens/arbitro_screen.dart';
import 'package:tennis_pottema3/services/partidos_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Elige el partido a arbitrar',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: FutureBuilder(
                    future: PartidosService().getPartidosSinJugar(), 
                    builder: (BuildContext context, AsyncSnapshot<List<Partidos>> snapshot){
                      if (snapshot.hasData) {
                        if (snapshot.data!.isNotEmpty) return ListaDePartidos(partidos: snapshot.data!,);
                        else{
                          return Center(
                          child: Text(
                            'No hay partidos disponibles para arbitrar',
                          ),
                        );
                        } 
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return LinearProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Ha ocurrido un error',
                          ),
                        );
                      }
                      return SizedBox();
                    }
                    
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListaDePartidos extends StatelessWidget {
  const ListaDePartidos({super.key, required this.partidos});

  final List<Partidos> partidos;
  
void _openModeDialog(BuildContext context, Partidos partido){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('¿Estás seguro de arbitrar: ${partido.jugador1} contra ${partido.jugador2}?'),
        content: Text(
          '''Ya no hay vuelta atrás hasta que termine el partido'''
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: 
            (context) => ArbitroScreen(partido: partido,))), child: const Text('Arbitrar'),),
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Salir'))
        ],
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: partidos.length,
      itemBuilder: (context, i){
        return GestureDetector(
          onTap: () {
            _openModeDialog(context, partidos[i]);
          },
          child: Card(
            color: Colors.white,
            child: Column(
              children: [
                Text(partidos[i].torneo,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900
                ),),
                SizedBox(
                  height: 10,
                ),
                Text(partidos[i].ronda),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image(image: NetworkImage(partidos[i].fotoJugador1,), height: 200,),
                    Text(partidos[i].jugador1, style: TextStyle(
                      fontSize: 22, 
                    ),),
                    Text('VS',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),),
                    Text(partidos[i].jugador2,
                    style: TextStyle(
                      fontSize: 22
                    ),),
                    Image(image: NetworkImage(partidos[i].fotoJugador2), height: 200),
                    
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
