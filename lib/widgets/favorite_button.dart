import 'package:acumulapp/providers/business_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final int idBusiness;
  const FavoriteButton({super.key, required this.idBusiness, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    BusinessProvider businessProvider = BusinessProvider();
    
    return ElevatedButton(
      onPressed: () {
        businessProvider.updateFavorite(idBusiness);
      },
      child: Icon(
        MdiIcons.flag
      )    
    );
  }
}