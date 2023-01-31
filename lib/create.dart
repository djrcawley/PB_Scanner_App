import 'screens.dart';

class CreatePage extends StatelessWidget {
  final CameraDescription camera;
  const CreatePage({super.key, required this.camera});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Create Account'),
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
                    const Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirm Password',
                          hintText: 'Re-Enter password'),
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
                                      HomePage(camera: camera)));
                        },
                        child: const Text(
                          'Create',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    )),
              ],
            )),
          ),
          ),
    );
  }
}
