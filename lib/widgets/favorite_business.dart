import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/business_provider.dart';
import 'package:acumulapp/providers/category_provider.dart';
import 'package:acumulapp/screens/user/business_info_screen.dart';
import 'package:flutter/material.dart';

class FavoriteBusiness extends StatefulWidget {
  final User user;
  final List<Business> businesses;
  const FavoriteBusiness({super.key, required this.user, required this.businesses});

  @override
  State<FavoriteBusiness> createState() => _FavoriteBusinessState();
}

class _FavoriteBusinessState extends State<FavoriteBusiness> {
  final BusinessProvider businessProvider = BusinessProvider();
  final CategoryProvider categoryProvider = CategoryProvider();
  


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.businesses.length,
      itemBuilder: (context, index) {
        Business business = widget.businesses[index];
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BusinessInfo(
                  business: business,
                  user: widget.user,
                ),
              ),
            );
          },
          child: Container(
            height: 20,
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
          ),
        );
      },
    );
  }
  
}
