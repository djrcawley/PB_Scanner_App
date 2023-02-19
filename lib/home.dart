import 'screens.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final CameraDescription camera;
  final String username;
  const HomePage({super.key, required this.camera, required this.username});

  @override
  State<HomePage> createState() => FirstRoute();
}

class FirstRoute extends State<HomePage> {
  FirstRoute();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: [
          Leaderboard(),
          TakePictureScreen(
            camera: widget.camera,
            username: widget.username,
          ),
          MStatWid(),
          Settings(),
        ].elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: BottomNavigationBar(
          iconSize: 20,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: 'Leaderboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped),
    );
  }
}

// ignore: camel_case_types
class Individual_Statistics extends StatelessWidget {
  const Individual_Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Individual Statistics'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            //Navigator.push(
            //  context,
            //  MaterialPageRoute(builder: (context) => Result(jsonStr: "{\n\"TestKey\":\"TestData\",\n\"key2\":\"data\"\n}"),)
            //);
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(children: [
        ListTile(
            leading: Icon(Icons.account_box_outlined), title: Text("Account")),
        ListTile(
            leading: Icon(Icons.private_connectivity),
            title: Text("Privacy & Security")),
        ListTile(
            leading: Icon(Icons.notifications_active_outlined),
            title: Text("Notifications")),
        ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text("Logout"),
            onTap: () {
              Navigator.pop(context);
            }),
      ]),
    );
  }
}



List<int> colorCodes = <int>[600, 500, 100];

class Leaderboard extends StatefulWidget {
  Leaderboard();

  
  var response;
  Future<String> main() async {
    String url = "https://sdp23.cse.uconn.edu/leaderboard";
    response = await http.get(Uri.parse(url));
    return response.body;
  }

  @override
  State<Leaderboard> createState() {
    return _Leaderboard();
  }
}

class _Leaderboard extends State<Leaderboard> {

  var stringy;
  List<dynamic> jsonMap = [];
  List<String> entries = <String>[];


  @override
  void initState() {
    super.initState();
    buildList();
  }

  void buildList() async 
  {
    stringy = await widget.main();
    jsonMap = jsonDecode(stringy);
    for(var i=0; i<jsonMap.length; i++)
    {
      entries.add(jsonMap[i].toString());
    }
    setState(() { });
  }
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text('Leaderboard '+entries.length.toString())
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.amber,
            child: Center(child: Text( '${index+1} Entry ${entries[index]}' )),
          );
        }
      )
    );

/*
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Text("1",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  )),
              title: Text('Ben Bucci'),
              subtitle: Text('Points: 600'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              leading: Text("2",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  )),
              title: Text("Dennis Cawley"),
              subtitle: Text('Points: 550'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              leading: Text("3",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  )),
              title: Text('Max Serino'),
              subtitle: Text('Points: 500'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              leading: Text("4",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  )),
              title: Text('Aryaman Kulkarni'),
              subtitle: Text('Points: 300'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              leading: Text("5",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  )),
              title: Text('Yu Ge'),
              subtitle: Text('Points: 200'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              leading: Text("6",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  )),
              title: Text('Chenyu Tian'),
              subtitle: Text('Points: 100'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ));
        */
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem(
      {super.key,
      required this.thumbnail,
      required this.title,
      required this.barscan,
      required this.compbar,
      required this.daily,
      required this.points});

  final Widget thumbnail;
  final String title;
  final String barscan;
  final int compbar;
  final int daily;
  final int points;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          Expanded(
            flex: 5,
            child: StatData(
                title: title,
                barscan: barscan,
                compbar: compbar,
                daily: daily,
                points: points),
          ),
          const Icon(
            Icons.more_vert,
            size: 16.0,
          ),
        ],
      ),
    );
  }
}

class StatData extends StatelessWidget {
  const StatData(
      {required this.title,
      required this.barscan,
      required this.compbar,
      required this.daily,
      required this.points});

  final String title;
  final String barscan;
  final int compbar;
  final int daily;
  final int points;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            "Barcodes Scanned: $barscan",
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            'Competitor Barcodes: $compbar ',
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 0.0)),
          Text(
            'DailyStreak: $daily ',
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 0.0)),
          Text(
            'Points: $points ',
            style: const TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}

class MStatWid extends StatelessWidget {
  const MStatWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Stats'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          itemExtent: 106.0,
          children: <CustomListItem>[
            CustomListItem(
              barscan: '4',
              compbar: 3,
              daily: 4,
              points: 500,
              thumbnail: Container(
                decoration: const BoxDecoration(color: Colors.yellow),
              ),
              title: 'Your Stats',
            ),
            CustomListItem(
              barscan: '10',
              compbar: 7,
              daily: 10,
              points: 1200,
              thumbnail: Container(
                decoration: const BoxDecoration(color: Colors.blue),
              ),
              title: 'Goals',
            ),
          ],
        ));
  }
}