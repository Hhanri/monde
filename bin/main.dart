import 'dart:math';

import 'package:monde/models/monde.dart';

final Random random = Random();

void main(List<String> arguments) async {
  Monde monde = Monde.init();
  //Monde monde = await Monde.charge();
  for (int i = 0; i<1000; i++) {
    monde.nouveau();
  }
  monde.affiche();
  await monde.save();
}