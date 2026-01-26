import 'package:flutter/material.dart';
import 'package:patterns_codelab/functions.dart';

import 'data.dart';

void main() {
  runApp(const DocumentApp());
}

class DocumentApp extends StatelessWidget {
  const DocumentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: DocumentScreen(document: Document()),
    );
  }
}

class DocumentScreen extends StatelessWidget {
  final Document document;

  const DocumentScreen({required this.document, super.key});

  @override
  Widget build(BuildContext context) {
    final (title, :modified) = document.getMetaData();

    final getBlocks = document.getBlocks();
    final formattedModifiedDate = formatDate(modified);

    return Scaffold(
      appBar: AppBar(title: Text('Title goes here $title')),
      body: Column(
        mainAxisAlignment: .center,
        children: [
          Text('Last modified $formattedModifiedDate'),
          Expanded(
            child: ListView.builder(
              itemCount: document.getBlocks().length,
              itemBuilder: (context, index) => BlockWidget(block: getBlocks[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class BlockWidget extends StatelessWidget {
  final Block block;

  const BlockWidget({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    return switch (block) {
      HeaderBlock(:var text) => Text(
        text,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      BodyBlock(:var text) => Text(text),
      CheckedBlock(:var text, :var isChecked) => Row(
        children: [
          Text(text, style: Theme.of(context).textTheme.headlineLarge),
          Checkbox(value: isChecked, onChanged: (value) {}),
        ],
      ),
    };
  }
}
