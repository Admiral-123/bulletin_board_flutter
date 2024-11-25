// create the home page of the app

import 'package:bulletin_board/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    DBHelper? dbRef;

    List<Map<String, dynamic>> allPoints = [];

    void getPoints() async {
      allPoints = await dbRef!.readDB();
    }

    @override
    void initState() {
      super.initState();
      dbRef = DBHelper.getInstance;

      getPoints();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Bulletin'),
        backgroundColor: Colors.amber,
      ),
      body: allPoints.isNotEmpty
          ? Center() // implement ui
          : Center(
              child: Text('no points yet'),
            ),
    );
  }
}
