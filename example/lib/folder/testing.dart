import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';

// class BaseClass extends StatefulWidget {
//   const BaseClass({ Key? key }) : super(key: key);

//   @override
//   _BaseClassState createState() => _BaseClassState();
// }

// class _BaseClassState extends State<BaseClass> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }

// abstract class BaseClass {
//   Widget toolBar(BuildContext context, YoutubePlayerController controller,
//       void Function() setState);
//   Widget controlBar(BuildContext context, YoutubePlayerController controller,
//       void Function() setState);
//   Widget progressBar(BuildContext context, YoutubePlayerController controller,
//       void Function() setState);
// }

// class Something extends BaseClass {
//   String something = "something";
//   @override
//   Widget controlBar(BuildContext context, YoutubePlayerController controller,
//       void Function() setState) {
//     return SizedBox(
//       child: Text(something),
//     );
//   }

//   @override
//   Widget progressBar(BuildContext context, YoutubePlayerController controller,
//       void Function() setState) {
//     // TODO: implement progressBar
//     return InkWell(
//       onTap: () {
//         something = "another thing";
//         setState();
//       },
//       child: const Center(
//         child: Text("change"),
//       ),
//     );
//   }

//   @override
//   Widget toolBar(BuildContext context, YoutubePlayerController controller,
//       void Function() setState) {
//     return Container();
//   }
// }

// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        baseClass: Something(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final BaseClass? baseClass;
  const MyHomePage({Key? key, required this.title, this.baseClass})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
  final YoutubePlayerController _controller = const YoutubePlayerController();

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

  void setS() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.baseClass!.toolBar(context, _controller, setS),
            widget.baseClass!.controlBar(context, _controller, setS),
            widget.baseClass!.progressBar(context, _controller, setS),
          ],
        ),
      ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
    );
  }
}

abstract class BaseClass {
  Widget toolBar(BuildContext context, YoutubePlayerController controller,
      void Function() setState);
  Widget controlBar(BuildContext context, YoutubePlayerController controller,
      void Function() setState);
  Widget progressBar(BuildContext context, YoutubePlayerController controller,
      void Function() setState);
}

class Something extends BaseClass {
  String something = "something";
  @override
  Widget controlBar(BuildContext context, YoutubePlayerController controller,
      void Function() setState) {
    return SizedBox(
      child: Text(something),
    );
  }

  @override
  Widget progressBar(BuildContext context, YoutubePlayerController controller,
      void Function() setState) {
    return InkWell(
      onTap: () {
        something = "another thing";
        setState();
      },
      child: const Center(
        child: Text("change"),
      ),
    );
  }

  @override
  Widget toolBar(BuildContext context, YoutubePlayerController controller,
      void Function() setState) {
    return Container();
  }
}

class YoutubePlayerController {
  const YoutubePlayerController();
  final String shit = "Shit";
}

mixin Set on State {
  void something() {}
}
