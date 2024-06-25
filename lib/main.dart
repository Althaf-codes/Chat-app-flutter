import 'package:chatappp_socketio/firebase_options.dart';
import 'package:chatappp_socketio/screens/Auth/toggle.dart';
import 'package:chatappp_socketio/screens/Home/home_screen.dart';
import 'package:chatappp_socketio/services/auth_service.dart';
import 'package:chatappp_socketio/services/chat_provider.dart';
import 'package:chatappp_socketio/services/message_info_provider.dart';
import 'package:chatappp_socketio/services/user_provider.dart';
import 'package:chatappp_socketio/utils/responsive_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => AuthMethods(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MessageInfoProvider()),
        // StreamProvider(
        //     create: (_) => context.watch<AuthMethods>().authState,
        //     initialData: null)
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 16, 105, 19)),
            useMaterial3: true,
          ),
          home: const AuthWrapper(),
        );
      }),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final firebaseAuth = Provider.of<AuthMethods>(context);
    return StreamBuilder<User?>(
      stream: firebaseAuth.authState,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            if (Responsive.isDesktop(context)) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    // height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.45,
                    color: const Color.fromARGB(255, 5, 128, 9),
                    child: Center(child: Toggle()),
                  ),
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(12.0),
                child: Center(child: Toggle()),
              );
            }
          }
          return HomeScreen();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      // final firebaseUser = context.watch<User?>();
    );

    // if (firebaseUser != null) {
    //   return const HomeScreen();
    // } else {
    //   return const Toggle();
    // }
  }
}
