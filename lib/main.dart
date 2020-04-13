import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'Utils.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    theme: ThemeData(
      primaryColor: Colors.purple,
    )));
} 

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  GoogleMapController mapController;
  LatLng myPosition;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Set<Marker>> getMarkers() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    var status = await Permission.location.status;
    Set<Marker> result = new Set();
    if(status.isDenied) {
      return result;
    }
    Position p = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    String uri = _getHostName();
    http.Response response = await http.get(uri + "/GET_EVENTS");
    List<Event> events = Event.fromJsonList(jsonDecode(response.body));
    events.forEach((event) {
      result.add(new Marker(
        markerId: new MarkerId(event.eventname), 
        position: new LatLng(event.x, event.y),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  contentPadding: EdgeInsets.all(0),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                            padding: EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(32.0), topLeft: Radius.circular(32.0)),
                              child: Image(
                              fit: BoxFit.fill,
                              image: NetworkImage('https://media.istockphoto.com/photos/beautiful-luxury-home-exterior-at-twilight-picture-id1026205392?k=6&m=1026205392&s=612x612&w=0&h=pe0Pqbm7GKHl7cmEjf9Drc7Fp-JwJ6aTywsGfm5eQm4=')
                              )
                            ),
                          ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(event.eventname),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 2,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text("All are welcome!"),
                      ),
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(32.0),
                                bottomRight: Radius.circular(32.0)),
                            ),
                            child: Text("Attend Huddle",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () {},
                      ),
                      ],
                    ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
              )
          );
        }
      ));
    });
    myPosition = new LatLng(p.latitude, p.longitude);
    result.add(new Marker(
      markerId: new MarkerId("Me"),
      position: myPosition,
      onTap: () {showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image(image: NetworkImage('https://previews.123rf.com/images/get4net/get4net1802/get4net180200635/94675570-female-user-profile-isolated-on-blue-circular-background-.jpg')),
                Text("It's you!"),
              ]
            )
          );
        }
      );
      },
    ));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMarkers(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          Set<Marker> markers = snapshot.data;
          return Scaffold(
              drawer: Drawer(
                child: Column(
                  children: <Widget>[
                    DrawerHeader(
                      child: Image(image: NetworkImage('https://previews.123rf.com/images/get4net/get4net1802/get4net180200635/94675570-female-user-profile-isolated-on-blue-circular-background-.jpg')),
                    ),
                    ListTile(
                      title: Text('Profile'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('Upcoming Events'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('Past Events'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('Friends'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('Groups'),
                      onTap: () {},
                    ),
                    new Expanded(
                      child: new Align(
                        alignment: Alignment.bottomCenter,
                        child: ListTile(
                          title: Text("Settings"),
                          onTap: () {},
                        )
                      ),
                    ),
                  ]
                ),
              ),
              extendBody: true,
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: <Widget> [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: myPosition,
                      zoom: 11.0,
                    ),
                    markers: markers,
                  ),
                  Positioned(
                    right: MediaQuery.of(context).size.width / 20,
                    bottom: MediaQuery.of(context).size.height / 10,
                    child: FloatingActionButton(
                      backgroundColor: Colors.purple,
                      elevation: 4.0,
                      child: Icon(Icons.location_searching),
                      onPressed: () {mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: myPosition, zoom: 15.0)));},
                    ),
                  ),
                ]
              ),
              floatingActionButton: FloatingActionButton.extended(
                elevation: 4.0,
                icon: const Icon(Icons.add),
                label: const Text('Add Event'),
                backgroundColor: Colors.purple,
                onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                            title: Text("New Event"),
                            contentPadding: EdgeInsets.only(top: 10.0),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.edit),
                                      hintText: 'Enter a name',
                                      labelText: 'Event Name',
                                    ),
                                  )
                                ),
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.location_searching),
                                      hintText: 'Search for Location',
                                      labelText: 'Location',
                                    ),
                                  )
                                ),
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.event),
                                      hintText: 'Pick a Date',
                                      labelText: 'Date',
                                    ),
                                    keyboardType: TextInputType.datetime,
                                  )
                                ),
                                InkWell(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                                    decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(32.0),
                                          bottomRight: Radius.circular(32.0)),
                                      ),
                                      child: Text("Add Event",
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                                ],
                              ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                        )
                    );
                },
              ),
              floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar:BottomAppBar(
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Builder(
                          builder: (context) =>
                              IconButton(
                                icon: Icon(Icons.menu),
                                onPressed: () =>
                                    Scaffold.of(context)
                                        .openDrawer(),
                              )
                      ),
                    ],
                  ),
                ),
              );
        } else {
          return Container();
        }
      },
    );
  }

  String _getHostName() {
    if (kIsWeb) {
      return 'http://localhost:3000';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    } else {
      return 'http://localhost:3000';
    }
  }
}
