import 'dart:convert';

import 'package:patterns_codelab/functions.dart';

const documentJson = '''
{
  "metadata": {
    "title": "My Document",
    "modified": "2023-05-10"
  },
  "blocks": [
    {
      "type": "h1",
      "text": "Chapter 1"
    },
    {
      "type": "p",
      "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
    {
      "type": "checkbox",
      "checked": true,
      "text": "Learn Dart 3"
    }
  ]
}
''';

class Document {
  final Map<String, dynamic> _json;

  Document() : _json = jsonDecode(documentJson);

  (String, {DateTime modified}) getMetaData() {
    if (_json case {
      'metadata': {'title': String title, 'modified': String modified},
    }) {
      return (title, modified: DateTime.parse(modified));
    } else {
      throw FormatException();
    }
  }

  List<Block> getBlocks() {
    if (_json case {'blocks': List blocksJson}) {
      return [for (var block in blocksJson) Block.fromJson(block)];
    } else {
      printLog('IS NOT LIST ... ');
      return [];
    }
  }
}

sealed class Block {
  Block();

  factory Block.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'type': 'h1', 'text': final text} => HeaderBlock(text),
      {'type': 'p', 'text': final text} => BodyBlock(text),
      {'type': 'checkbox', 'text': final text, 'checked': bool checked} =>
        CheckedBlock(text, checked),
      _ => throw FormatException('Not match type'),
    };
  }
}

class HeaderBlock extends Block {
  final String text;

  HeaderBlock(this.text);
}

class BodyBlock extends Block {
  final String text;

  BodyBlock(this.text);
}

class CheckedBlock extends Block {
  final String text;
  final bool isChecked;

  CheckedBlock(this.text, this.isChecked);
}
