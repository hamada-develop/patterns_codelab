# patterns_codelab

مشروع Flutter بسيط للتدريب على **Dart 3 Patterns & Records** باستخدام الـ codelab الرسمي من Google:

**Dive into Dart's patterns and records**
[https://codelabs.developers.google.com/codelabs/dart-patterns-records#3](https://codelabs.developers.google.com/codelabs/dart-patterns-records#3)

---

## ✅ ماذا تعلمت؟ (مع أمثلة من نفس المشروع)

### 1) Records (إرجاع أكثر من قيمة)

بدل ما أعمل `class` مخصوص للـ metadata، رجّعتها كـ **record**:

```dart
(String, {DateTime modified}) get metadata {
  return ('My Document', modified: DateTime.now());
}
```

---

### 2) Destructuring للـ Records (تفكيك الـ record لمتغيرات)

فكّيت الـ record لمتغيرات في سطر واحد:

```dart
final (title, :modified) = document.metadata;
```

وبعدين استخدمت القيم مباشرة في الـ UI:

```dart
Text(title);
Text('Last modified: $modified');
```

---

### 3) قراءة JSON بأمان باستخدام `if-case` + map patterns

بدل ما أكتب `if` كثيرة و `as` casts، استخدمت patterns للتحقق واستخراج القيم:

```dart
(String, {DateTime modified}) get metadata {
  if (_json case {
    'metadata': {'title': String title, 'modified': String modifiedString},
  }) {
    return (title, modified: DateTime.parse(modifiedString));
  }
  throw const FormatException('Unexpected JSON');
}
```

---

### 4) Map patterns تتجاهل الـ keys الزائدة

بعض الـ blocks في الـ JSON ممكن تحتوي على keys إضافية مثل `checked`،
لكن الـ map pattern يطابق فقط المفاتيح التي نحددها ويترك باقي البيانات:

```dart
factory Block.fromJson(Map<String, dynamic> json) {
  if (json case {'type': final type, 'text': final text}) {
    return Block(type, text);
  }
  throw const FormatException('Unexpected JSON format');
}
```

---

### 5) Switch statement باستخدام patterns

حددت تصميم النص حسب نوع البلوك:

```dart
switch (block.type) {
  case 'h1':
    textStyle = Theme.of(context).textTheme.displayMedium;
  case 'p' || 'checkbox':
    textStyle = Theme.of(context).textTheme.bodyMedium;
  case _:
    textStyle = Theme.of(context).textTheme.bodySmall;
}
```

---

### 6) Switch expression (إرجاع قيمة مباشرة)

نفس المنطق السابق ولكن بشكل أقصر وأنظف، لأن `switch` هنا يرجّع قيمة مباشرة:

```dart
final textStyle = switch (block.type) {
  'h1' => Theme.of(context).textTheme.displayMedium,
  'p' || 'checkbox' => Theme.of(context).textTheme.bodyMedium,
  _ => Theme.of(context).textTheme.bodySmall,
};
```

---

### 7) Object patterns (مطابقة خصائص داخل Object)

قمت بتنسيق تاريخ التعديل باستخدام `switch` على كائن من النوع `Duration`:

```dart
return switch (difference) {
  Duration(inDays: 0) => 'today',
  Duration(inDays: 1) => 'tomorrow',
  Duration(inDays: -1) => 'yesterday',
  Duration(inDays: final days, isNegative: true) => '${days.abs()} days ago',
  Duration(inDays: final days) => '$days days from now',
};
```

---

### 8) Guards (`when`) لإضافة شرط بعد المطابقة

أضفت حالات خاصة لعرض الأسابيع عندما يكون الفرق أكبر من 7 أيام:

```dart
return switch (difference) {
  Duration(inDays: final days) when days > 7 =>
    '${days ~/ 7} weeks from now',

  Duration(inDays: final days) when days < -7 =>
    '${days.abs() ~/ 7} weeks ago',

  Duration(inDays: final days, isNegative: true) =>
    '${days.abs()} days ago',

  Duration(inDays: final days) =>
    '$days days from now',
};
```

---

### 9) sealed classes + switch شامل (Exhaustive switch)

استخدمت `sealed` لكي يضمن Dart أن الـ `switch` يغطي كل أنواع الـ blocks بدون الحاجة لـ `default`.

**sealed superclass + factory parsing:**

```dart
sealed class Block {
  Block();

  factory Block.fromJson(Map<String, Object?> json) {
    return switch (json) {
      {'type': 'h1', 'text': String text} => HeaderBlock(text),
      {'type': 'p', 'text': String text} => ParagraphBlock(text),
      {'type': 'checkbox', 'text': String text, 'checked': bool checked} =>
        CheckboxBlock(text, checked),
      _ => throw const FormatException('Unexpected JSON format'),
    };
  }
}
```

**عرض الـ UI بشكل شامل باستخدام object patterns:**

```dart
child: switch (block) {
  HeaderBlock(:final text) => Text(
    text,
    style: Theme.of(context).textTheme.displayMedium,
  ),
  ParagraphBlock(:final text) => Text(text),
  CheckboxBlock(:final text, :final isChecked) => Row(
    children: [
      Checkbox(value: isChecked, onChanged: (_) {}),
      Text(text),
    ],
  ),
}
```

---
