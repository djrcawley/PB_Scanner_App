import 'screens.dart';

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
              final cameras = await availableCameras();
              final firstCamera = cameras.first;
              await availableCameras().then((cameras) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TakePictureScreen(camera: firstCamera)));
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
