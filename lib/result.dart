import 'screens.dart';

class Result extends StatefulWidget {
  final Map<String, dynamic> jsonMap;
  const Result({super.key, required this.jsonMap});

  @override
  State<Result> createState() => ResultState();
}

class ResultState extends State<Result> {
  String displayStr = 'Successful Scan!\n\n';

  @override
  void initState() {
    super.initState();
    buildList();
  }

  void buildList() async {
    for (var entry in widget.jsonMap.entries) {
      await Future.delayed(Duration(seconds: 1));
      displayStr = displayStr + entry.value.toString() + '\n';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min, //Shrink to Size
      children: <Widget>[
        Text(
          displayStr,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        Image.asset(height: 100, width: 100, 'assets/images/box.png')
      ],
    );
  }
}
