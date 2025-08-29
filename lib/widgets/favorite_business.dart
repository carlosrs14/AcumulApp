import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/business_provider.dart';
import 'package:acumulapp/providers/category_provider.dart';
import 'package:flutter/material.dart';

class FavoriteBusiness extends StatefulWidget {
  final User user;
  const FavoriteBusiness({super.key, required this.user});

  @override
  State<FavoriteBusiness> createState() => _FavoriteBusinessState();
}

class _FavoriteBusinessState extends State<FavoriteBusiness> {
  final BusinessProvider businessProvider = BusinessProvider();
  final CategoryProvider categoryProvider = CategoryProvider();
  
  List<Business> businesses = [];

  String selectedCategory = 'All';
  bool _isLoadingBusiness = true;
  bool _errorBusiness = false;

  int currentPage = 1;
  int itemsPerPage = 10;
  int totalPage = 10;

    @override
  void initState() {
    super.initState();
    _loadBusiness();
  }

  @override
  Widget build(BuildContext context) {
    
    for (var i = 0; i < businesses.length * 2; i++) {
      businesses.add(businesses[0]);
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: businesses.length,
      itemBuilder: (context, index) {
        Business business = businesses[index];
        return InkWell(
          onTap: () {
            // print("${business.id}");
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
  
  Future<void> _loadBusiness() async {
    if (!mounted) return;
    setState(() {
      _isLoadingBusiness = true;
      _errorBusiness = false;
    });
    try {
      final paginationData = await businessProvider.all(
        null,
        null,
        currentPage,
        itemsPerPage,
      );

      if (!mounted) return;
      setState(() {
        businesses = paginationData!.list as List<Business>;
        currentPage = paginationData.currentPage;
        itemsPerPage = paginationData.pageSize;
        totalPage = paginationData.totalPages;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorBusiness = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingBusiness = false;
        });
      }
    }
  }
}
