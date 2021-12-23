import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recipe_app/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:recipe_app/blocs/recipe_detail_bloc/recipe_detail_bloc.dart';
import 'package:recipe_app/screens/home/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/env/.env_production");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider<RecipeBloc>(
          create: (context) => RecipeBloc(),
        ),
        BlocProvider<RecipeDetailBloc>(
          create: (context) => RecipeDetailBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Resep Masakan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                iconTheme: IconThemeData(color: Colors.black),
                actionsIconTheme: IconThemeData(color: Colors.black),
                elevation: 1)),
        home: const Dashboard(),
      ),
    );
  }
}
