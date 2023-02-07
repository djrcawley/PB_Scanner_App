import 'screens.dart';
import 'package:http/http.dart' as http;

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
  bool invalidPassword = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    userController.dispose();
    passController.dispose();
    passCheckController.dispose();
    super.dispose();
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
                              if (value != '') {
                                return null;
                              }
                                return 'Plase enter a username.';
                            }
                        )),
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
                              if (value != '') {
                                return null;
                              }
                                return 'Plase enter password.';
                            }
                        )),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: TextFormField(
                            controller: passCheckController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Confirm Password',
                              hintText: 'Re-Enter password',
                            ),
                            validator: (value) {
                              if (value == passController.text) {
                                return null;
                              }
                              if(value == ''){
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
                              if (_formKey.currentState!.validate()) {
                                createAccount(userController.text,
                                        passController.text)
                                    .then((value) {
                                  if (value == true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => HomePage(
                                                camera: widget.camera, username: userController.text)));
                                  } else {
                                    /// account already exist toast???
                                    showAlertDialog(context);
                                  }
                                });
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
  Uri uri = Uri.parse('http://137.99.130.182/create');
  final response = await http.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body:
          jsonEncode(<String, String>{'username': username, 'password': pass}));

  var responseDecoded = response.body;
  if (responseDecoded == 'Success') {
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

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () { Navigator.of(context).pop(); },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: const Text("This username has already been taken."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
