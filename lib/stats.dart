import 'screens.dart';

const Color primary = Color(0xFFFF3378);
const Color secondary = Color(0xFFFF2278);
const Color black = Color(0xFF000000);
const Color white = Color(0xFFFFFFFF);
const Color grey = Colors.grey;
const Color red = Color(0xFFec5766);
const Color green = Color(0xFF43aa8b);
const Color blue = Color(0xFF28c2ff);

List<Color> gradientColors = [primary];

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() {
    return _StatsPageState();
  }
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey.withOpacity(0.25),
        body: SingleChildScrollView(
            child: Column(
          children: const [
            SizedBox(
              height: 10,
            ),
            StatBox(title: "Total Points Earned", stat: "2645 Points", image: 'assets/images/badge.png', average: "Average: 265 Points"),
            SizedBox(
              height: 10,
            ),
            StatBox(title: "Total Packages Scanned", stat: "16 Packages", image: 'assets/images/box.png', average: "Average: 2 Packages"),
          ],
        )));
  }
}

class StatBox extends StatelessWidget {
 final String title;
 final String stat;
 final String average;
 final String image;
 const StatBox({super.key, required this.title, required this.stat, required this.image, required this.average});

 @override
 Widget build(BuildContext context) {
   return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: grey.withOpacity(0.01),
                        spreadRadius: 10,
                        blurRadius: 3,
                        // changes position of shadow
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Image.asset(
                              height: 100,
                              width: 100,
                              image,
                            ),
                            Text(
                              stat,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              average,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
 }
}
