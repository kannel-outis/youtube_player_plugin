import 'package:flutter/material.dart';
import 'testing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TestingPage());
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const _HomeClass(),
          ),
        ),
      ),
    );
  }
}

class _HomeClass extends StatefulWidget {
  const _HomeClass({Key? key}) : super(key: key);

  @override
  __HomeClassState createState() => __HomeClassState();
}

class __HomeClassState extends State<_HomeClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Emir dilony"),
        ],
      ),
    );
  }
}
