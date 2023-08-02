import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:monde/models/individu.dart';
import 'package:monde/constants.dart';

class Monde {
  List<Individu> population;
  List<List<int>> nourriture;
  int tour;
  int populationSize;
  Monde({required this.population, required this.nourriture, required this.tour}) :
    populationSize = population.length;

  static final random = Random();

  factory Monde.init() {
    return Monde(
      population: List.generate(N, (index) => Individu(i: random.nextInt(M), j: random.nextInt(M), pv: 200)),
      nourriture: List.generate(M, (index) => List.generate(M, (_) => 0)),
      tour: 0
    );
  }

  void nouveau() {
    //EDEN FOOD
    final int newX = yE - random.nextInt(M) % Ed;
    final int newY = yE + random.nextInt(M) % Ed;
    nourriture[newX][newY] += 1;

    //RANDOM FOOD
    nourriture[random.nextInt(M)][random.nextInt(M)] += 1;

    for (int i = 0; i < population.length; i++) {
      final individu = population[i];
      if (individu.pv > 0) {
        individu.move();
      }
      if (nourriture[individu.i][individu.j] > 0) {
        individu.eat();
        nourriture[individu.i][individu.j] -= 1;
      }
      if (individu.pv >= EMAX) {
        population.removeAt(i);
        final firstKid = individu.kid();
        final secondKid = individu.kid(mutation: true);
        population.addAll([firstKid, secondKid]);
      }
    }
    tour += 1;
  }

  Map<String, dynamic> toJson() {
    return {
      "population": population.map((e) => e.toJson()).toList(),
      "nourriture": nourriture,
      "tour": tour,
      "populationSize": populationSize
    };
  }

  factory Monde.fromJson(Map<String, dynamic> json) {
    return Monde(
      population: (json["population"] as List<dynamic>).map((e) => Individu.fromJson(e)).toList(), 
      nourriture: (json["nourriture"] as List<dynamic>).map((e) => List<int>.from(e as List<dynamic>)).toList(), 
      tour: json["tour"]
    );
  }

  Future<void> save() async {

    final saveFile = File('save.json');
    if (await saveFile.exists()) {
      await saveFile.delete();
    }
    await saveFile.create();

    final sink = saveFile.openWrite(mode: FileMode.append);
    final content = jsonEncode(toJson());
  
    sink.write(content);
    await sink.close();
  }

  static Future<Monde> charge() async {
    final file = File('save.json');
    final content = await file.readAsString();
    return Monde.fromJson(jsonDecode(content));
  }

  void affiche() {
    print("Tour: $tour");
    List<List<int>> copy = List.from(nourriture);
    List<List<String>> table = copy.map((row) => row.map((element) => element.toString().padLeft(4)).toList()).toList();
    for (Individu individu in population) {
      table[individu.i][individu.j] = "X".padLeft(4); 
    }
    for (List<dynamic> row in table) {
      print(row.join(" "));
    }
    print("\nPopulation Size = ${population.length}");
  }
}