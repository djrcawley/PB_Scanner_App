import 'screens.dart';

const Color primary = Color(0xFFFF3378);
const Color secondary = Color(0xFFFF2278);
const Color black = Color(0xFF000000);
const Color white = Color(0xFFFFFFFF);
const Color grey = Colors.grey;
const Color red = Color(0xFFec5766);
const Color green = Color(0xFF43aa8b);
const Color blue = Color(0xFF28c2ff);

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() {
    return _StatsPageState();
  }
}

class _StatsPageState extends State<StatsPage> {
  String points = '0';
  String avgPoints = '0';
  String streak = '0';
  String avgStreak = '0';
  String team = 'Uconn';
  String teamPoints = '12345';
  String packages = '0';
  String avgPackages = '0';
  @override
  void initState() {
    super.initState();
    getPersonalInfo();
  }

  Future<bool> getPersonalInfo() async {
    String url = "https://sdp23.cse.uconn.edu/stats";
    final encoding = Encoding.getByName('utf-8');
    final header = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    const storage = FlutterSecureStorage();
    String? user = await storage.read(key: 'user');
    Map<String, String> body = {
      'username': user!,
    };
    String jsonBody = json.encode(body);
    Response response = await post(
      Uri.parse(url),
      headers: header,
      body: jsonBody,
      encoding: encoding,
    );
    Map<dynamic, dynamic> responseJson = jsonDecode(response.body);
    points = responseJson['personal_stats']['total_points'].toString();
    avgPoints = responseJson['average_stats']['average_points'].toString();
    streak = responseJson['personal_stats']['daily_streak'].toString();
    avgStreak = responseJson['average_stats']['average_streak'].toString();
    packages = responseJson['personal_stats']['packages_scanned'].toString();
    avgPackages = responseJson['average_stats']['average_packages'].toString();
    team = responseJson['team']['team'].toString();
    teamPoints = responseJson['team']['points'].toString();
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey.withOpacity(0.25),
        body: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            StatBox(
                title: "Total Points Earned",
                stat: "$points Points",
                image: 'assets/images/badge.png',
                average: "Average: $avgPoints Points"),
            SizedBox(
              height: 10,
            ),
            StatBox(
                title: "Total Packages Scanned",
                stat: "$packages Packages",
                image: 'assets/images/box.png',
                average: "Average: $avgPackages Packages"),
            SizedBox(
              height: 10,
            ),
            StatBox(
                title: "Daily Streak",
                stat: "$streak Days",
                image: 'assets/images/streak.png',
                average: "Average: $avgStreak Days"),
            SizedBox(
              height: 10,
            ),
            StatBox(
                title: "Team",
                stat: "$team",
                image: 'assets/images/team.png',
                average: "Team Points: $teamPoints"),
          ],
        )));
  }
}

class StatBox extends StatefulWidget {
  final String title;
  final String stat;
  final String average;
  final String image;
  const StatBox(
      {super.key,
      required this.title,
      required this.stat,
      required this.average,
      required this.image});

  @override
  State<StatBox> createState() {
    return _StatBox();
  }
}

class _StatBox extends State<StatBox> {
  _StatBox();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
                // changes position of shadow
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Color(0xff67727d),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      height: 100,
                      width: 100,
                      widget.image,
                    ),
                    Text(
                      widget.stat,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      widget.average,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
