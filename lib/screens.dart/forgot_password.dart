
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/screens.dart/signin.dart';
import 'package:my_chat/screens.dart/signup.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey=GlobalKey<FormState>();
  TextEditingController mailController=TextEditingController();
  String email="";
  
  resetPassword()async{
    try{
      
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
       FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password has been sent")));
    }on FirebaseAuthException catch(e){
      if(e.code=="user-not-found"){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User does not exist")));}
    }
  }
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
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
                    'Password Recovery',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 24),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Enter your mail',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      height: size.height / 2.1,
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
                                const SizedBox(
                                  height: 10,
                                ),
                                
                                const SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color.fromARGB(
                                                255, 61, 1, 71)),
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            setState(() {
                                              email = mailController.text;
                                              
                                            });
                                          }
                                          resetPassword();
                                          
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          child: Text('Send Password',style: TextStyle(color: Colors.white),),
                                        ),
                                      ),
                                      const SizedBox(height: 2,),
                                      TextButton(
                                        onPressed: (){
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => const SignIn())));
                                        },
                                         child: const Text("Sign In",style: TextStyle(fontSize: 16,decoration: TextDecoration.underline),))
                                    ],
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
                            Navigator.pushReplacement(
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
