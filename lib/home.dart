import 'screens.dart';
import 'package:http/http.dart' as http;
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
          const MStatWid(),
          Settings(camera: widget.camera, username: widget.username),
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
  final String username;
  const Settings({super.key, required this.camera, required this.username});

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
            leading: Icon(Icons.account_box_outlined),
            title: Text("Account"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => passBar(username: widget.username)),
              );
            }),
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

class MStatWid extends StatelessWidget {
  const MStatWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Statistics'),
        ),
        body: const StatsPage());
  }
}

class passBar extends StatelessWidget {
  final String username;
  const passBar({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Account'),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.groups)),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              UserPage(username: username),
              PassPage(username: username),
            ],
          ),
        ),
      ),
    );
  }
}

class PassPage extends StatefulWidget {
  final String username;
  const PassPage({super.key, required this.username});

  @override
  State<PassPage> createState() {
    return _passpage();
  }
}

class _passpage extends State<PassPage> {
  final _formKey = GlobalKey<FormState>();
  final newPass = TextEditingController();
  final OldPass = TextEditingController();
  bool inTeam = false;
  bool nonExistantTeam = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 15),
                            child: TextFormField(
                              controller: OldPass,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.group),
                                  labelText: 'Password',
                                  hintText: 'Enter Current Password'),
                            )),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 15),
                            child: TextFormField(
                              controller: newPass,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.group),
                                  labelText: 'New Password',
                                  hintText: 'Enter New Password'),
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextButton(
                                onPressed: () async {
                                  ChangePass(widget.username, OldPass, newPass);
                                },
                                child: const Text(
                                  'Change Password',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                            )),
                      ],
                    )))));
  }
}

class UserPage extends StatefulWidget {
  final String username;
  const UserPage({super.key, required this.username});

  @override
  State<UserPage> createState() {
    return _Userpage();
  }
}

class _Userpage extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();
  final newUser = TextEditingController();
  bool inTeam = false;
  bool nonExistantTeam = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 15),
                            child: TextFormField(
                              controller: newUser,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.group),
                                  labelText: 'New Username',
                                  hintText: 'Enter New Username'),
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextButton(
                                onPressed: () async {
                                  UserName(widget.username, newUser);
                                },
                                child: const Text(
                                  'Change Username',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                            )),
                      ],
                    )))));
  }
}

Future<String> ChangePass(username, oldpass, newpass) async {
  Uri uri = Uri.parse('https://sdp23.cse.uconn.edu/change-password');
  final response = await http.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': oldpass,
        'newPassword': newpass
      }));

  return response.body;
}

Future<String> UserName(username, newUser) async {
  Uri uri = Uri.parse('https://sdp23.cse.uconn.edu/change-password');
  final response = await http.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
          <String, String>{'username': username, 'newUsername': newUser}));

  return response.body;
}
