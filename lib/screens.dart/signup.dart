import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/screens.dart/home.dart';
import 'package:my_chat/screens.dart/signin.dart';
import 'package:my_chat/services/database.dart';
import 'package:my_chat/services/shared_preference.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name = "", email = "", password = "", confirmpassword = "";
  TextEditingController MailController = TextEditingController();
  TextEditingController NameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  registration() async {
    if (password != "" && password == confirmpassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String Id=randomAlphaNumeric(10);
        String user=MailController.text.replaceAll("@gmail.com", "");
        String updatedusername=user.replaceFirst(user[0], user[0].toUpperCase());
        String firstletter=user.substring(0,1).toUpperCase();
        Map<String,dynamic>userInfoMap={
          "Name":NameController.text,
          "Email":MailController.text,
          "UserName":updatedusername.toUpperCase(),
          "SearchKey":firstletter,
          "Photo":"https://firebasestorage.googleapis.com/v0/b/barberapp-ebcc1.appspot.com/o/icon1.png?alt=media&token=0fad24a5-a01b-4d67-b4a0-676fbc75b34a",
          "Id":Id,
     
        };
        await DatabaseOperations().addData(userInfoMap, Id);
        await SharedPReferenceData().saveUserId(Id);
        await SharedPReferenceData().saveUserEmail(MailController.text);
        await SharedPReferenceData().saveUserName(MailController.text.replaceAll("@gmail.com", "").toUpperCase());
        await SharedPReferenceData().saveUserPic("https://firebasestorage.googleapis.com/v0/b/barberapp-ebcc1.appspot.com/o/icon1.png?alt=media&token=0fad24a5-a01b-4d67-b4a0-676fbc75b34a");
        await SharedPReferenceData().saveUserDisplayName(NameController.text);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Succesful')));
          Navigator.pushReplacement( context,MaterialPageRoute(builder: (context)=> const HomeScreen()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please provide a strong password!')));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email already exsits')));
        }
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 24),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Create a new Account',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: SizedBox(
                        height: size.height / 1.42,
                        width: size.width / 1.1,
                        child: Card(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 10, left: 15, right: 15),
                            child: ListView(
                              children: [
                                const Text(
                                  'Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: NameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Name';
                                    }
                                    return null;
                                  },
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Name',
                                    prefixIcon: Icon(
                                      Icons.person,
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
                                  controller: MailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Email';
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
                                  controller: PasswordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Password';
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
                                  height: 15,
                                ),
                                const Text(
                                  'Confirm Password',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: ConfirmPasswordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Password to Confirm ';
                                    }
                                    if (value != PasswordController.text) {
                                      return 'Password didn\'t Match';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Re-Enter Password',
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
                                  height: 40,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ElevatedButton(
                                    
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 61, 1, 71)),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          email = MailController.text;
                                          password = PasswordController.text;
                                          confirmpassword =
                                              ConfirmPasswordController.text;
                                          name = NameController.text;
                                        });

                                      }
                                      registration();
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      child: Text('Sign Up',style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                ),
                              ],
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
                          'Already have an account?',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignIn()));
                          },
                          child: const Text(
                            'Sign In!',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 88, 8, 102)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
