class Link {
  int _id;
  String _url;
  String _redSocial;

  Link(this._id, this._url, this._redSocial);

  int get id => _id;
  set id(int value) => _id = value;

  String get url => _url;
  set url(String value) => _url = value;

  String get redSocial => _redSocial;
  set redSocial(String value) => _redSocial = value;

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      json['id'] as int,
      json['value'] as String,
      json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': _id, 'url': _url, 'redSocial': _redSocial};
  }
}
