import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

enum ASW { Terrible, Bad, Soso, Good, Excellent }

enum ASW2 { Terrible, Bad, Soso, Good, Excellent }

enum ASW3 { Terrible, Bad, Soso, Good, Excellent }

enum ASW4 { Terrible, Bad, Soso, Good, Excellent }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ASW? _character;
  ASW2? _character2;
  ASW3? _character3;
  ASW4? _character4;
  int value1 = 0; //문항 1 답변 값 Int
  int value2 = 0; //문항 2 답변 값 Int
  int value3 = 0; //문항 3 답변 값 Int
  int value4 = 0; //문항 4 답변 값 Int
  int submitvalue = 0; //전체 문항 답변 값의 합 Int

  int number = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      number = (prefs.getInt('counter') ?? 0);
    });
  }

  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      number = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', number);
    });
  }

  // ignore: non_constant_identifier_names
  Future<void> _number_to_zero() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      number = 0;
      prefs.setInt('counter', number);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Daily Survey"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "1.  오늘 당신의 기분은 어떠셨나요?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: "NewFont",
                  ),
                ),
                Answer('Terrible', ASW.Terrible),
                Answer('Bad', ASW.Bad),
                Answer('Soso', ASW.Soso),
                Answer('Good', ASW.Good),
                Answer('Excellent', ASW.Excellent),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "2.  오늘 당신의 건강 상태는 어떤가요?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: "NewFont",
                  ),
                ),
                Answer2('Terrible', ASW2.Terrible),
                Answer2('Bad', ASW2.Bad),
                Answer2('Soso', ASW2.Soso),
                Answer2('Good', ASW2.Good),
                Answer2('Excellent', ASW2.Excellent),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "3.  오늘 당신의 라인전은 어떤가요?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: "NewFont",
                  ),
                ),
                Answer3('Terrible', ASW3.Terrible),
                Answer3('Bad', ASW3.Bad),
                Answer3('Soso', ASW3.Soso),
                Answer3('Good', ASW3.Good),
                Answer3('Excellent', ASW3.Excellent),
                const Text(
                  "4.  오늘 먹은 햄버거의 맛은?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: "NewFont",
                  ),
                ),
                Answer4('Terrible', ASW4.Terrible),
                Answer4('Bad', ASW4.Bad),
                Answer4('Soso', ASW4.Soso),
                Answer4('Good', ASW4.Good),
                Answer4('Excellent', ASW4.Excellent),
                const SizedBox(
                  height: 40,
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    submitvalue = value1 + value2 + value3 + value4;
                    _incrementCounter();
                    addData();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Submit"),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    clearall();
                    _number_to_zero();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("clearall"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addData() {
    // 데이터 추가
    final userCollectionReference = FirebaseFirestore.instance
        .collection("Counter Number") //colleection 이름
        .doc('$number'); //문서 ID
    userCollectionReference.set({
      "total": submitvalue,
      'time': DateFormat.MMMd().format(DateTime.now())
    });
  }

  void clearall() {
    // 데이터 전부 삭제
    for (int i = 0; i < number; i++) {
      final userCollectionReference =
          FirebaseFirestore.instance.collection("Counter Number").doc("$i");
      userCollectionReference.delete();
    }
  }

  // ignore: non_constant_identifier_names
  ListTile Answer4(String text, ASW4 asw) {
    return ListTile(
      title: Text(text),
      leading: Radio<ASW4>(
        value: asw,
        groupValue: _character4,
        onChanged: (ASW4? value) {
          setState(() {
            _character4 = value;
            if (_character4 == ASW4.Terrible) {
              value4 = 0;
            } else if (_character4 == ASW4.Bad) {
              value4 = 1;
            } else if (_character4 == ASW4.Soso) {
              value4 = 2;
            } else if (_character4 == ASW4.Good) {
              value4 = 3;
            } else if (_character4 == ASW4.Excellent) {
              value4 = 4;
            }
          });
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names
  ListTile Answer3(String text, ASW3 asw) {
    return ListTile(
      title: Text(text),
      leading: Radio<ASW3>(
        value: asw,
        groupValue: _character3,
        onChanged: (ASW3? value) {
          setState(() {
            _character3 = value;
            if (_character3 == ASW3.Terrible) {
              value3 = 0;
            } else if (_character3 == ASW3.Bad) {
              value3 = 1;
            } else if (_character3 == ASW3.Soso) {
              value3 = 2;
            } else if (_character3 == ASW3.Good) {
              value3 = 3;
            } else if (_character3 == ASW3.Excellent) {
              value3 = 4;
            }
          });
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names
  ListTile Answer2(String text, ASW2 asw) {
    return ListTile(
      title: Text(text),
      leading: Radio<ASW2>(
        value: asw,
        groupValue: _character2,
        onChanged: (ASW2? value) {
          setState(() {
            _character2 = value;
            if (_character2 == ASW2.Terrible) {
              value2 = 0;
            } else if (_character2 == ASW2.Bad) {
              value2 = 1;
            } else if (_character2 == ASW2.Soso) {
              value2 = 2;
            } else if (_character2 == ASW2.Good) {
              value2 = 3;
            } else if (_character2 == ASW2.Excellent) {
              value2 = 4;
            }
          });
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names
  ListTile Answer(String text, ASW asw) {
    return ListTile(
      title: Text(text),
      leading: Radio<ASW>(
        value: asw,
        groupValue: _character,
        onChanged: (ASW? value) {
          setState(() {
            _character = value;
            if (_character == ASW.Terrible) {
              value1 = 0;
            } else if (_character == ASW.Bad) {
              value1 = 1;
            } else if (_character == ASW.Soso) {
              value1 = 2;
            } else if (_character == ASW.Good) {
              value1 = 3;
            } else if (_character == ASW.Excellent) {
              value1 = 4;
            }
          });
        },
      ),
    );
  }
}
