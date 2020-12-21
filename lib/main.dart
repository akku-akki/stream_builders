import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Bloc bloc;

  @override
  void initState() {
    bloc = Bloc();
    super.initState();
  }

  @override
  void dispose() {
    bloc.closeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streams'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutputDIsplay(
              stream: bloc.valueStream,
            ),
            const SizedBox(
              height: 100,
            ),
            Wrap(
              spacing: 10,
              children: [
                RaisedButton(
                  onPressed: bloc.incrementValue,
                  child: Text('Increment'),
                ),
                RaisedButton(
                  onPressed: bloc.decrementValue,
                  child: Text('Decrement'),
                ),
                RaisedButton(
                  onPressed: bloc.incrementValueBy10,
                  child: Text('+10'),
                ),
                RaisedButton(
                  onPressed: bloc.decrementValueBy10,
                  child: Text('-10'),
                ),
                RaisedButton(
                  onPressed: bloc.addErrorToStream,
                  child: Text('Add Error'),
                ),
                RaisedButton(
                  onPressed: bloc.addString,
                  child: Text('Add String'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class OutputDIsplay extends StatelessWidget {
  const OutputDIsplay({
    Key key,
    this.stream,
  }) : super(key: key);

  final Stream stream;

  @override
  Widget build(BuildContext context) {
    print("I am Child Rebuilding ");
    final style = const TextStyle(
        backgroundColor: Colors.red, color: Colors.yellow, fontSize: 50);
    final style2 = const TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        backgroundColor: Colors.green,
        letterSpacing: 2.0);
    return StreamBuilder<dynamic>(
        initialData: "Getting Started",
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text(snapshot.error, style: style);
          if (snapshot.data == null)
            return Text(
              "Null",
              style: style,
            );
          if (snapshot.hasData) return Text("${snapshot.data}", style: style2);
          return Text("Something went wrong", style: style);
        });
  }
}

class Bloc {
  final _controller = StreamController<dynamic>.broadcast();

  int value = 0;

  Stream<dynamic> get valueStream => _controller.stream;

  Function(dynamic) get addEvent => _controller.add;

  void incrementValue() {
    value = value + 1;
    addEvent(value);
  }

  void decrementValue() {
    value = value - 1;
    addEvent(value);
  }

  void incrementValueBy10() {
    value = value + 10;
    addEvent(value);
  }

  void decrementValueBy10() {
    value = value - 10;
    addEvent(value);
  }

  void addErrorToStream() {
    _controller.addError("Streaming error");
  }

  void addString() {
    _controller.add("HELLO WORLD");
  }

  void closeStream() {
    _controller.close();
  }
}