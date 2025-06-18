
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jerseyhub/features/auth/presentation/view/login_screenview.dart';

class SplashViewmodel extends Cubit<void>{
  SplashViewmodel(): super(null);


  Future<void>init (BuildContext context)async{
    await  Future.delayed(const Duration(seconds: 3),()async{

      if(context.mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context)=> BlocProvider(
              create: (context)=>LoginViewModel(),
              child: LoginView(),
            ),
          ),
        );
      }
    });
  }
}