import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jerseyhub/features/splash/data/repository/view_model/splash_view_model.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
   WidgetsBinding.instance.addPostFrameCallback((_){
     context.read<SplashViewmodel>().init(context);

   });
   return Scaffold(
     body: Stack(
       children: [
         Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               SizedBox(
                 height: 200,
                 width: 200,
                 child: Image.asset('assets/images/logo.png'),
               ),
               const SizedBox(height: 10),
               const CircularProgressIndicator(),
               const SizedBox(height: 10),
               const Text('version:1.0.0'),
             ],
           ),
         )
       ],
     )
   );
  }
}
