import 'screens.dart';

const Color white = Color(0xFFFFFFFF);
const Color grey = Colors.grey;

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
    avgPoints = double.parse(responseJson['average_stats']['average_points'].toString()).toStringAsFixed(2);
    streak = responseJson['personal_stats']['daily_streak'].toString();
    avgStreak = double.parse(responseJson['average_stats']['average_streak'].toString()).toStringAsFixed(2);
    packages = responseJson['personal_stats']['packages_scanned'].toString();
    avgPackages = double.parse(responseJson['average_stats']['average_packages'].toString()).toStringAsFixed(2);
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
            const SizedBox(
              height: 10,
            ),
            StatBox(
              title: "Total Points Earned",
              statTitle: "$points Points",
              image: 'assets/images/badge.png',
              averageTitle: "Average: $avgPoints Points",
              statPlain: points,
              averagePlain: avgPoints,
              showChart: true,
              chartTitle: 'Points',
            ),
            const SizedBox(
              height: 10,
            ),
            StatBox(
              title: "Total Packages Scanned",
              statTitle: "$packages Packages",
              image: 'assets/images/box.png',
              averageTitle: "Average: $avgPackages Packages",
              statPlain: packages,
              averagePlain: avgPackages,
              showChart: true,
              chartTitle: 'Packages',
            ),
            const SizedBox(
              height: 10,
            ),
            StatBox(
              title: "Daily Streak",
              statTitle: "$streak Days",
              image: 'assets/images/streak.png',
              averageTitle: "Average: $avgStreak Days",
              statPlain: streak,
              averagePlain: avgStreak,
              showChart: true,
              chartTitle: 'Streak',
            ),
            const SizedBox(
              height: 10,
            ),
            StatBox(
              title: "Team",
              statTitle: "$team",
              image: 'assets/images/team.png',
              averageTitle: "Team Points: $teamPoints",
              showChart: false,
              statPlain: '',
              averagePlain: '',
              chartTitle: '',
            ),
          ],
        )));
  }
}

class StatBox extends StatefulWidget {
  final String title;
  final String statTitle;
  final String averageTitle;
  final String statPlain;
  final String averagePlain;
  final String image;
  final bool showChart;
  final String chartTitle;

  bool isChartVisible = false;

  StatBox(
      {super.key,
      required this.title,
      required this.image,
      required this.showChart,
      required this.statTitle,
      required this.averageTitle,
      required this.statPlain,
      required this.averagePlain,
      required this.chartTitle});

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
                          SizedBox(
                            height: 200,
                            width: 1000,
                            child: BarGraph(chartData: [
                              ChartData(
                                  widget.chartTitle,
                                  double.parse(widget.statPlain),
                                  double.parse(widget.averagePlain))
                            ], tooltip: TooltipBehavior(enable: true)),
                          )
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

class ChartData {
  ChartData(this.x, this.y, this.y1);
  final String x;
  final double y;
  final double y1;
}

class BarGraph extends StatelessWidget {
  final List<ChartData> chartData;
  final TooltipBehavior tooltip;
  const BarGraph({super.key, required this.chartData, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        // Columns will be rendered back to back
        tooltipBehavior: tooltip,
        enableSideBySideSeriesPlacement: true,
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries<ChartData, String>>[
          BarSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: 'Your stats'),
          BarSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y1,
              name: 'Average stats')
        ]);
  }
}
