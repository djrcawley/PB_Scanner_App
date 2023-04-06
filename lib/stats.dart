import 'dart:ui';

import 'screens.dart';
import 'package:http/http.dart' as http;


class _ChartApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StatsPage(username: "teset"),
    );
  }
}

class StatsPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  final String username;
  const StatsPage({Key? key, required this.username}) : super(key: key);

  @override
  StatsPageState createState() => StatsPageState();
}

class StatsPageState extends State<StatsPage> {
  List<ChartData> chartData = [];
  late TooltipBehavior tooltip;
  

  Future<bool> buildList() async {
    Map<String, dynamic> jsonMap;
    List<String> names = ["Total points", "Packages scanned", "Daily streak"];
    List<int> personal=[];
    List<double> average=[];
    print(widget.username);
    String url = "https://sdp23.cse.uconn.edu/stats";
    var response = await http.post(
      Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': widget.username,
        }),
    );

    print(response.body.toString());
    jsonMap = jsonDecode(response.body);
    print("jsonMap initialized");
    int i=0;
    print(jsonMap['personal_stats']);
    for(var item in jsonMap.entries)
    {
      for(var item2 in item.value.entries)
      {
        if(i>=1&&i<=3)
        {
          personal.add(item2.value);
        }
        else if(i>=4&&i<=6)
        {
          average.add(item2.value);
        }
        //chartData.add(ChartData(item['total_points'], item['packages_scanned']));
        i++;
      }
    }
    print(personal);
    print(average);

    for(var i=0;i<personal.length;i++)
    {
      chartData.add(ChartData(names[i],personal[i],average[i]));
    }
    return true;
    //item['username'].toString()+'\'s points'
  }

  @override
  void initState() {
    tooltip = TooltipBehavior(enable: true);
    super.initState();
    buildList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
                    // Columns will be rendered back to back
                    tooltipBehavior: tooltip,
                    enableSideBySideSeriesPlacement: true,
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries<ChartData, String>>[
          ColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: '2014'),
          ColumnSeries<ChartData, String>(
              opacity: 0.9,
              width: 0.4,
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y1,
              name: '2015')
        ]))));
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1);
  final String x;
  final int y;
  final double y1;
}