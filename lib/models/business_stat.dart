class BusinessStat {
  int totalCards;
  int totalStamps;
  List<CardStat> cardStats;

  BusinessStat(this.totalCards, this.totalStamps, this.cardStats);

  factory BusinessStat.fromJson(Map<String, dynamic> json) {
    List<CardStat> cardStatsList = [];
    if (json['cardStates'] != null) {
      final l = json['cardStates'] as List;
      cardStatsList = l
          .map((item) => CardStat.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return BusinessStat(
      json['totalCards'] as int,
      json['totalStamps'] as int,
      cardStatsList,
    );
  }
}

class CardStat {
  int total;
  String state;

  CardStat(this.total, this.state);

  factory CardStat.fromJson(Map<String, dynamic> json) {
    return CardStat(json['total'] as int, json['state'] as String);
  }
}
