import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/screens/user/home_client/business_list_item.dart';
import 'package:flutter/material.dart';

class BusinessList extends StatelessWidget {
  final List<Business> businesses;
  final User user;

  const BusinessList({super.key, required this.businesses, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: businesses.length,
      itemBuilder: (context, index) {
        return BusinessListItem(
          business: businesses[index],
          user: user,
        );
      },
    );
  }
}
