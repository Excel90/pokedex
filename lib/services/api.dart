import 'dart:convert';
import 'package:http/http.dart' as http;

class PokeApi {
  Future<PokemonList> fetchdata() async {
    final Uri uri =
        Uri.parse('https://pokeapi.co/api/v2/pokemon/?offset=0&limit=1126');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return PokemonList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data fetchdata');
    }
  }

  Future<PokemonDetail> fetchdetail(url) async {
    final Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    var data = PokemonDetail.fromJson(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception('Failed to load data fetchdetail');
    }
  }
}

class PokemonList {
  List<Pokemon>? pokemon;
  PokemonList({
    this.pokemon,
  });

  PokemonList.fromJson(Map<String, dynamic> json) {
    pokemon = <Pokemon>[];
    json['results'].forEach((element) {
      pokemon!.add(Pokemon(name: element['name'], url: element['url']));
    });
  }
}

class Pokemon {
  String name;
  String url;
  Pokemon({this.name = '', this.url = ''});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      url: json['url'],
    );
  }
}

class PokemonDetail {
  String? name;
  String? imgUrl;
  List<String>? types;
  double? height;
  double? weight;
  List<String>? abilities;
  PokemonStat? stats;
  PokemonDetail({this.name = '', this.imgUrl = '', this.types = const []});

  void setname(String name) {
    this.name = name;
  }
  void setimgurl(String imgUrl) {
    this.imgUrl = imgUrl;
  }
  void settypes(List<String> types) {
    this.types = types;
  }

  PokemonDetail.fromJson(Map<String, dynamic> json) {
    types = <String>[];
    json['types'].forEach((element) {
      types!.add(element['type']['name'].toString());
    });

    abilities = <String>[];
    json['abilities'].forEach((element) {
      abilities!.add(element['ability']['name'].toString());
    });
    setimgurl(json['sprites']['other']['official-artwork']['front_default']);
    setname(json['name']);
    this.height = json['height']/10;
    this.weight = json['weight']/10;
    stats = PokemonStat.fromJson(json);
    
  }
}

class PokemonStat{
  int? hp;
  int? attack;
  int? defense;
  int? specialAttack;
  int? specialDefense;
  int? speed;

  PokemonStat({this.attack,this.defense,this.hp,this.specialAttack,this.specialDefense,this.speed});


  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      hp: json['stats'][0]['base_stat'],
      attack: json['stats'][1]['base_stat'],
      defense: json['stats'][2]['base_stat'],
      specialAttack: json['stats'][3]['base_stat'],
      specialDefense: json['stats'][4]['base_stat'],
      speed: json['stats'][5]['base_stat'],
    );
  }
}
