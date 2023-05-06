import 'package:diagram/complex_example/complex_editor.dart';
import 'package:diagram/grid_example/grid_editor.dart';
import 'package:diagram/hierarchical_example/hierarchical_editor.dart';
import 'package:diagram/ports_example/ports_editor.dart';
import 'package:diagram/pub_example/pub_editor.dart';
import 'package:diagram/simple_diagram_editor/editor.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

// q` MyApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showPerformanceOverlay: !kIsWeb,
      showPerformanceOverlay: false,
      title: 'Diagram editor',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/editor': (context) => const SimpleDemo(),
        '/hierarchical': (context) => const HierarchicalDemo(),
        '/complex': (context) => const ComplexDiagramEditor(),
        '/grid': (context) => const GridDiagramEditor(),
        '/pub_example': (context) => const PubDiagramEditor(),
        '/ports': (context) => const PortsDiagramEditor(),
      },
    );
  }
}

// q` HomeScreen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: const Text('Editor'),
                onPressed: () {
                  Navigator.pushNamed(context, '/editor');
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: const Text('Core'),
                onPressed: () {
                  Navigator.pushNamed(context, '/pub_example');
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: const Text('Port'),
                onPressed: () {
                  Navigator.pushNamed(context, '/ports');
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: const Text('Hierarchical'),
                onPressed: () {
                  Navigator.pushNamed(context, '/hierarchical');
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: const Text('Widget'),
                onPressed: () {
                  Navigator.pushNamed(context, '/complex');
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: const Text('Snap'),
                onPressed: () {
                  Navigator.pushNamed(context, '/grid');
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: const Text('library GitHub'),
                onPressed: () {
                  _launchURL('https://github.com/Arokip/fdl');
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: const Text('library'),
                onPressed: () {
                  _launchURL('https://pub.dev/packages/diagram_editor');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// q` SimpleDemo
class SimpleDemo extends StatelessWidget {
  const SimpleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: SimpleDemoEditor(),
      ),
    );
  }
}

// class PubDemo extends StatelessWidget {
//   const PubDemo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: PubDiagramEditor(),
//       ),
//     );
//   }
// }

// class PortDemo extends StatelessWidget {
//   const PortDemo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: PortsDiagramEditor(),
//       ),
//     );
//   }
// }

// q` HierarchicalDemo
class HierarchicalDemo extends StatelessWidget {
  const HierarchicalDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: HierarchicalDiagramEditor(),
      ),
    );
  }
}

// class ComplexDemo extends StatelessWidget {
//   const ComplexDemo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: ComplexDiagramEditor(),
//       ),
//     );
//   }
// }

// class GridDemo extends StatelessWidget {
//   const GridDemo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: GridDiagramEditor(),
//       ),
//     );
//   }
// }
