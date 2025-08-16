class ImageUpload {
  String message;
  String url;
  String key;

  ImageUpload(this.message, this.url, this.key);

  factory ImageUpload.fromJson(Map<String, dynamic> json) {
    return ImageUpload(
      json['message'] as String,
      json['url'] as String,
      json['key'] as String,
    );
  }
}
