import 'package:flutter/material.dart';
import 'package:linkjo/config/routes.dart';
import 'package:linkjo/screen/chat_screen.dart';
import 'package:linkjo/screen/home_screen.dart';
import 'package:linkjo/screen/login_screen.dart';
import 'package:linkjo/screen/message_screen.dart';
import 'package:linkjo/screen/register_screen.dart';
import 'package:linkjo/screen/splash_screen.dart';
import 'package:linkjo/screen/vendor_screen.dart';

class LinkjoApp extends StatelessWidget {
  const LinkjoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linkjo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      initialRoute: Routes.splash,
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case Routes.splash:
            builder = (context) => const SplashScreen();
            break;
          case Routes.home:
            builder = (context) => const HomeScreen();
            break;
          case Routes.vendor:
            builder = (context) => const VendorScreen();
            break;
          case Routes.chat:
            builder = (context) => ChatScreen();
            break;
          case Routes.message:
            builder = (context) => MessageScreen();
            break;
          case Routes.login:
            builder = (context) => const LoginScreen();
            break;
          case Routes.register:
            builder = (context) => const RegisterScreen();
            break;
          default:
            throw Exception('Route tidak ditemukan: ${settings.name}');
        }

        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(
              curve: curve,
            ));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
