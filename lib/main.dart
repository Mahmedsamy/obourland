import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/dio_helper.dart';
import 'core/cache/cache_helper.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/report_repository.dart';
import 'presentation/bloc/auth_cubit.dart';
import 'presentation/bloc/report_cubit.dart';
import 'presentation/screens/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  DioHelper.init();


  final authRepo = AuthRepository();
  final reportRepo = ReportRepository();


  runApp(MyApp(authRepo: authRepo, reportRepo: reportRepo));
}


class MyApp extends StatelessWidget {
  final AuthRepository authRepo;
  final ReportRepository reportRepo;
  const MyApp({super.key, required this.authRepo, required this.reportRepo});


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(authRepo)),
        BlocProvider(create: (_) => ReportCubit(reportRepo)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: LoginScreen(),
      ),
    );
  }
}