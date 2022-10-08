import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyFilmList extends StatelessWidget {
  final _firabase = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference _moviews = _firabase.collection("movies");
   /* DocumentReference _film = _moviews.doc("Esaretin Bedeli");
    void myFunc() async {
      // docs
      *//* DocumentSnapshot _respondse =await _film.get();
                    Map<String,dynamic> _veri=_respondse.data();
                    print(_veri["name"]);*//*

      //Collection
      QuerySnapshot _respondse = await _moviews.get();
      List<QueryDocumentSnapshot> _veri = _respondse.docs;
      for (var i = 0; i < _veri.length; i++) {
        Map<String, dynamic> _veri1 = _veri[i].data();
        print("${_veri1["name"]}   ${_veri[i].id}");
      }
    }*/

    return StreamBuilder<QuerySnapshot>(
        stream: _moviews.snapshots(),
        builder: (context,snapshot){
         if(snapshot.hasError){
           return Center(child: Text("Not Conneted Internet!"));
         }
         else if(snapshot.hasData){
           QuerySnapshot _QS=snapshot.data;
           List<QueryDocumentSnapshot> _QDS=_QS.docs;

           return   Flexible(
             child: ListView.builder(
                 itemCount: _QDS.length??0,
                 itemBuilder: (context, index) {
                  Map<String,dynamic> _map=_QDS[index].data();
                   return Card(
                     child: ListTile(
                       leading: Container(
                           width:60,child: Text("${_map["name"]}",textAlign: TextAlign.center,)),
                       title: Center(child: Text("${_map["year"]}")),
                       trailing: Row(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           Text("${_map["reting"]}"),
                           Icon(
                             Icons.star_border,
                             color: Colors.orange,
                           ),
                         ],
                       ),
                       //  onTap: myFunc,
                     ),
                   );
                 }),
           );
         }
         else{return Center(child: CircularProgressIndicator(),);}
        }
    );
  }
}
