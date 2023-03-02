import 'screens.dart';
import 'package:http/http.dart' as http;

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
                Tab(icon: Icon(Icons.groups_2)),
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
        body: Column(mainAxisSize: MainAxisSize.min, children: [
      const TopRow(),
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
  @override
  void initState() {
    super.initState();
    buildTeam();
  }

  Future<bool> buildTeam() async {
    String url = "https://sdp23.cse.uconn.edu/team-leaderboard";
    var response = await http.get(Uri.parse(url));
    jsonMap = jsonDecode(response.body);
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          const TopRow(),
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
                          color: (jsonMap[index]['Members'].contains(widget.username)) ? Color.fromARGB(255, 224, 224, 224): const Color(0xfffafafa),
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
        ]));
  }
}

class TopRow extends StatelessWidget {
  const TopRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          width: 40,
          height: 30,
          child: const Text('Rank',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 78, 78, 78))),
        ),
        const SizedBox(width: 90),
        Container(
            alignment: Alignment.center,
            child: const Text('Team',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 78, 78, 78)))),
        const Spacer(),
        const SizedBox(
            width: 50,
            child: Text('Points',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 78, 78, 78)))),
      ],
    );
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

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
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
                            child: TextFormField(
                                controller: teamController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.group),
                                    labelText: 'Team Name',
                                    hintText: 'Enter team'),
                            validator: (value) {
                            if (value != '' && !inTeam && !nonExistantTeam) {
                              return null;
                            } else if (inTeam == true) {
                              return 'Already in a team.';
                            }
                            return 'The team does not exist.';
                          },)),
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
                                  
                                  joinTeam(widget.username, teamController.text).then((value) => {
                                    if(value == 'Success'){
                                    Navigator.pop(context)
                                  } else if (value == 'You are already in a team.'){
                                    inTeam = true,
                                    _formKey.currentState!.validate()
                                  } else {
                                    nonExistantTeam = true,
                                    _formKey.currentState!.validate()
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
