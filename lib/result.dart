
import 'screens.dart';

class Result extends StatefulWidget {
  final Map<String,dynamic> jsonMap;
  const Result({super.key, required this.jsonMap});

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
    for(var entry in widget.jsonMap.entries)
    {
      await Future.delayed(Duration(seconds: 1));
      displayStr = displayStr + entry.value.toString()+'\n';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Success!'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            Text(displayStr, style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
            Image.asset(height: 100,
                        width: 100,
                        'assets/images/box.png')
          ],
        ),          
      )
    );
  }
}