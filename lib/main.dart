import 'package:flutter/material.dart';
import 'package:funcational_error_handeling/post_change_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => PostChangeNotifier(),
        child: const GetPostWidget(),
      ),
    );
  }
}

class GetPostWidget extends StatelessWidget {
  const GetPostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Functional error handling'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<PostChangeNotifier>(builder: (context, notifier, child) {
              if (notifier.state == NotifierState.initial) {
                return const StyleText(
                  title: 'Press the button 👇',
                );
              } else if (notifier.state == NotifierState.loading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else {
                return notifier.post.fold(
                  (failure) => StyleText(title: failure.message),
                  (post) => StyleText(title: post.toString()),
                );
              }
            }),
            TextButton(
              onPressed: () async {
                context.read<PostChangeNotifier>().getOnePost();
              },
              child: const Text('Get Post'),
            ),
          ],
        ),
      ),
    );
  }
}

class StyleText extends StatelessWidget {
  const StyleText({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 40),
      textAlign: TextAlign.center,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
