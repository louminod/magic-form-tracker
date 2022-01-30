import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String url = "https://api.resamania.com/magicform/public/attendances/tRJo-iT8m-OOeA-OjFn";
  int? free;
  int? inside;
  int? total;
  late bool loading;

  @override
  void initState() {
    super.initState();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MagicForm"),
        centerTitle: true,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: 130,
              margin: EdgeInsets.all(30),
              child: ListView(
                children: [
                  Card(
                    color: Colors.red,
                    elevation: 7,
                    child: ListTile(
                      title: Column(
                        children: [
                          Icon(Icons.people, size: 50, color: Colors.white),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${inside ?? ''}",
                                style: TextStyle(fontSize: 50, color: _color()),
                              ),
                              Text(" / ", style: TextStyle(fontSize: 20, color: Colors.white)),
                              Text(
                                total != null ? total.toString() : '',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            loading = true;
          });
          await _fetchData();
          setState(() {
            loading = false;
          });
        },
        child: Icon(Icons.refresh),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _fetchData() async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      free = int.parse(response.body.split('<span class="value">')[1].split('</span>')[0]);
      inside = int.parse(response.body.split('<div class="attendance">')[1].split(' personne')[0]);
      total = free! + inside!;
    } else {
      print(response.statusCode);
    }
  }

  Color _color() {
    if (inside != null) {
      if (inside! < (total! / 2)) {
        return Colors.green;
      } else {
        return Colors.orange;
      }
    } else {
      return Colors.black;
    }
  }
}
