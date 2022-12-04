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

  // static const List<Widget> _pages = <Widget>[
  //   Individual_Statistics(),
  //   LoginPage(camera: test),
  //   Icon(
  //     Icons.camera_alt_outlined,
  //     size: 150,
  //   ),
  //   Icon(
  //     Icons.bar_chart,
  //     size: 150,
  //   ),
  //   Icon(
  //     Icons.settings,
  //     size: 150,
  //   ),
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
      ),
      body: Center(
        child: [
          Individual_Statistics(),
          TakePictureScreen(camera: test),
          Settings(),
          Icon(
            Icons.settings,
            size: 150,
          ),
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
              label: 'Individual Statistics',
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
        title: const Text('Individual Statistics'),
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
        ListTile(leading: Icon(Icons.logout_outlined), title: Text("Logout")),
      ]),
    );
  }
}
