
import 'screens.dart';

class Result extends StatefulWidget {
  final String jsonStr;
  const Result({super.key, required this.jsonStr});

  @override
  State<Result> createState() => ResultState();
}

class ResultState extends State<Result>
{
  String displayStr = 'Score\n\n';
  
  @override
  void initState() {
    super.initState();
    buildList();
  }

  void buildList() async
  {
    final jsonMap = jsonDecode(widget.jsonStr);
    for(var entry in jsonMap.entries)
    {
      await Future.delayed(Duration(seconds: 1));
      displayStr = displayStr + (entry.key +': ' + entry.value.toString()+'\n');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              Text(displayStr, style: TextStyle(fontSize: 30),textAlign: TextAlign.center,)
            ], 
          ),
      )
    );
  }
}