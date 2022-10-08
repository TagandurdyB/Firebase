import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/DeletePage.dart';
import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("My Firebase App"),
        centerTitle: true,
        brightness: Brightness.dark,
        shadowColor: Colors.blue,
        elevation: 15,
        actions: [
          IconButton(onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          }, icon: Icon(Icons.home)),
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>DeletePage()));
          }, icon: Icon(Icons.delete)),

        ],
      ),
      body: EditBody(),
    );
  }
}

class EditBody extends StatelessWidget {
  final _firestore=FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference _movies= _firestore.collection("movies");


    return StreamBuilder(
        stream: _movies.snapshots(),
        builder: (context,assincSS){
          if(assincSS.hasError){
            return Center(child: Text("Not Connected Internet!"),);
          }
          else if(assincSS.hasData){
            QuerySnapshot _QS=assincSS.data;
            List<QueryDocumentSnapshot> _QDS=_QS.docs;

            return  Container(
              alignment: Alignment.center,
              child: ListView.builder(
                  itemCount: _QDS.length??0,
                  itemBuilder: (context, index) {
                    Map<String,dynamic> _map=_QDS[index].data();
                    return Card(
                      child: ListTile(
                        leading: Container(
                          width: 60,
                          child: Text("${_map["name"]}"),
                        ),
                        title: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${_map["year"]}   "),
                              //  SizedBox(width: 5,),
                              Text("${_map["reting"]}"),
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }
          else{return Center(child: CircularProgressIndicator());}
        });
  }
}
