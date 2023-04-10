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
  String team = '';
  String teamPoints = '0';
  String packages = '0';
  String avgPackages = '0';
  double pointPercent = 0.0;
  double avgPercent = 0.0;
  double streakPercent = 0.0;
  double avgStreakPercent = 0.0;
  double packagePercent = 0.0;
  double avgPackagePercent = 0.0;
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
    double maxPoints = max(double.parse(points), double.parse(avgPoints));
    pointPercent = double.parse(points) / maxPoints;
    avgPercent = double.parse(avgPoints) / maxPoints;

    double maxPackage = max(double.parse(packages), double.parse(avgPackages));
    packagePercent = double.parse(packages) / maxPackage;
    avgPackagePercent = double.parse(avgPackages) / maxPackage;

    double maxStreak = max(double.parse(streak), double.parse(avgStreak));
    streakPercent =
        (double.parse(streak) == 0.0) ? 0 : double.parse(streak) / maxStreak;
    avgStreakPercent = (double.parse(avgStreak) == 0.0)
        ? 0
        : double.parse(avgStreak) / maxStreak;
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
              statTitle: "$points Points",
              image: 'assets/images/badge.png',
              averageTitle: "Average: $avgPoints Points",
              statPlain: points,
              averagePlain: avgPoints,
              user: pointPercent,
              avg: avgPercent,
              showChart: true,
            ),
            SizedBox(
              height: 10,
            ),
            StatBox(
              title: "Total Packages Scanned",
              statTitle: "$packages Packages",
              image: 'assets/images/box.png',
              averageTitle: "Average: $avgPackages Packages",
              statPlain: packages,
              averagePlain: avgPackages,
              user: packagePercent,
              avg: avgPackagePercent,
              showChart: true,
            ),
            SizedBox(
              height: 10,
            ),
            StatBox(
              title: "Daily Streak",
              statTitle: "$streak Days",
              image: 'assets/images/streak.png',
              averageTitle: "Average: $avgStreak Days",
              statPlain: streak,
              averagePlain: avgStreak,
              user: streakPercent,
              avg: avgStreakPercent,
              showChart: true,
            ),
            SizedBox(
              height: 10,
            ),
            StatBox(
              title: "Team",
              statTitle: "$team",
              image: 'assets/images/team.png',
              averageTitle: "Team Points: $teamPoints",
              showChart: false,
            ),
          ],
        )));
  }
}

class StatBox extends StatefulWidget {
  final String title;
  final String statTitle;
  final String averageTitle;
  final String? statPlain;
  final String? averagePlain;
  final String image;
  final double? user;
  final double? avg;
  final bool showChart;

  bool isChartVisible = false;

  StatBox(
      {super.key,
      required this.title,
      required this.image,
      this.user,
      this.avg,
      required this.showChart,
      required this.statTitle,
      required this.averageTitle,
      this.statPlain,
      this.averagePlain});

  @override
  State<StatBox> createState() {
    return _StatBox();
  }
}

class _StatBox extends State<StatBox> {
  _StatBox();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            widget.isChartVisible = !widget.isChartVisible;
          });
        },
        child: Padding(
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
                              widget.statTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              widget.averageTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                            if (widget.showChart && widget.isChartVisible) ...{
                              const Divider(
                                indent: 5,
                                endIndent: 5,
                                color: Color.fromARGB(255, 78, 78, 78),
                                thickness: 0.5,
                              ),
                              Column(
                                children: <Widget>[
                                  const Padding(
                                      padding: EdgeInsets.only(top: 10)),
                                  LinearPercentIndicator(
                                    alignment: MainAxisAlignment.center,
                                    width: 200,
                                    lineHeight: 15,
                                    percent: widget.user!,
                                    leading: Container(
                                      width: 50,
                                      child: Text(
                                        "User",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    trailing: Container(
                                      width: 50,
                                      child: Text(
                                        widget.statPlain!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    progressColor: Colors.red,
                                    backgroundColor: Colors.transparent,
                                    barRadius: Radius.circular(5),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10)),
                                  LinearPercentIndicator(
                                    alignment: MainAxisAlignment.center,
                                    width: 200,
                                    lineHeight: 15,
                                    percent: widget.avg!,
                                    leading: Container(
                                      width: 50,
                                      child: Text(
                                        "Average",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    trailing: Container(
                                      width: 50,
                                      child: Text(
                                        widget.averagePlain!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    progressColor: Colors.orange,
                                    backgroundColor: Colors.transparent,
                                    barRadius: Radius.circular(5),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10)),
                                ],
                              ),
                            }
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
