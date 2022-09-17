import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming_alexbordei_dev/providers/authentication_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    context.read<AuthenticationProvider>().checkIfUserAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = context.watch<AuthenticationProvider>().isLoading;
    bool isUserAuthenticated =
        context.read<AuthenticationProvider>().isUserAuthenticated;

    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: isLoading ? 0.0 : 1.0,
          duration: const Duration(seconds: 2),
          child: FlutterLogo(
            size: MediaQuery.of(context).size.width,
          ),
          onEnd: () {
            if (isUserAuthenticated == true) {
              Navigator.popAndPushNamed(context, '/dashboard');
            } else {
              Navigator.popAndPushNamed(context, '/login');
            }
          },
        ),
      ),
    );
  }
}
