import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
   String? uid;
   DatabaseService({this.uid});
   
   final farmerDB=FirebaseFirestore.instance.collection("Farmers");

   Future<void> addFarmer(Map<String,dynamic> map)async{
      try {
         uid != null ?
         await farmerDB.doc(uid!).collection("questions").doc("answers").set(map)
             : throw Exception();
         log("data saved");
      }catch (e){
         log(e.toString());
      }
   }
   Future<Object?> getFarmeranswers()async{
      DocumentSnapshot snapshot=await farmerDB.doc(uid!).collection("questions").doc("answers").get();
      return snapshot.data();
   }
   Future<void> addFarm(String name,Map<String,dynamic> map)async{
      try{
         if (uid!=null){
            await farmerDB.doc(uid!).collection("farms").doc(name).set(map);
         }else{
            throw Exception();
         }

      }catch(e){
         log(e.toString());
      }
   }
   Future<List<dynamic>> getFarms()async{
      QuerySnapshot querySnapshot=await farmerDB.doc(uid!).collection("farms").get();
      return querySnapshot.docs.map((doc)=>doc.id).toList();
   }
   Future<Object?> getAfarm(String name)async{
      DocumentSnapshot snapshot=await farmerDB.doc(uid!).collection("farms").doc(name).get();
      return snapshot.data();
   }
}