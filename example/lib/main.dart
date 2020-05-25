import 'package:flutter/material.dart';
import 'package:matrix_rotate_arbitrary_axis/matrix_rotate_arbitrary_axis.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'matrix_rotate_arbitrary_axis'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    animationController.forward();
    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
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
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                final angleTween = Tween<double>(begin: 0.0, end: 3.14)
                    .animate(animationController);
                return Transform(
                  transform: RotationMatrix(0, 0, 0, 1, 1, 1, angleTween.value)
                      .getMatrix(),
                  child: Container(
                    color: Colors.blue,
                    width: 300,
                    height: 300,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
