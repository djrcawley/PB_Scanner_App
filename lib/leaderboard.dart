import 'screens.dart';
import 'package:http/http.dart' as http;
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class TeamTabBar extends StatelessWidget {
  final String username;
  const TeamTabBar({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Leaderboard'),
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
              const Leaderboard(),
              Leaderboard2(username: username),
            ],
          ),
        ),
      ),
    );
  }
}

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  Future<String> main() async {
    String url = "https://sdp23.cse.uconn.edu/leaderboard";
    var response = await http.get(Uri.parse(url));
    return response.body;
  }

  @override
  State<Leaderboard> createState() {
    return _Leaderboard();
  }
}

class _Leaderboard extends State<Leaderboard> {
  List<dynamic> jsonMap = [];

  @override
  void initState() {
    super.initState();
    buildList();
  }

  Future<bool> buildList() async {
    String url = "https://sdp23.cse.uconn.edu/leaderboard";
    var response = await http.get(Uri.parse(url));
    jsonMap = jsonDecode(response.body);
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey.withOpacity(0.25),
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          const TopRow(middleText: 'User'),
          const Divider(
            indent: 5,
            endIndent: 5,
            color: Color.fromARGB(255, 78, 78, 78),
            thickness: 0.5,
          ),
          Expanded(
              child: RefreshIndicator(
                  onRefresh: () {
                    return buildList();
                  },
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: jsonMap.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            // Rank
                            leading: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Country & Username
                            title: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Row(
                                children: [
                                  // Country
                                  CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    child: Text(
                                      '🌐',
                                      style: TextStyle(
                                        fontSize: 25.0,
                                      ),
                                    ),
                                  ),

                                  // Username
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      '${jsonMap[index]['username']}',
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Points
                            trailing: Text(
                              '${jsonMap[index]['total_points']}',
                            ),
                          ),
                        );
                      })))
        ]));
  }
}

class Leaderboard2 extends StatefulWidget {
  final String username;
  const Leaderboard2({super.key, required this.username});

  Future<String> main() async {
    String url = "https://sdp23.cse.uconn.edu/team-leaderboard";
    var response = await http.get(Uri.parse(url));
    return response.body;
  }

  @override
  State<Leaderboard2> createState() {
    return _Leaderboard2();
  }
}

class _Leaderboard2 extends State<Leaderboard2> {
  List<dynamic> jsonMap = [];
  String teamName = '';
  @override
  void initState() {
    super.initState();
    buildTeam();
  }

  Future<bool> buildTeam() async {
    String url = "https://sdp23.cse.uconn.edu/team-leaderboard";
    var response = await http.get(Uri.parse(url));
    jsonMap = jsonDecode(response.body);
    for (var team in jsonMap) {
      if (team['Members'].contains(widget.username)) {
        teamName = team['Team_Names'];
        break;
      }
    }
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    SpeedDial buildSpeedDial() {
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 28.0),
        backgroundColor: Colors.blue[900],
        visible: true,
        curve: Curves.bounceInOut,
        children: [
          SpeedDialChild(
            child: Icon(Icons.exit_to_app, color: Colors.white),
            backgroundColor: Colors.blue,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LeavePage(
                            username: widget.username,
                            team: teamName,
                          ))).then((value) {
                setState(() {
                  // refresh state of Page1
                  buildTeam();
                });
              });
            },
            label: 'Leave',
            labelStyle:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            labelBackgroundColor: Colors.black,
          ),
          SpeedDialChild(
            child: Icon(Icons.add_circle_outline, color: Colors.white),
            backgroundColor: Colors.blue,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeamPage(
                            username: widget.username,
                          ))).then((value) {
                setState(() {
                  // refresh state of Page1
                  buildTeam();
                });
              });
            },
            label: 'Create',
            labelStyle:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            labelBackgroundColor: Colors.black,
          ),
          SpeedDialChild(
            child: Icon(Icons.group, color: Colors.white),
            backgroundColor: Colors.blue,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JoinPage(
                            username: widget.username,
                          ))).then((value) {
                setState(() {
                  // refresh state of Page1
                  buildTeam();
                });
              });
            },
            label: 'Join',
            labelStyle:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            labelBackgroundColor: Colors.black,
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: grey.withOpacity(0.25),
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        const TopRow(middleText: 'Team'),
        const Divider(
          indent: 5,
          endIndent: 5,
          color: Color.fromARGB(255, 78, 78, 78),
          thickness: 0.5,
        ),
        Expanded(
            child: RefreshIndicator(
                onRefresh: () {
                  return buildTeam();
                },
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: jsonMap.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          // Rank
                          leading: Text(
                            (index + 1).toString(),
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Country & Username
                          title: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Row(
                              children: [
                                // Country
                                CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  child: Text(
                                    (jsonMap[index]['Members']
                                            .contains(widget.username))
                                        ? '⭐'
                                        : '🌐',
                                    style: TextStyle(
                                      fontSize: 25.0,
                                    ),
                                  ),
                                ),

                                // Username
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    '${jsonMap[index]['Team_Names']}',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Points
                          trailing: Text(
                            '${jsonMap[index]['Points']}',
                          ),
                        ),
                      );
                    })))
      ]),
      floatingActionButton: buildSpeedDial(),
    );
  }
}

class TopRow extends StatelessWidget {
  final String middleText;
  const TopRow({super.key, required this.middleText});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Container(
          alignment: Alignment.center,
          width: 70,
          height: 30,
          child: const Text('Rank',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 78, 78, 78))),
        ),
        const SizedBox(width: 70),
        Container(
            alignment: Alignment.center,
            child: Text(middleText,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 78, 78, 78)))),
        const Spacer(),
        const SizedBox(
            width: 70,
            child: Text('Points',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 78, 78, 78)))),
      ],
    ));
  }
}

class JoinPage extends StatefulWidget {
  final String username;
  const JoinPage({super.key, required this.username});

  @override
  State<JoinPage> createState() {
    return _JoinPage();
  }
}

class _JoinPage extends State<JoinPage> {
  final _formKey = GlobalKey<FormState>();
  final teamController = TextEditingController();
  bool inTeam = false;
  bool nonExistantTeam = false;
  //team names

  List<String> teamNames = [];
  buildTeam() async {
    String url = "https://sdp23.cse.uconn.edu/team-leaderboard";
    var response = await http.get(Uri.parse(url));
    List<dynamic> jsonMap = jsonDecode(response.body);
    // setState(() {});
    return jsonMap;
  }

  buildTeamNames() async {
    List<dynamic> jsonMap = await buildTeam();
    for (int i = 0; i < jsonMap.length; i++) {
      teamNames.add(jsonMap[i]['Team_Names']);
    }
    print(teamNames);
    return teamNames;
  }

  @override
  Widget build(BuildContext context) {
    buildTeamNames();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Join Team'),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 15),
                            //how to add autocomplete to TextFormField?

                            child:
                                 SimpleAutocompleteFormField<String>(
                                  controller: teamController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.group),
                                      labelText: 'Team Name',
                                      hintText: 'Enter team'),
                                  itemBuilder: (context, item) => Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(item!),
                                  ),
                                  suggestionsHeight: 100,
                                  onSearch: (search) async => teamNames
                                      .where((team) => team
                                          .toLowerCase()
                                          .contains(search.toLowerCase()))
                                      .toList(),
                                  validator: (value) {
                                    if (value != '' &&
                                        !inTeam &&
                                        !nonExistantTeam) {
                                      return null;
                                    } else if (inTeam == true) {
                                      return 'Already in a team.';
                                    }
                                    return 'The team does not exist.';
                                  },
                                ),
                                ),
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
                                  joinTeam(widget.username, teamController.text)
                                      .then((value) => {
                                            if (value == 'Success')
                                              {Navigator.pop(context)}
                                            else if (value ==
                                                'You are already in a team.')
                                              {
                                                inTeam = true,
                                                _formKey.currentState!
                                                    .validate()
                                              }
                                            else
                                              {
                                                nonExistantTeam = true,
                                                _formKey.currentState!
                                                    .validate()
                                              }
                                          });
                                },
                                child: const Text(
                                  'Join',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                            )),
                      ],
                    )))));
  }
}

class TeamPage extends StatefulWidget {
  final String username;
  const TeamPage({super.key, required this.username});

  @override
  State<TeamPage> createState() {
    return _TeamPage();
  }
}

class _TeamPage extends State<TeamPage> {
  final _formKey = GlobalKey<FormState>();
  final teamController = TextEditingController();
  bool inTeam = false;
  bool nonExistantTeam = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Team'),
        ),
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
                              controller: teamController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.group),
                                  labelText: 'Team Name',
                                  hintText: 'Enter New Team Name'),
                              validator: (value) {
                                if (value != '' &&
                                    !inTeam &&
                                    !nonExistantTeam) {
                                  return null;
                                } else if (inTeam == true) {
                                  return 'Already in a team.';
                                }
                                return 'The team does not exist.';
                              },
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
                                  createTeam(
                                          widget.username, teamController.text)
                                      .then((value) => {
                                            if (value == 'Success')
                                              {Navigator.pop(context)}
                                            else if (value ==
                                                'You are already in a team.')
                                              {
                                                inTeam = true,
                                                _formKey.currentState!
                                                    .validate()
                                              }
                                            else
                                              {
                                                nonExistantTeam = true,
                                                _formKey.currentState!
                                                    .validate()
                                              }
                                          });
                                },
                                child: const Text(
                                  'Create',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                            )),
                      ],
                    )))));
  }
}

class LeavePage extends StatefulWidget {
  final String username;
  final String team;
  const LeavePage({super.key, required this.username, required this.team});

  @override
  State<LeavePage> createState() {
    return _LeavePage();
  }
}

class _LeavePage extends State<LeavePage> {
  final _formKey = GlobalKey<FormState>();
  bool inTeam = false;
  bool nonExistantTeam = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Leave Team'),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 15),
                            child: Text("Do you want to leave?",
                                style: TextStyle(fontSize: 30))),
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
                                  leaveTeam(widget.username, widget.team).then(
                                      (value) => {Navigator.pop(context)});
                                },
                                child: const Text(
                                  'Leave',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                            )),
                      ],
                    )))));
  }
}

Future<String> joinTeam(username, team) async {
  Uri uri = Uri.parse('https://sdp23.cse.uconn.edu/add-member');
  final response = await http.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
          <String, String>{'username': username, 'team_name': team}));

  return response.body;
}

Future<String> createTeam(username, team) async {
  Uri uri = Uri.parse('https://sdp23.cse.uconn.edu/createteam');
  final response = await http.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
          <String, String>{'username': username, 'team_name': team}));

  return response.body;
}

Future<String> leaveTeam(username, team) async {
  Uri uri = Uri.parse('https://sdp23.cse.uconn.edu/remove-member');
  final response = await http.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
          <String, String>{'username': username, 'team_name': team}));

  return response.body;
}



/*
floatingActionButton: FloatingActionButton.extended(
            label: const Text('Join'),
            icon: const Icon(Icons.groups_2),
            backgroundColor: Colors.blue,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => JoinPage(username: widget.username,))).then((value) {
                  setState(() {
                    // refresh state of Page1
                    buildTeam();
                  });
                });
            }),
            */





 