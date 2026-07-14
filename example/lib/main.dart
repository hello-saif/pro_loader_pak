import 'package:flutter/material.dart';
import 'package:pro_loader/pro_loader.dart';
// ignore: implementation_imports
import 'package:pro_loader/src/enum/pro_loader_type.dart';
void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pro Loader Example',
      home: const LoaderGalleryPage(),
    );
  }
}

class LoaderGalleryPage extends StatelessWidget {
  const LoaderGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pro Loader Example")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ProLoaderType.values.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          final loader = ProLoaderType.values[index];

          return Column(
            children: [
              Expanded(
                child: Center(child: ProLoader(type: loader, size: 40)),
              ),
              Text(
                loader.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          );
        },
      ),
    );
  }
}
