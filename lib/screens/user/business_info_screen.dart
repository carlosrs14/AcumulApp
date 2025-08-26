import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/rating_provider.dart';
import 'package:acumulapp/screens/category_business_screen.dart';
import 'package:acumulapp/screens/user/business_cards_screen.dart';
import 'package:acumulapp/utils/categories_icons.dart';
import 'package:acumulapp/widgets/links_redes_screen.dart';
import 'package:acumulapp/widgets/rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BusinessInfo extends StatefulWidget {
  final Business business;
  final User user;
  const BusinessInfo({super.key, required this.business, required this.user});

  @override
  State<BusinessInfo> createState() => _BusinessInfoState();
}

class _BusinessInfoState extends State<BusinessInfo> {
  final RatingProvider ratingProvider = RatingProvider();
  late double screenWidth;
  double selectedRating = 0;

  Map<String, IconData> iconosRedes = {
    "website": MdiIcons.web,
    "facebook": MdiIcons.facebook,
    "instagram": MdiIcons.instagram,
    "whatsapp": MdiIcons.whatsapp,
  };
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(12),
          child: cuerpo(),
        ),
      ),
    );
  }

  Widget cuerpo() {
    return SafeArea(
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 3,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          imagenNegocio(),
                          SizedBox(height: 30),
                          name(),

                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: CategoryGrid(
                                  categories: widget.business.categories!,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  widget.business.direction ?? "Sin dirección",
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: RatingSelector(
                          onRatingChanged: (value) {
                            setState(() {
                              selectedRating = value;
                            });
                            ratingConfirmacion(value);
                          },
                        ),
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.business.descripcion ?? " "),
                              ],
                            ),
                          ),

                          SocialButtonsColumn(
                            buttons: widget.business.links!
                                .map(
                                  (l) => SocialButton(
                                    icon:
                                        iconosRedes[normalize(l.redSocial)] ??
                                        MdiIcons.web,
                                    url: l.url,
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      buttom(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget imagenNegocio() {
    return Container(
      width: 120,
      height: 120,
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(70),
      ),
      child: Center(
        child: ClipOval(
          child: Image.network(
            widget.business.logoIconoUrl ?? ' ',
            fit: BoxFit.cover,
            width: 120,
            height: 120,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Text(
                widget.business.name[0],
                style: TextStyle(
                  fontSize: 40,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget name() {
    return Text(
      widget.business.name,
      style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
    );
  }

  Widget ratingbar() {
    return RatingBarIndicator(
      rating: widget.business.ratingAverage!,
      itemBuilder: (context, index) => Icon(MdiIcons.star, color: Colors.amber),
      itemCount: 5,
      itemSize: screenWidth * 0.065,
      direction: Axis.horizontal,
    );
  }

  void ratingConfirmacion(double value) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar calificacion'),
        content: Text('¿Estás seguro de enviar esta calificacion: $value'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
    if (!mounted) return;

    if (confirmed == true) {
      final success = await ratingProvider.create(widget.business.id, value);
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Calificacion guardada con exito')),
        );
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error')));
      }
    }
  }

  Widget buttom() {
    return Container(
      width: screenWidth * 0.6,
      height: 55,
      padding: EdgeInsets.all(1),

      child: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BusinessCardsScreen(
                  business: widget.business,
                  user: widget.user,
                ),
              ),
            );
          },
          icon: Icon(MdiIcons.cardsOutline, size: 20),
          iconAlignment: IconAlignment.end,
          label: Text("View cards"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: TextStyle(fontSize: 14),
            elevation: 4,
          ),
        ),
      ),
    );
  }
}
