import 'screens.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final CameraDescription camera;
  const HomePage({super.key, required this.camera});

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
          const TeamTabBar(),
          TakePictureScreen(
            camera: widget.camera,
          ),
          const MStatWid(),
          Settings(camera: widget.camera),
        ].elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: BottomNavigationBar(
          iconSize: 20,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
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

class Settings extends StatefulWidget {
  final CameraDescription camera;
  const Settings({super.key, required this.camera});

  @override
  State<Settings> createState() {
    return _Settings();
  }
}

class _Settings extends State<Settings> {
  final storage = const FlutterSecureStorage();
  String username = '';

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  Future<bool> getUsername() async {
    username = (await storage.read(key: 'user'))!;
    setState(() {});
    return true;
  }

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
                    builder: (context) => passBar(username: username)),
              );
            }),
        const ListTile(
            leading: Icon(Icons.private_connectivity),
            title: Text("Privacy & Security")),
        const ListTile(
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Username"),
              Tab(text: "Password"),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            UserPage(username: username),
            PassPage(username: username),
          ],
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
                              width: 250,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextButton(
                                onPressed: () async {
                                  changePassword(widget.username, OldPass.text,
                                      newPass.text);
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
                              width: 250,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextButton(
                                onPressed: () async {
                                  changeUserame(widget.username, newUser.text);
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

Future<String> changePassword(username, oldpass, newpass) async {
  var old_bytes = utf8.encode(oldpass);
  final String old_pwh = sha256.convert(old_bytes).toString();
  var new_bytes = utf8.encode(newpass);
  final String new_pwh = sha256.convert(new_bytes).toString();
  Uri uri = Uri.parse('https://sdp23.cse.uconn.edu/change-password');
  final response = await http.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': old_pwh,
        'newPassword': new_pwh
      }));

  if (response.body == 'Success') {
    const storage = FlutterSecureStorage();
    await storage.write(key: "user", value: username);
    await storage.write(key: "pass", value: new_pwh);
  }

  return response.body;
}

Future<String> changeUserame(username, newUser) async {
  Uri uri = Uri.parse('https://sdp23.cse.uconn.edu/change-username');
  final response = await http.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
          <String, String>{'username': username, 'newUsername': newUser}));

  if (response.body == "Success") {
    const storage = FlutterSecureStorage();
    await storage.write(key: "user", value: newUser);
  }

  return response.body;
}
