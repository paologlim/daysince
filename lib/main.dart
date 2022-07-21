import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'habit.dart';
import 'new_habit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Days Since',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Days Since'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences? prefs;
  List<Habit> habits = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NewHabit()))
              .then((value) {
            if (value != null) {
              setState(() => habits.add(value));
              _saveHabits();
            }
          }),
        ),
        body: ListView(
          children: habits
              .map(
                (Habit habit) => ListTile(
                  title: Text(_buildTimeSince(habit.startedAt)),
                  subtitle: Text(habit.habit),
                  trailing: IconButton(
                      onPressed: () => _buildResetDialog(habit),
                      icon: const Icon(Icons.replay)),
                  leading: _buildProgressIcon(habit),
                  onTap: () => _buildDeleteDialog(habit),
                ),
              )
              .toList(),
        ));
  }

  @override
  void initState() {
    super.initState();
    _initHabits();
    _initTimers();
  }

  void _initHabits() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      habits = prefs?.getStringList('habits')?.map((String e) {
            List<String> row = e.split(',');
            return Habit(
                habit: row[0], startedAt: DateTime.parse(row[1]), type: row[2]);
          }).toList() ??
          [];
    });
  }

  String _buildTimeSince(DateTime date) {
    Duration dateDiff = DateTime.now().difference(date);
    return '${dateDiff.inDays} days ${dateDiff.inHours % 24} hours '
        '${dateDiff.inMinutes % 60} minutes ${dateDiff.inSeconds % 60} seconds';
  }

  void _resetHabit(Habit habit) {
    setState(() {
      habit.startedAt = DateTime.now();
    });
    _saveHabits();
    Navigator.pop(context);
  }

  void _saveHabits() async {
    prefs?.setStringList('habits',
        habits.map<String>((Habit h) => '${h.habit},${h.startedAt},${h.type}').toList());
  }

  void _initTimers() {
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {});
    });
  }

  void _buildDeleteDialog(Habit habit) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(habit.habit),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Delete?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => _deleteHabit(habit),
              style: TextButton.styleFrom(
                primary: Colors.purple,
              ),
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                primary: Colors.purple,
              ),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteHabit(Habit habit) {
    setState(() {
      habits.remove(habit);
    });
    _saveHabits();
    Navigator.pop(context);
  }

  void _buildResetDialog(Habit habit) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(habit.habit),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Reset?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => _resetHabit(habit),
              style: TextButton.styleFrom(
                primary: Colors.purple,
              ),
              child: const Text('Reset'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                primary: Colors.purple,
              ),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  IconButton _buildProgressIcon(Habit habit) {
    IconData progressIcon = Icons.mood_bad;

    switch(habit.type) {
      case 'good':
        if(DateTime.now().difference(habit.startedAt).inDays <= 3) {
          progressIcon = Icons.mood;
        }
        break;
      case 'bad':
        if(DateTime.now().difference(habit.startedAt).inDays >= 3) {
          progressIcon = Icons.mood;
        }
    }
    return IconButton(
      icon: Icon(progressIcon),
      onPressed: () => null,
    );
  }
}
