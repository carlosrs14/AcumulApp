import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/screens/user/business_cards_screen.dart';
import 'package:acumulapp/screens/user/business_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BusinessListItem extends StatelessWidget {
  final Business business;
  final User user;

  const BusinessListItem({super.key, required this.business, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BusinessInfo(
                business: business,
                user: user,
              ),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLogo(context),
              SizedBox(width: 12),
              _buildBusinessInfo(context),
              _buildViewCardsButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      padding: EdgeInsets.all(1),
      child: ClipOval(
        child: Image.network(
          business.logoIconoUrl ?? " ",
          fit: BoxFit.cover,
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
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Center(
                child: Text(
                  business.name[0],
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBusinessInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            business.name,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(business.direction ?? ''),
          SizedBox(height: 4),
          RatingBarIndicator(
            rating: business.ratingAverage!,
            itemBuilder: (context, _) => Icon(
              MdiIcons.star,
              color: Theme.of(context).colorScheme.primary,
            ),
            itemCount: 5,
            itemSize: 20.0,
          ),
        ],
      ),
    );
  }

  Widget _buildViewCardsButton(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 80,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BusinessCardsScreen(
                business: business,
                user: user,
              ),
            ),
          );
        },
        icon: Icon(MdiIcons.cardsOutline, size: 20),
        iconAlignment: IconAlignment.end,
        label: Text("Ver"),
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}
