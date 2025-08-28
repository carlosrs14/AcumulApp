import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/screens/user/client_cards/client_card_item.dart';
import 'package:flutter/material.dart';

class ClientCardsList extends StatelessWidget {
  final List<UserCard> userCards;
  final User user;
  final int selectedState;

  const ClientCardsList({
    super.key,
    required this.userCards,
    required this.user,
    required this.selectedState,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userCards.length,
      itemBuilder: (context, index) {
        final card = userCards[index];
        return ClientCardItem(
          userCard: card,
          user: user,
          selectedState: selectedState,
        );
      },
    );
  }
}
