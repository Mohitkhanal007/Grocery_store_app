
import 'package:flutter/material.dart';

class LoginScreenview extends StatelessWidget {
  const LoginScreenview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,),
      backgroundColor: Color(0xFFC8BC91),

      resizeToAvoidBottomInset: true, // Allows resizing when keyboard appears

      body: SingleChildScrollView( // <-- Wrap everything here
        child: Container(
          padding: EdgeInsets.only(bottom: 30), // Give some bottom padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container(height: 300, child: Image.asset('assets/images/login.png')),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.green),
                        ),
                        hintText: "Enter Email",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      obscureText: true, // Optional: hide password
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.green),
                        ),
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(Icons.password, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreenview()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Row(
                      children: [
                        Text(
                          "Don't Have An Account?",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 50,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.green,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Center(
                              child: Text(
                                'SignUp',
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
