import 'screens.dart';

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