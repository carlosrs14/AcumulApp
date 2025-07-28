import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

final Map<String, IconData> categoryIcons = {
  'restaurante': MdiIcons.silverwareForkKnife,
  'cafeteria': MdiIcons.coffee,
  'bar': MdiIcons.beer,
  'tiendaderopa': MdiIcons.tshirtCrew,
  'salondebelleza': MdiIcons.scissorsCutting,
  'gimnasio': MdiIcons.dumbbell,
  'serviciosprofesionales': MdiIcons.briefcaseAccount,
  'mascotas': MdiIcons.dog,
};

String normalize(String input) {
  return input
      .toLowerCase()
      .replaceAll(RegExp(r'[áàäâ]'), 'a')
      .replaceAll(RegExp(r'[éèëê]'), 'e')
      .replaceAll(RegExp(r'[íìïî]'), 'i')
      .replaceAll(RegExp(r'[óòöô]'), 'o')
      .replaceAll(RegExp(r'[úùüû]'), 'u')
      .replaceAll(RegExp(r'\s+'), '')
      .trim();
}
