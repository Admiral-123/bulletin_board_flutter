import 'package:bulletin_board/db_helper.dart';
import 'package:bulletin_board/login.dart';
import 'package:bulletin_board/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TextEditingController pointController = TextEditingController();
  DBHelper? dbRef;

  List<Map<String, dynamic>> allPoints = [];

  Future<void> getPoints() async {
    try {
      allPoints = await dbRef!.readDB();
      setState(() {});
    } catch (e) {
      print("Error fetching points: $e");
    }
  }

  var name = '';

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getPoints(); // Fetch points on init
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulletin'),
        backgroundColor: Colors.amber,
        actions: [
          InkWell(
              onTap: () {
                showDialog(
                    context: (context),
                    builder: (context) {
                      Future.delayed(const Duration(milliseconds: 1500), () {
                        Navigator.pop(context);
                      });
                      return AlertDialog(
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                              'tap twice to logout',
                              style: TextStyle(fontSize: 25.0),
                            )),
                          )
                        ],
                      );
                    });
              },
              onDoubleTap: () async {
                print('logout');
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));

                var pref = await SharedPreferences.getInstance();
                pref.setBool(SplashScrState.keyLogin, false);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(Icons.logout),
              ))
        ],
      ),
      body: allPoints.isNotEmpty
          ? ListView.builder(
              itemCount: allPoints.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.star),
                  title: Text(allPoints[index][dbRef!.POINT_BULLETIN]),
                  subtitle: Text('by: ${allPoints[index][dbRef!.USER_NAME]}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await dbRef!.removePoint(
                          sno: allPoints[index][dbRef!.SNO_BULLETIN]);
                      getPoints(); // Refresh list
                    },
                  ),
                );
              },
            )
          : const Center(
              child: Text('No points yet'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 700,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: pointController,
                      decoration: InputDecoration(
                        labelText: 'Point',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (pointController.text.isNotEmpty) {
                          await dbRef!.addPoint(
                              pt: pointController.text.trim(), uname: name);
                          pointController.clear();
                          getPoints();
                          Navigator.pop(context); // Close the modal
                        }
                      },
                      child: const Text('Push'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void getUserName() async {
    try {
      var namePref = await SharedPreferences.getInstance();
      name = namePref.getString(SplashScrState.keyUser)!;
    } catch (e) {
      print('err in getting name $e');
      setState(() {
        name = 'Anonymous';
      });
    }
  }
}


// upgrade the schema before adding new columns