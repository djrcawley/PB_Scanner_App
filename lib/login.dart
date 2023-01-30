import 'screens.dart';

class LoginPage extends StatelessWidget {
  final CameraDescription camera;
  const LoginPage({super.key, required this.camera});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: Center(
            child: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Container(
                        width: 120,
                        height: 90,
                        child: Image.asset('assets/images/pb-logo.png'))),
                const Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Enter email'),
                    )),
                const Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Enter password'),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      MyStatefulWidget(camera: camera)));
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    )),
              ],
            )),
          ),
          bottomNavigationBar: Container(
              child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  onPressed: () {},
                  child: const Text('New User? Create Account')))),
    );
  }
}
