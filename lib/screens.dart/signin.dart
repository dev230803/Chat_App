import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:my_chat/screens.dart/forgot_password.dart';
import 'package:my_chat/screens.dart/home.dart';
import 'package:my_chat/screens.dart/signup.dart';
import 'package:my_chat/services/database.dart';
import 'package:my_chat/services/shared_preference.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email = "", password = "",name="",username="",pic="",id="";
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  signin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    
    QuerySnapshot querySnapshot= await DatabaseOperations().getUserbyemail(email);
    name="${querySnapshot.docs[0]["Name"]}";
    username="${querySnapshot.docs[0]["UserName"]}";
    pic="${querySnapshot.docs[0]["Photo"]}";
    id=querySnapshot.docs[0].id;

    await SharedPReferenceData().saveUserName(name);
    await SharedPReferenceData().saveUserDisplayName(username);
    await SharedPReferenceData().saveUserId(id);
    await SharedPReferenceData().saveUserPic(pic);
   
     FocusScope.of(context).unfocus();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code =='auth/invalid-email') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Email not found!')));
      } else if (e.code == 'auth/wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Wrong Password")));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Either Password or Email is wrong')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: size.height / 3,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 57, 1, 66),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(size.width, 105.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.1),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Sign In',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 24),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Login To Your Account',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      height: size.height / 1.8,
                      width: size.width / 1.1,
                      child: Card(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 25, left: 15, right: 15),
                          child: Form(
                            key: _formKey,
                            child: ListView(
                              children: [
                                const Text(
                                  'Email',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: mailController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter Email";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Email',
                                    prefixIcon: Icon(
                                      Icons.mail_outline_rounded,
                                      color: Colors.purple,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(19),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  'Password',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter Password";
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Password',
                                    prefixIcon: Icon(
                                      Icons.password,
                                      color: Colors.purple,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(19),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child:  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                                        return const ForgotPassword();
                                      }));
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style:
                                          TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 61, 1, 71)),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          email = mailController.text;
                                          password = passwordController.text;
                                        });
                                      }
                                      signin();
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      child: Text('Sign In',style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()));
                          },
                          child: const Text(
                            'Sign Up Now!',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 88, 8, 102)),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
