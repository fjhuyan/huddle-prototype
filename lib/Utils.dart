class Event {
  int eid;
  String eventname;
  double x;
  double y;

  Event(int eid, String eventname, double x, double y) {
    this.eid = eid;
    this.eventname = eventname;
    this.x = x;
    this.y = y;
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return new Event(json['eid'].toInt(), json['eventname'].toString(), json['x'].toDouble(), json['y'].toDouble());
  }

  static List<Event> fromJsonList(List<dynamic> json) {
    List<Event> result = new List();
    json.forEach((element) {
      result.add(Event.fromJson(element as Map<String, dynamic>));
    });
    return result;
  }

  String toString() {
    return "{" + "\"eid\": " + "\"" + this.eid.toString() + "\", " + "\"eventname\": " + "\"" + this.eventname + "\", "
    + "\"x\": \"" + this.x.toString() + "\", " + "\"y\": \"" + this.y.toString() + "\"" + "}";
  }
}