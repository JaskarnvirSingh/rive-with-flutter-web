import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'Rive Animation',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Artboard? _riveArtboard;
  SMITrigger? _clickTrigger;
  StateMachineController? _controller;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  Future<void> _loadRiveFile() async {
    await RiveFile.initialize();
    final data = await rootBundle.load('miss_u_optimized.riv');
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;

    _controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    if (_controller != null) {
      artboard.addController(_controller!);
      _clickTrigger =
          _controller!.findInput<bool>('click_trigger') as SMITrigger?;
    }
    setState(() => _riveArtboard = artboard);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rive Emoji'), // More descriptive title
        centerTitle: true,
      ),
      body: _riveArtboard == null
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () {
                if (_clickTrigger != null) {
                  _clickTrigger!.fire();
                }
              },
              child: Rive(artboard: _riveArtboard!),
            ),
    );
  }
}
