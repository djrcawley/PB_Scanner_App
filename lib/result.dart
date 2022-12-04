
import 'screens.dart';
import 'package:http/http.dart' as http;


class Result extends StatefulWidget {
  final String jsonStr;
  const Result({super.key, required this.jsonStr});

  @override
  State<Result> createState() => ResultState();

  
}

class ResultState extends State<Result>
{
  bool timer1 = true;
  bool timer2 = true;
  bool timer3 = true;

  

  Future<Map<String, dynamic>> upload() async
  {
    File imageFile = File('assets/images/testBarcode.png');
    final request = http.MultipartRequest("POST", Uri.parse("http://sdp23.cse.uconn.edu"));
    final headers = {"Content-type": "multipart/form-data"};

    request.files.add(
      http.MultipartFile(
        'file',
        imageFile.readAsBytes().asStream(),
        imageFile.lengthSync(),
        filename: imageFile.path.split("/").last,
        contentType: MediaType('image', 'png'),
      ),
    );

    request.headers.addAll(headers);

    print("request: "+ request.toString());
    
    var response = await request.send();

    
    http.Response res = await http.Response.fromStream(response);
    final responseJSON = jsonDecode(res.body);
    return responseJSON;
    /// Maybe: Add call here to update displayed points
    /// 
  }


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
    final jsonMap = jsonDecode(widget.jsonStr);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),

      body: Column(
        children: <Widget> [
          const Text("Test Text"),
          const Text("test2")
          //for(var i in jsonMap ) Text(jsonMap[i]),

        ], 
      ), 
    );
  }
}



/*
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
*/



/*

      body: FutureBuilder<Map<String, dynamic>> (
        future: upload(),
        builder: ((context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if(snapshot.hasData){
            var testData = snapshot.data;
            print(snapshot.data?['PointsGained']);
            return Center (
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: testData!.entries.map((entry) {
                  return Container(
                  child: ListTile(
                      title: Text(entry.toString()),
                  ),
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  color: Colors.green[100],
                      );
                  }).toList(),
              )
            );
            
          }
          else {
            return CircularProgressIndicator();
          }

        }
      
      
      
      
      Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: gameData.entries.map((entry) {
              return Container(
                  child: ListTile(
                      title: Text(entry.toString()),
                  ),
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  color: Colors.green[100],
              );
          }).toList(),
      */