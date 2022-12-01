import 'screens.dart';

void main() {
  //initing camera page required materials
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: LoginPage(),
  ));
}
