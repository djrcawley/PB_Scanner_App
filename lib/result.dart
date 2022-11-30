import 'screens.dart';
import 'package:http/http.dart' as http;

//Variable
var gameData; /// Store API response with points


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

  

  upload() async
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
    /// How to access variables within json: responseJSON['variables']
    gameData = responseJSON;
    print(gameData);
    setState(() {});
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            //Image.file(imageFile),
            //Text('Vendor: ' +jsonMap['Vendor']),

            //Text(' Postage Value' +jsonMap['Postage Value']),

            ElevatedButton(
              child: const Text('Upload Test'),
              onPressed: () {
                upload();
              }
            ),

          //Run if gameData != null
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