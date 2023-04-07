import 'screens.dart';
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
          TeamTabBar(username: widget.username),
          TakePictureScreen(
            camera: widget.camera,
            username: widget.username,
          ),
          StatsPage(username: widget.username),
          Settings(camera: widget.camera),
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
              icon: Icon(Icons.qr_code_scanner_outlined),
              label: 'Scan',
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


class Settings extends StatefulWidget {
  final CameraDescription camera;
  const Settings({
    super.key,
    required this.camera,
  });

  @override
  State<Settings> createState() {
    return _Settings();
  }
}

class _Settings extends State<Settings> {
  final storage = const FlutterSecureStorage();

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
            onTap: () async {
              await storage.deleteAll();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return LoginPage(camera: widget.camera);
              }), (r) {
                return false;
              });
            }),
      ]),
    );
  }
}