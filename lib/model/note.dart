class Notes{
  int _id;
  String _title;
  String _description;
  int _priority;
  String _date;

  Notes(this._title, this._date, this._priority, [this._description]);

  Notes.withId(this._id, this._title, this._date, this._priority, [this._description]);

  int get priority => _priority;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  set priority(int value) {
    if(value >=1 && value <= 2)
    _priority = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get description => _description;

  set description(String value) {
    if(value.length <= 255)
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    if(value.length <= 255)
    _title = value;
  }

//  convert a note into a map object

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if(_id !=null){
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
    return map;
  }

  Notes.fromMap(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];

  }

}