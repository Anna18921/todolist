class Item {
  String title;
  bool done;
  int id;

  Item({this.title, this.done});
//recebendo um JSON mapa string
  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }
//enviando um Json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['done'] = this.done;
    return data;
  }
}
