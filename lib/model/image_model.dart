class ImageModel {
  int? id;
  String name;

  ImageModel(this.id, this.name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory ImageModel.fromMap(Map<String, dynamic> json) =>
      ImageModel(json['id'], json['name']);
}
