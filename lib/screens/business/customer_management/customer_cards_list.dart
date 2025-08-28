import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/screens/business/customer_management/active_card.dart';
import 'package:acumulapp/screens/business/customer_management/completed_card.dart';
import 'package:acumulapp/screens/business/customer_management/expired_card.dart';
import 'package:acumulapp/screens/business/customer_management/inactive_card.dart';
import 'package:acumulapp/screens/business/customer_management/redeemed_card.dart';
import 'package:flutter/material.dart';

class CustomerCardsList extends StatelessWidget {
  final List<UserCard> userCards;
  final int selectedState;
  final Function(String, int) onAddStamps;
  final Function(String) onRedeem;
  final Function(String) onActivate;

  const CustomerCardsList({
    super.key,
    required this.userCards,
    required this.selectedState,
    required this.onAddStamps,
    required this.onRedeem,
    required this.onActivate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userCards.length,
      itemBuilder: (context, index) {
        final UserCard userCard = userCards[index];
        return _buildCard(userCard);
      },
    );
  }

  Widget _buildCard(UserCard userCard) {
    switch (selectedState) {
      case 1:
        return ActiveCard(
          userCard: userCard,
          onAddStamps: () => onAddStamps(
            userCard.code!,
            userCard.businessCard!.maxStamp - userCard.currentStamps!,
          ),
        );
      case 2:
        return CompletedCard(
          userCard: userCard,
          onRedeem: () => onRedeem(userCard.code!),
        );
      case 3:
        return RedeemedCard(userCard: userCard);
      case 4:
        return InactiveCard(
          userCard: userCard,
          onActivate: () => onActivate(userCard.code!),
        );
      case 5:
        return ExpiredCard(userCard: userCard);
      default:
        return Container();
    }
  }
}
