import 'screens.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen(
      {super.key, required this.camera, required this.username});

  final CameraDescription camera;
  final String username;

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<TakePictureScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Scan')),
        body: Center(child: _buildQrView(context)));
    //print result to console
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  _onQRViewCreated(QRViewController controller) {
    bool hasExecuted = false;
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      if (result != null && !hasExecuted) {
        //accepted formats
        if (result!.format == BarcodeFormat.pdf417 ||
            result!.format == BarcodeFormat.dataMatrix ||
            result!.format == BarcodeFormat.code128) {
          // Set the flag to true to indicate that the code has been executed
          hasExecuted = true;

          presentLoader(context);
          String encoded = base64Encode(result!.code!.codeUnits);
          String username = widget.username;

          try {
            var results12 =
                await _sendScannedDataToServer(context, encoded, username)
                    .timeout(Duration(seconds: 15));

            Navigator.pop(context);
            //show result with presentAlert
            if (results12 == "This barcode was already upload") {
              await presentAlert(
                context,
                title: "Sorry! :(",
                message: "This barcode has already been scanned",
              );

              //WAIT 2 SECONDS
              await Future.delayed(Duration(seconds: 2));
              hasExecuted = false;
              //redirect to home
            } else if (results12 == "Could extract shipping info") {
              await presentAlert(
                context,
                title: "Sorry! :(",
                message: "Could not extract shipping info, please try again",
              );
              //WAIT 2 SECONDS
              await Future.delayed(Duration(seconds: 2));
              hasExecuted = false;
            } else if (results12.contains("PointsGained")) {
              Map<String, dynamic> jsonMap = jsonDecode(results12);
              await presentResult(context, map: jsonMap);

              //WAIT 2 SECONDS
              await Future.delayed(Duration(seconds: 2));
              hasExecuted = false;
            }
          } catch (e) {
            Navigator.pop(context);
            await presentAlert(
              context,
              title: "Sorry! :(",
              message: "Could not connect to server, please try later",
            );
            //WAIT 2 SECONDS
            await Future.delayed(Duration(seconds: 2));
            hasExecuted = false;
          }

          // print("result_code:");
          // print(result!.code);
          // print("result_type:");
          // print(result!.format);

        }
        //else if format are not pdf417, datamatrix and C128
        else if (result!.format != BarcodeFormat.pdf417 ||
            result!.format != BarcodeFormat.dataMatrix ||
            result!.format != BarcodeFormat.code128) {
          hasExecuted = true;
          await presentAlert(
            context,
            title: "Sorry! :(",
            message: "This barcode is not supported",
          );
          //WAIT 2 SECONDS
          await Future.delayed(Duration(seconds: 2));
          hasExecuted = false;
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

Future<String> _sendScannedDataToServer(
    context, String encodedData, String username) async {
  final HttpUploadService _httpUploadService = HttpUploadService(username);
  //timer to close loader after 15 seconds

  var responseDataHttp =
      await _httpUploadService.uploadEncodedData(encodedData);

  // print(responseDataHttp);
  return responseDataHttp;
}

class HttpUploadService {
  String username = '';

  HttpUploadService(this.username);

  Future<String> uploadEncodedData(String encodedData) async {
    Uri tokenUrl = Uri.parse('https://137.99.130.182/token');
    final hour = DateTime.now().toUtc().hour.toString();
    var bytes = utf8.encode(username + hour);
    final String userHash = sha256.convert(bytes).toString();

    //if no response for 15 seconds, close loader

    final responseToken = await http.post(tokenUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, String>{'username': username, 'key': userHash}));

    final token = jsonDecode(responseToken.body)['token'];
    // print("TOKEN:");
    // print(token);
    // print("encodedData:");
    // print(encodedData);

    Uri uri = Uri.parse('https://137.99.130.182');
    //not multipartrequest
    final responseUpload = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'token': token,
          'encodedData': encodedData
        }));

    //get response
    var responseBytes = responseUpload.bodyBytes;

    var responseString = utf8.decode(responseBytes);
    // print('\n\n');
    // print('RESPONSE WITH HTTP');
    // print(responseString);
    // print('\n\n');
    return responseString;
  }
}

void presentLoader(BuildContext context,
    {String text = 'Uploading...',
    bool barrierDismissible = false,
    bool willPop = true}) {
  showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (c) {
        return WillPopScope(
          onWillPop: () async {
            return willPop;
          },
          child: AlertDialog(
            content: Container(
              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ),
          ),
        );
      });
}

Future<void> presentAlert(BuildContext context,
    {String title = '', String message = '', Function()? ok}) {
  return showDialog(
      context: context,
      builder: (c) {
        return AlertDialog(
          title: Text('$title'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text('$message'),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                // style: greenText,
              ),
              onPressed: ok != null ? ok : Navigator.of(context).pop,
            ),
          ],
        );
      });
}

Future<void> presentResult(BuildContext context,
    {required Map<String, dynamic> map, Function()? ok}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: StatefulBuilder(builder: (context, setState) {
            return Result(jsonMap: map);
          }),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                // style: greenText,
              ),
              //return to home
              onPressed: ok != null ? ok : Navigator.of(context).pop,
            ),
          ],
        );
      });
}
