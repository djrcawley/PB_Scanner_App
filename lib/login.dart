import 'screens.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  final CameraDescription camera;
  const LoginPage({
    super.key,
    required this.camera,
  });

  @override
  State<LoginPage> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();

  var incorrectCredentials = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Container(
                            width: 120,
                            height: 90,
                            child: Image.asset('assets/images/pb-logo.png'))),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: TextFormField(
                            controller: userController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                                hintText: 'Enter email'),
                            validator: (value) {
                              if (value != '' && !incorrectCredentials) {
                                return null;
                              } else if (incorrectCredentials == true) {
                              return 'The username/password is incorrect.';
                              }
                              return 'Plase enter a username.';
                            })),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: TextFormField(
                            controller: passController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                hintText: 'Enter password'),
                            validator: (value) {
                              if (value != '' && !incorrectCredentials) {
                                return null;
                              } else if (incorrectCredentials == true) {
                                return '';
                              }
                              return 'Plase enter a password.';
                            })),
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
                              if (_formKey.currentState!.validate() ||
                                  (incorrectCredentials == true && userController.text.isNotEmpty && passController.text.isNotEmpty)) {
                                loginRequest(userController.text,
                                        passController.text)
                                    .then((value) {
                                  if (value == true) {
                                    incorrectCredentials = false;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => HomePage(
                                                camera: widget.camera,
                                                username:
                                                    userController.text)));
                                  } else {
                                    incorrectCredentials = true;
                                    _formKey.currentState!.validate();
                                  }
                                });
                              } else {
                                incorrectCredentials = false;
                                _formKey.currentState!.validate();
                              }
                            },
                            child: const Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        )),
                  ],
                ))),
      ),
      bottomNavigationBar: TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 15),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CreatePage(camera: widget.camera)));
          },
          child: const Text('New User? Create Account')),
    );
  }
}

Future<bool> loginRequest(username, pass) async {
  Map<String, String> body = {'username': username, 'password': pass};
  String jsonBody = json.encode(body);

  Uri uri = Uri.parse('http://137.99.130.182/login');

  final encoding = Encoding.getByName('utf-8');
  final header = {
    "Accept": "application/json",
    "Content-Type": "application/json"
  };

  Response response = await post(
    uri,
    headers: header,
    body: jsonBody,
    encoding: encoding,
  );

  var responseDecoded = response.body;
  if (responseDecoded == 'Success') {
    return true;
  }
  return false;
}
