import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudfstore/model/user.dart';
import 'package:cloudfstore/screens/add_new_user_screen.dart';
import 'package:cloudfstore/widgets/uses_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore CRUD Operation"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddNewUserScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    User user = User(
                      docId: snapshot.data!.docs[index].id,
                      userName: snapshot.data!.docs[index]["name"],
                      email: snapshot.data!.docs[index]["email"],
                      phoneNumber: snapshot.data!.docs[index]["phone_number"],
                    );
                    return UserTile(user: user);
                  },
                  itemCount: snapshot.data!.docs.length,
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
