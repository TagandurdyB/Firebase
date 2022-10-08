import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'DeletePage.dart';
import 'EditPage.dart';
import 'FilmList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialializatoin = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: _initialializatoin,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("Not connection internet!");
                return Center(child: Text("Not connection internet!"));
              } else if (snapshot.hasData) {
                return MyHomePage(title: 'Flutter Demo Home Page');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<TextEditingController> controls = [];

class _MyHomePageState extends State<MyHomePage> {
  void _add() async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference testColRef = firestore.collection("movies");
 /*   testColRef.add({
      "name": "${controls[0].text}",
      "year": "${controls[1].text}",
      "reting": "${controls[2].text}"
    });*/
    await testColRef.doc("${controls[0].text}").set({
      "name": "${controls[0].text}",
      "year": "${controls[1].text}",
      "reting": "${controls[2].text}"
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("My Firebase App"),
        centerTitle: true,
        brightness: Brightness.dark,
        shadowColor: Colors.red,
        elevation: 15,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>EditPage()));
          }, icon: Icon(Icons.edit)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>DeletePage()));
          }, icon: Icon(Icons.delete)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _add,
      ),
      body: MyBody(),
    );
  }
}

class MyBody extends StatefulWidget {
  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyInput(
            index: 0,
            hidden: "Filmin ady...",
          ),
          MyInput(
            index: 1,
            hidden: "Year...",
          ),
          MyInput(
            index: 2,
            hidden: "Reiting...",
          ),
          //  ElevatedButton(onPressed:_add, child: Text("Goş")),
        MyFilmList()
        ],
      ),
    );
  }
}

class MyInput extends StatefulWidget {
  final int index;
  final String hidden;
  MyInput({this.index = 0, this.hidden = ""});
  @override
  _MyInputState createState() => _MyInputState();
}

class _MyInputState extends State<MyInput> {
  @override
  void initState() {
    if (controls.length < widget.index + 1) {
      controls.add(TextEditingController());
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: TextFormField(
          controller: controls[widget.index],
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              hintText: widget.hidden,
              suffix: GestureDetector(
                  onTap: () {
                    controls[widget.index].clear();
                  },
                  child: Icon(Icons.cancel))),
        ),
      ),
    );
  }
}


