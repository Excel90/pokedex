import 'package:flutter/material.dart';
import 'package:flutter_application_pokedex/services/api.dart';
import 'package:http/retry.dart';

void main() {
  runApp(const PokedexHome());
}

class PokedexHome extends StatelessWidget {
  const PokedexHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pokedex',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<PokemonList>? pokemonList;

  @override
  void initState() {
    super.initState();
    pokemonList = PokeApi().fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text(
          'Pokedex',
          style: TextStyle(fontFamily: "Pokemon", color: Colors.black),
        ),
      ),
      body: FutureBuilder<PokemonList>(
        future: pokemonList,
        builder: (context, pokemonlist) {
          if (pokemonlist.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (pokemonlist.hasData) {
              return ListView.builder(
                itemCount: pokemonlist.data!.pokemon?.length,
                itemBuilder: (context, index) {
                  var id = index + 1;
                  return ListTile(
                    title: Row(
                      children: [
                        Image.network(
                          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
                          fit: BoxFit.cover,
                          scale: 2,
                          width: 150,
                          height: 50,
                          alignment: FractionalOffset(0, 0.4),
                        ),
                        Text(
                          pokemonlist.data!.pokemon![index].name,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          var url = pokemonlist.data!.pokemon![index].url;
                          return DetailPage(url: url);
                        }),
                      );
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Text('Failed to load data wtf'),
              );
            }
          }
        },
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final String? url;
  const DetailPage({ Key? key, required this.url }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future<PokemonDetail>? pokemonDetail;
  @override
  void initState() {
    super.initState();
    pokemonDetail = PokeApi().fetchdetail(widget.url);}
    
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder<PokemonDetail>(
      future: pokemonDetail,
      builder: (context, pokemonData) {
        if (pokemonData.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (pokemonData.hasData) {
            var name = pokemonData.data!.name.toString();
            var listtypes = pokemonData.data!.types;
            var listabilities = pokemonData.data!.abilities;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                iconTheme:  IconThemeData(color: Colors.black),
                title: Text((name[0].toUpperCase() + name.substring(1)),
                style: TextStyle(color: Colors.black, fontFamily: 'Pokemon'),
                )
              ),
              body: ListView(
                children: [
                  Center(
                    child: Image.network(pokemonData.data!.imgUrl.toString()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text((name[0].toUpperCase() + name.substring(1)), style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold)),                  
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              for(var type in listtypes! ) Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: 
                                Text(type, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text("Basic Data", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Height", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Weight", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ]
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(pokemonData.data!.height.toString() + " m", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(pokemonData.data!.weight.toString() + " kg", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ]
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text("Abilities", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: <Widget>[
                              for(var ability in listabilities! ) 
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: 
                                Text(ability, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                              ),
                            ],
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text("Stats", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Hp", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Attack", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Defense", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Special Attack", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Special Defense", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Speed", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ]
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(pokemonData.data!.stats!.hp.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(pokemonData.data!.stats!.attack.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(pokemonData.data!.stats!.defense.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(pokemonData.data!.stats!.specialAttack.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(pokemonData.data!.stats!.specialDefense.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(pokemonData.data!.stats!.speed.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ]
                      )
                    ],
                  ),
                ]),
            );
          }
          else {
            return Center(
              child: Text('Failed to load data wtf'),
            );
          }
        }
      }
    );
  }
}