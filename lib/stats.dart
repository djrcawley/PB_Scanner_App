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
  List<ChartData> chartData2 = [];
  List<rData> radData = [];
  late TooltipBehavior tooltip;
  

  Future<bool> buildList() async {
    Map<String, dynamic> jsonMap;
    List<String> names = ["Total points", "Packages scanned", "Daily streak"];
    List<int> personal=[];
    List<double> average=[];
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

    jsonMap = jsonDecode(response.body);
    int i=0;
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

    for(var i=0;i<personal.length;i++)
    {
      if(i==0)
      {
        chartData2.add(ChartData(names[i],personal[i],average[i]));
      }
      else
      {
        chartData.add(ChartData(names[i],personal[i],average[i]));
      }
      radData.add(rData(names[i], personal[i]));
    }
    setState(() {  });
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
      appBar: AppBar(title: Text("Statistics")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            BarGraph(chartData: chartData, tooltip: tooltip),
            BarGraph(chartData: chartData2, tooltip: tooltip),
            SizedBox(height: 50),
            Center(child: Text("Goals")),
            RadGraph(radData: radData, tooltip: tooltip)
          ]
        ) 
      )
    );
  }
}



class BarGraph extends StatelessWidget {
  final List<ChartData> chartData;
  final TooltipBehavior tooltip;
  const BarGraph({Key? key, required this.chartData, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      // Columns will be rendered back to back
      tooltipBehavior: tooltip,
      enableSideBySideSeriesPlacement: true,
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries<ChartData, String>>[
      ColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          name: 'Your stats'),
      ColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y1,
          name: 'Average stats')
      ]
    );
  }
}


class RadGraph extends StatelessWidget {
  final List<rData> radData;
  final TooltipBehavior tooltip;
  const RadGraph({Key? key, required this.radData, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(series: <CircularSeries>[
      // Renders radial bar chart
      RadialBarSeries<rData, String>(
        dataSource: radData,
        xValueMapper: (rData data, _) => data.x,
        yValueMapper: (rData data, _) => data.y,
        dataLabelSettings: DataLabelSettings(isVisible: true)
      )
    ]);
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1);
  final String x;
  final int y;
  final double y1;
}

class rData {
  rData(this.x, this.y);
  final String x;
  final int y;
}