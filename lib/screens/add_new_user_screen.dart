import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';

class AddNewUserScreen extends StatefulWidget {
  final User? user;
  const AddNewUserScreen({Key? key, this.user}) : super(key: key);

  @override
  State<AddNewUserScreen> createState() => _AddNewUserScreenState();
}

class _AddNewUserScreenState extends State<AddNewUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool isLoading = false;

  sendUserOnFirebase() async {
    setState(() {
      isLoading = true;
    });
    final response = await FirebaseFirestore.instance.collection("users").add({
      "name": usernameController.text,
      "email": emailController.text,
      "phone_number": phoneNumberController.text,
    });
    usernameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    setState(() {
      isLoading = false;
    });
    print(response.id);
  }

  updateUser() async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user!.docId)
          .update({
        "name": usernameController.text,
        "email": emailController.text,
        "phone_number": phoneNumberController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data updated successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    if (widget.user != null) {
      usernameController = TextEditingController(text: widget.user!.userName);
      emailController = TextEditingController(text: widget.user!.email);
      phoneNumberController =
          TextEditingController(text: widget.user!.phoneNumber);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new user"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextFormField(
                controller: usernameController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Username",
                  hintText: "Username",
                  prefixIcon: const Icon(Icons.person),
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  } else if (!emailRegExp.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                cursorColor: Colors.black,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Email",
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: phoneNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  } else if (value.length < 10) {
                    return 'Please enter valid phone number';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Phone Number",
                  hintText: "Phone Number",
                  prefixIcon: const Icon(Icons.phone),
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : MaterialButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.user != null) {
                            print("edit user");
                            updateUser();
                          } else {
                            sendUserOnFirebase();
                          }
                        } else {}
                      },
                      color: Colors.red,
                      child: Text(
                        widget.user != null ? "Edit user" : "Add user",
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
