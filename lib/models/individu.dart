import 'dart:math';

import 'package:monde/constants.dart';

class Individu {
  int i, j, pv;
  int prevDirection = 0;
  List<int> genomes;

  Individu({required this.i, required this.j, required this.pv,}) :  
    genomes = List.generate(8, (index) => Random().nextInt(50)+1);

  void move() {
    final int randomDirection = _randomChoices()!;
    final newDirection = (prevDirection + randomDirection)%8;
    i = (i + dx[newDirection] + M)%M;
    j = (j + dy[newDirection] + M)%M;
    pv -= 1;
  }

  void eat() {
    pv += 10;
  }

  int get _genomesSum => genomes.reduce((a, b) => a + b);

  static final Random random = Random();

  static const List<int> dx = [0, 1, 1, 1, 0, -1, -1, -1];
  static const List<int> dy = [-1, -1, 0, 1, 1, 1, 0, -1];

  int? _randomChoices() {
    int rand = random.nextInt(_genomesSum);
    for (int i = 0; i < genomes.length; i++) {
      if (rand < genomes[i]) return i;
      rand -= genomes[i];
    }
    return null;
  }

  Individu kid({bool mutation = false}) {
    final kid = Individu(
      i: i, 
      j: j,
      pv: pv ~/ 2
    );
  
    if (mutation) {
      const mutations = [-1, 0, 1];
      final value = mutations[random.nextInt(3)];

      final int genomeIndexWithMutation = random.nextInt(8);
      final int currentGenome = genomes[genomeIndexWithMutation];
      kid.genomes[genomeIndexWithMutation] = max(currentGenome + value, 1);
    }

    return kid;
  }

  Map<String, dynamic> toJson() {
    return {
      "i": i,
      "j": j,
      "pv": pv,
      "prevDirection": prevDirection,
      "genomes": genomes
    };
  }

  factory Individu.fromJson(Map<String, dynamic> json) {
    return Individu(
      i: json["i"],
      j: json["j"],
      pv: json["pv"],
    )..genomes = List<int>.from(json["genomes"] as List<dynamic>);
  }

  @override
  String toString() {
      return "Individu($i, $j, $pv)";
  }
}