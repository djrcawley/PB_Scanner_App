import 'screens.dart';

class MyStatefulWidget extends StatefulWidget {
  final CameraDescription camera;
  const MyStatefulWidget({super.key, required this.camera});

  @override
  State<MyStatefulWidget> createState() => FirstRoute(test: camera);
}

class FirstRoute extends State<MyStatefulWidget> {
  FirstRoute({required this.test});
  final CameraDescription test;

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
          TakePictureScreen(camera: test),
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

class Leaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboard'),
        ),
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
