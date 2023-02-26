import 'screens.dart';
import 'package:http/http.dart' as http;

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

  void buildList() async {
    var stringy = await widget.main();
    jsonMap = jsonDecode(stringy);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Leaderboard')),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TopRow(),
              Divider(),
              ListView.builder(
                shrinkWrap: true,
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
                },
              ),
            ],
          ),
        ));
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
          child: Text('Rank'),
        ),
        SizedBox(width: 90),
        Container(alignment: Alignment.center, child: Text('User')),
        Spacer(),
        Container(
          width: 50,
          child: Text('Points'),
        ),
      ],
    );
  }
}

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const <Widget>[
            // Expanded(
            //   child: Card(
            //     child: SizedBox.expand(),
            //   ),
            // ),
            Divider(),
            // Expanded(
            //   child: Card(
            //     child: SizedBox.expand(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
