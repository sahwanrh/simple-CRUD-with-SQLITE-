class Photo {
  int _id;
  String _photos;
  String _title;
  Photo(this._id, this._photos, this._title);
  Photo.id(this._id, this._photos, this._title);
  int get id {
    return _id;
  }

  String get photos {
    return _photos;
  }

  String get title {
    return _title;
  }

  set title(String numTitle) {
    this.title = numTitle;
  }

  set photos(String numPhotos) {
    this.photos = numPhotos;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['photos'] = _photos;
    map['title'] = _title;
    return map;
  }

  Photo.fromMap(Map<String, dynamic> json)
      : this._id = json['id'] ?? 0,
        this._photos = json['photos'] ?? '',
        this._title = json['title'] ?? '';
}
