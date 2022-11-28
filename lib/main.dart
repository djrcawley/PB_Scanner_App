// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:flutter/material.dart';

//for camera page
import 'package:camera/camera.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() {
  //initing camera page required materials
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: LoginPage(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Homepage'),
            actions: [
              PopupMenuButton<int>(
                  itemBuilder: (context) => [
                        PopupMenuItem<int>(value: 0, child: Text('Settings')),
                      ],
                  onSelected: (int value) {
                    if (value == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Result()));
                    }
                  })
            ],
            automaticallyImplyLeading: false),
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            ElevatedButton(
              child: Text('Leaderboard'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Leaderboard()),
                );
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              child: Text('Individual Statistics'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Individual_Statistics()),
                );
              },
            )
          ],
        ),
        //bottom right camera button
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              await availableCameras().then((cameras) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CameraPage(cameras: cameras)));
              });
            }));
  }
}

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class Camera_p extends StatelessWidget {
  const Camera_p({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class Individual_Statistics extends StatelessWidget {
  const Individual_Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Individual Statistics'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Column(
          //Center Verticall & Horizontally
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 0),
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('assets/images/pb-logo.png'))),
            Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter email'),
                )),
            Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter password'),
                )),
            Padding(
                padding: EdgeInsets.only(top: 15),
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => FirstRoute()));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

//the following classes are for Camera Page
class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraPage({this.cameras, Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  XFile? pictureFile;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras![0],
      ResolutionPreset.max,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: CameraPreview(controller),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              XFile? pictureFile = await controller.takePicture();
              setState(() {});
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                    imagePath: pictureFile!.path,
                  ),
                ),
              );
            },
            child: const Text('Capture'),
          ),
        ),

        // ImagePath = pictureFile!.path,

        // Image.network(
        //   pictureFile!.path,
        //   height: 200,
        // )
        //Android/iOS
        // Image.file(File(pictureFile!.path)))
      ],
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uploading...')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      // body: Image.file(File(imagePath)),
      body: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.blue,
          size: 200,
        ),
      ),
    );
  }
}
//camera page ends


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