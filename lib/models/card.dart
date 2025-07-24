class BusinessCard {
  int id;
  int idBusiness;
  int expiration;
  int maxStamp;
  String name;
  String description;
  String restrictions;
  String reward;

  BusinessCard(
    this.id,
    this.idBusiness,
    this.expiration,
    this.maxStamp,
    this.name,
    this.description,
    this.restrictions,
    this.reward,
  );

  factory BusinessCard.fromJson(Map<String, dynamic> json) {
    return BusinessCard(
      json['id'] as int,
      json['idBusiness'] as int,
      json['expiration'] as int,
      json['maxStamp'] as int,
      json['name'] as String,
      json['description'] as String,
      json['restrictions'] as String,
      json['reward'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "idBusiness": idBusiness,
      "expiration": expiration,
      "maxStamp": maxStamp,
      "name": name,
      "description": description,
      "restrictions": restrictions,
      "reward": reward,
    };
  }
}
