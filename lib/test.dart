import 'dart:convert';

import 'package:http/http.dart' as http;
import 'Utils.dart';

main() {
  http.get("http://localhost:3000/GET_EVENTS").then((response) {
    List<Event> test = Event.fromJsonList(jsonDecode(response.body));
    print(test);
  });
}