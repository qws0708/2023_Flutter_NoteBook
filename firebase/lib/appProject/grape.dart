import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Grape());
}

class Grape extends StatefulWidget {
  const Grape({super.key});

  @override
  State<Grape> createState() => _GrapeState();
}

class _GrapeState extends State<Grape> {
  // void initState() {
  //   super.initState();
  //   _loadCounter();
  // }

  // Future<void> _loadCounter() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     addAllData = (prefs.getInt('counter') ?? 0);
  //   });
  // }

  // Future<void> _divideAllGrapeData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     divide = (addAllData / counter) as int;
  //     prefs.setInt('divide', divide);
  //   });
  // }

  // // ignore: non_constant_identifier_names
  // Future<void> _number_to_zero() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     prefs.setInt('counter', addAllData);
  //   });
  // }

  // ignore: must_be_immutable
  final List<int> _yValue = []; //그래프 y축 값
  final List<String> _xValue = []; //그래프 x축 값
  List<_SalesData> grapeData = [];
  int addAllData = 0;
  int counter = 0;
  int divide = 0;

  Future wait() async {
    await Future.delayed(const Duration(seconds: 1));
    return grapeData;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection(("Counter Number"));

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Grape"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: StreamBuilder(
                  stream: users.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }

                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          _yValue.add(snapshot.data!.docs[index]['total']);
                          _xValue.add(snapshot.data!.docs[index]['time']);
                          grapeData
                              .add(_SalesData(_xValue[index], _yValue[index]));

                          return ListTile(
                            title: Text(
                                ' Date : ${snapshot.data!.docs[index]['time']}'),
                            subtitle: Text(
                                '  Score : ${snapshot.data!.docs[index]['total']}'),
                          );
                        });
                  },
                ),
              ),
              SizedBox(
                height: 300,
                child: FutureBuilder(
                    future: wait(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) {
                        return const Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator());
                      }
                      return SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        title: ChartTitle(text: 'Example Grape'),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <ChartSeries<_SalesData, String>>[
                          LineSeries<_SalesData, String>(
                              dataSource: grapeData,
                              xValueMapper: (_SalesData sales, _) => sales.time,
                              yValueMapper: (_SalesData sales, _) =>
                                  sales.score,
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true))
                        ],
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.time, this.score);

  final String time;
  final int score;
}
