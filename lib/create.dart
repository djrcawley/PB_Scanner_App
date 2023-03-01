import 'screens.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreatePage extends StatefulWidget {
  final CameraDescription camera;
  const CreatePage({
    super.key,
    required this.camera,
  });

  @override
  State<CreatePage> createState() {
    return _CreatePage();
  }
}

class _CreatePage extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();
  final passCheckController = TextEditingController();
  var existingAccount = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    userController.dispose();
    passController.dispose();
    passCheckController.dispose();
    super.dispose();
  }

  bool _mainPassword = false;
  bool _secondaryPassword = false;
  void _togglevisibility(isMain) {
    setState(() {
      if (isMain) {
        _mainPassword = !_mainPassword;
      } else {
        _secondaryPassword = !_secondaryPassword;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Create Account'),
          ),
      body: Center(
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Create an account, It's free ",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                          )
                        ],
                      ),
                    ),
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
                              if (value != '' && !existingAccount) {
                                return null;
                              } else if (existingAccount == true) {
                                return 'This username is already taken.';
                              }
                              return 'Plase enter a username.';
                            })),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: TextFormField(
                            controller: passController,
                            obscureText: !_mainPassword,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                hintText: 'Enter password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _togglevisibility(true);
                                  },
                                  icon: Icon(
                                    _mainPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.blue,
                                  ),
                                )),
                            validator: (value) {
                              if (value != '') {
                                return null;
                              }
                              return 'Plase enter password.';
                            })),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: TextFormField(
                            controller: passCheckController,
                            obscureText: !_secondaryPassword,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Confirm Password',
                                hintText: 'Re-Enter password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _togglevisibility(false);
                                  },
                                  icon: Icon(
                                    _secondaryPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.blue,
                                  ),
                                )),
                            validator: (value) {
                              if (value == passController.text) {
                                return null;
                              }
                              if (value == '') {
                                return 'Plase enter password.';
                              }
                              return "Passwords do not match.";
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
                                  (existingAccount &&
                                      userController.text.isNotEmpty &&
                                      passController.text.isNotEmpty &&
                                      passCheckController.text.isNotEmpty)) {
                                createAccount(userController.text,
                                        passController.text)
                                    .then((value) {
                                  if (value == true) {
                                    existingAccount = false;

                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return HomePage(
                                          camera: widget.camera,
                                          username: userController.text);
                                    }), (r) {
                                      return false;
                                    });
                                  } else {
                                    existingAccount = true;
                                    _formKey.currentState!.validate();
                                  }
                                });
                              } else {
                                existingAccount = false;
                                _formKey.currentState!.validate();
                              }
                            },
                            child: const Text(
                              'Sign up',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        )),
                  ],
                ))),
      ),
    );
  }
}

Future<bool> createAccount(username, pass) async {
  var bytes = utf8.encode(pass);
  final String pwh = sha256.convert(bytes).toString();
  Uri uri = Uri.parse('https://137.99.130.182/create');
  final response = await http.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body:
          jsonEncode(<String, String>{'username': username, 'password': pwh}));

  var responseDecoded = response.body;
  if (responseDecoded == 'Success') {
    const storage = FlutterSecureStorage();
    await storage.write(key: "user", value: username);
    await storage.write(key: "pass", value: pwh);
    return true;
  }
  return false;
}

bool validatePassword(String pass, String check) {
  if (pass != check) {
    return false;
  }
  return true;
}
