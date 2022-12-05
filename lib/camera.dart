import 'screens.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            List<String> _images = [];
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();
            _images.add(image.path);
            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: _images,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final List<String> imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath.first)),
      //button to upload image
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          presentLoader(context, text: 'Uploading...');
          // Add your onPressed code here!
          final HttpUploadService _httpUploadService = HttpUploadService();
          var responseDataHttp =
              await _httpUploadService.uploadPhotos(imagePath);
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Result(jsonStr: responseDataHttp)));
          //await presentAlert(context,
          //    title: 'Success', message: responseDataHttp);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class HttpUploadService {
  Future<String> uploadPhotos(List<String> paths) async {
    Uri uri = Uri.parse('http://137.99.130.182');
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    for (String path in paths) {
      request.files.add(await http.MultipartFile.fromPath('file', path));
    }

    http.StreamedResponse response = await request.send();
    var responseBytes = await response.stream.toBytes();
    var responseString = utf8.decode(responseBytes);
    print('\n\n');
    print('RESPONSE WITH HTTP');
    print(responseString);
    print('\n\n');
    return responseString;
  }
}

void presentLoader(BuildContext context,
    {String text = 'Aguarde...',
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
