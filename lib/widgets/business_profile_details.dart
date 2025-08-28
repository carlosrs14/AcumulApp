import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/widgets/business_logo.dart';
import 'package:acumulapp/utils/redes_icons.dart';
import 'package:acumulapp/widgets/category_business_screen.dart';
import 'package:acumulapp/widgets/links_redes_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BusinessProfileDetails extends StatelessWidget {
  final Business business;

  const BusinessProfileDetails({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Center(child: BusinessLogo(business: business)),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    business.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 10),
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
                        business.direction ?? "Sin dirección",
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        textAlign: TextAlign.center,
                        business.ratingAverage.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                CategoryGrid(categories: business.categories!),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(business.descripcion ?? " "),
                        ],
                      ),
                    ),
                    SocialButtonsColumn(
                      buttons: business.links!
                          .map(
                            (l) => SocialButton(
                              icon: iconosRedes[l.redSocial] ?? MdiIcons.web,
                              url: l.url,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 75),
      ],
    );
  }
}
