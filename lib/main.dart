import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<Map<String, dynamic>>? habits;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => null,
        ),
        body: ListView(
          children: [
            ListTile(
                title: Text(_buildTimeSince('2022-07-17')),
                subtitle: const Text('Drank alcohol'),
                trailing: IconButton(
                    onPressed: () => null, icon: const Icon(Icons.replay)),
                leading: const Icon(Icons.mood)),
            ListTile(
                title: const Text('7 days 10 hours 20 minutes 9 seconds ago'),
                subtitle: const Text('Took a walk'),
                trailing: IconButton(
                    onPressed: () => null, icon: const Icon(Icons.replay)),
                leading: const Icon(Icons.mood_bad))
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    _initHabits();
  }

  void _initHabits() async {
    prefs = await SharedPreferences.getInstance();
    habits = prefs
        ?.getStringList('habits')
        ?.map((String e) {
          List<String> row = e.split(',');
          return {'title': row[0], 'date': row[1]};
        })
        .cast<Map<String, dynamic>>()
        .toList();
  }

  String _buildTimeSince(String date) {
    Duration dateDiff = DateTime.now().difference(DateTime.parse(date));
    return '${dateDiff.inDays} days ${dateDiff.inHours % 24} hours '
        '${dateDiff.inMinutes % 60} minutes ${dateDiff.inSeconds % 60} seconds';
  }
}
