class Nota {
  String _id;
  String _titulo;
  String _nota;
  Nota(this._id, this._titulo, this._nota);
  Nota.map(dynamic obj) {
    this._id = obj['id'];
    this._titulo = obj['titulo'];
    this._nota = obj['nota'];
  }
  Nota.fromMap(Map<String, dynamic> map, String id) {
    this._id = id ?? '';
    this._titulo = map["titulo"];
    this._nota = map["nota"];
  }
  String get id => _id;
  String get titulo => _titulo;
  String get nota => _nota;
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map["titulo"] = _titulo;
    map["nota"] = this._nota;
    return map;
  }
}