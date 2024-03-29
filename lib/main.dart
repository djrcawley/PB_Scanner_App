import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'screens.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  const storage = FlutterSecureStorage();
  String? user = await storage.read(key: 'user');

  Widget nextScreen = (user != null) ? HomePage(camera: firstCamera) : LoginPage(camera: firstCamera);

  runApp(
    MaterialApp(
      title: 'Navigation Basics',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: nextScreen,
    ),
  );
}
