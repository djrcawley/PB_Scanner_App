import 'screens.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => ResultState();

  
}

class ResultState extends State<Result>
{
  bool timer1 = true;
  bool timer2 = true;
  bool timer3 = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      setState(() {
        timer1 = false;
      });
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        timer2 = false;
      });
    });
    Timer(Duration(seconds: 3), () {
      setState(() {
        timer3 = false;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [

            const Text('Barcode Scanned!', style: TextStyle(fontSize: 25),),

            if(timer1) ...[
            ]
            else ...[
              const Text('Scanned package: +100',style: TextStyle(fontSize: 25),),
            ],
            if(timer2) ...[
              const Text(''),
            ]
            else ...[
              const Text('USPS vendor: +50',style: TextStyle(fontSize: 25),),
            ],
            if(timer3) ...[
              const Text(''),
            ]
            else ...[
              const Text('\nTotal: +150 points',style: TextStyle(fontSize: 25),),
            ],
            
            


          ],
        ),
      ),
    );
  }

}