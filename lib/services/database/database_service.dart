import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosine/services/database/models.dart';

class DatabaseService{
   String? uid;
   DatabaseService({this.uid});
   
   final farmerDB=FirebaseFirestore.instance.collection("Farmers");
   final postDB=FirebaseFirestore.instance.collection("posts");

   Future<void>addPost(String title,String content,DateTime postedOn,int likes)async{
      try{
         await postDB.doc().set({
            "title":title,
            "content":content,
            "owner":uid,
            "postedOn":postedOn,
            "likes":likes
         });
         log("post created successfully");
      }catch(e){
         log("Error in adding post");
      }
   }

   Stream<List<Post>> showPosts(){
      log("message");
      return postDB.snapshots().map((snapshot)=>snapshot.docs.map(
              (doc)=> Post(title: doc["title"],
          content: doc.get("content"),
              owner: doc.get("owner"),
              postedOn: (doc.get("postedOn") as Timestamp).toDate(),
              likes: doc.get("likes"))).toList()
      );
   }

   Future<void> addFarmer(Map<String,dynamic> map)async{
      try {
         uid != null ?
         await farmerDB.doc(uid).collection("questions").doc("answers").set(map)
             : throw Exception();
         log("data saved");
      }catch (e){
         log(e.toString());
      }
   }

   Stream<Map<String,dynamic>?> getFarmeranswers(){
      return farmerDB.doc(uid).collection("questions").doc("answers").snapshots().map((snap)=>snap.data());
   }

   Future<void> addFarm(String name,Map<String,dynamic> map)async{
      try{
         if (uid!=null){
            await farmerDB.doc(uid).collection("farms").doc(name).set(map);
         }else{
            throw Exception();
         }
      }catch(e){
         log(e.toString());
      }
   }

   Stream<List<dynamic>> getFarms(){
      return farmerDB.doc(uid).collection("farms").snapshots()
          .map((querySnapshot)=>querySnapshot.docs
          .map((doc)=>doc.id).toList());
   }

   Future<Object?> getAfarm(String name)async{
      DocumentSnapshot snapshot=await farmerDB.doc(uid).collection("farms").doc(name).get();
      return snapshot.data();
   }

   Future<void> deleteFarm(String name)async{
      try{
         await farmerDB.doc(uid).collection("farms").doc(name).delete();
      }catch(e){
         log("Cannot delete farm");
      }
   }

   Future<void> editFarm(String oldName,String newName,Map<String,dynamic> map)async{
      try{
         await deleteFarm(oldName);
         await addFarm(newName, map);
      }catch(e){
         log("Error while editing...");
      }
   }

   Future<void> addCrop(String farmName,String name,Map<String,dynamic> map)async{
      try{
         if(uid!=null){
            await farmerDB.doc(uid).collection("farms").doc(farmName).collection("crops").doc(name).set(map);
         }else throw Exception();
      }catch(e){
         log("Error adding CROP");
      }
   }

   Stream<List<dynamic>>getCrops(String farmName){
      return farmerDB.doc(uid).collection("farms").doc(farmName).collection("crops").snapshots().map((snap)=>snap.docs.map((doc)=>doc.id).toList());
   }

   Future<Object?>getAcrop(String farmName,String cropName)async{
      DocumentSnapshot documentSnapshot=await farmerDB.doc(uid).collection("farms").doc(farmName).collection("crops").doc(cropName).get();
      return documentSnapshot.data();
   }

   Future<void> deleteCrop(String farmName,String cropName)async{
      try{
         await farmerDB.doc(uid).collection("farms").doc(farmName).collection("crops").doc(cropName).delete();
      }catch(e){
         log("Cannot delete CROP");
      }
   }

   Future<void> editCrop(String farmName,String oldName,String newName,Map<String,dynamic> map)async{
      try{
         await deleteCrop(farmName,oldName);
         await addCrop(farmName,newName, map);
      }catch(e){
         log("Error while editing...");
      }
   }

}