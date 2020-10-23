import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/core/models/appMode.dart';
import 'package:provider_architecture/core/models/mainDisplayed.dart';
import 'package:provider_architecture/core/models/user.dart';

class InitSportifMonitoring extends StatefulWidget {
  @override
  SportifMonitoring createState() => SportifMonitoring();
}

class SportifMonitoring extends State<InitSportifMonitoring> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool flag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';

  String mainDataLabel = "Fréquence Cardiaque";
  String mainDataValue = "175";
  String mainDataUnit = "BPM";
  String mainDataImg = "pulse.png";

  String tlDataLabel = "Vitesse";
  String tlDataValue = "175";
  String tlDataUnit = "KM/H";
  String tlDataImg = "pulse.png";

  String trDataLabel = "Distance";
  String trDataValue = "4.07";
  String trDataUnit = "KM";
  String trDataImg = "pulse.png";

  String blDataLabel = "Puissance";
  String blDataValue = "120";
  String blDataUnit = "WATTS";
  String blDataImg = "pulse.png";

  String brDataLabel = "Cadence";
  String brDataValue = "75";
  String brDataUnit = "RPM";
  String brDataImg = "pulse.png";

  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  void initStopWatch() {
    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) {
      if (mounted)
        setState(() {
          hoursStr =
              ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
          minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
          secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainDisplayed = Provider.of<User>(context);

    if (secondsStr == '00' && minutesStr == '00') {
      initStopWatch();
    }

    Widget menusection = Container(
        padding: const EdgeInsets.only(top: 20, right: 0, left: 325),
        child: RawMaterialButton(
          onPressed: () {
            _scaffoldKey.currentState.openEndDrawer();
          },
          elevation: 0,
          fillColor: Colors.transparent,
          splashColor: Colors.black26,
          child: Icon(
            Icons.settings,
            size: 40.0,
          ),
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
        ));

    Widget stopwatchsection = Container(
      padding: EdgeInsets.only(top: 0, bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("TEMPS",
              style: TextStyle(
                fontSize: 20.0,
              )),
          Text(
            "$hoursStr:$minutesStr:$secondsStr",
            style: TextStyle(
              fontSize: 65.0,
            ),
          ),
        ],
      ),
    );

    Widget pausebutton = Container(
      padding: EdgeInsets.symmetric(horizontal: 70, vertical: 50),
      child: FlatButton(
        color: Colors.red,
        onPressed: () async {},
        child: Text(
          "PAUSE",
          style: TextStyle(color: Colors.white, fontSize: 50),
        ),
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.red, width: 2, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(15)),
      ),
    );

    Widget separator = Divider(
      color: Colors.black,
      indent: 40,
      endIndent: 40,
    );

    Widget mainData = Container(
        padding: EdgeInsets.only(top: 20, bottom: 10),
        child: Column(children: [
          Text(mainDataLabel, style: TextStyle(fontSize: 20)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Image.asset("images/" + mainDataImg, height: 90),
            Text(mainDataValue, style: TextStyle(fontSize: 90)),
            Text(mainDataUnit, style: TextStyle(fontSize: 40)),
          ])
        ]));

    Widget tlData = Container(
        padding: EdgeInsets.only(right: 30, bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(tlDataLabel, style: TextStyle(fontSize: 25)),
            Text(tlDataValue, style: TextStyle(fontSize: 40)),
            Text(tlDataUnit, style: TextStyle(fontSize: 25)),
          ],
        ));

    Widget trData = Container(
        padding: EdgeInsets.only(left: 30, bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(trDataLabel, style: TextStyle(fontSize: 25)),
            Text(trDataValue, style: TextStyle(fontSize: 40)),
            Text(trDataUnit, style: TextStyle(fontSize: 25)),
          ],
        ));

    Widget blData = Container(
        padding: EdgeInsets.only(right: 15, top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(blDataLabel, style: TextStyle(fontSize: 25)),
            Text(blDataValue, style: TextStyle(fontSize: 40)),
            Text(blDataUnit, style: TextStyle(fontSize: 25)),
          ],
        ));

    Widget brData = Container(
        padding: EdgeInsets.only(left: 15, top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(brDataLabel, style: TextStyle(fontSize: 25)),
            Text(brDataValue, style: TextStyle(fontSize: 40)),
            Text(brDataUnit, style: TextStyle(fontSize: 25)),
          ],
        ));

    Widget secondaryData = Container(
        padding: EdgeInsets.only(left: 75, right: 75, top: 20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            children: [tlData, trData],
          ),
          Row(children: [blData, brData])
        ]));

    Widget tiroir = Container(
        width: 800,
        child: Drawer(
            child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(top: 50, right: 0, left: 325),
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  elevation: 0,
                  fillColor: Colors.black,
                  splashColor: Colors.black,
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 40.0,
                  ),
                  padding: EdgeInsets.all(5.0),
                  shape: CircleBorder(),
                )),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        )));

    return Provider<MyMode>(
      create: (context) => MyMode(),
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: tiroir,
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 20),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            menusection,
            stopwatchsection,
            separator,
            mainData,
            separator,
            secondaryData
          ],
        ),
        bottomNavigationBar: pausebutton,
      ),
    );
  }
}
