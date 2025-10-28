import 'dart:io';

/// ⚡ يزيل كل التعليقات من ملفات .dart (// أو /* */)
void main() async {
  final dir = Directory('lib');

  if (!dir.existsSync()) {
    print('❌ لم يتم العثور على مجلد lib/');
    return;
  }

  final dartFiles = dir
      .listSync(recursive: true)
      .where((f) => f is File && f.path.endsWith('.dart'))
      .cast<File>();

  final commentRegex = RegExp(
    r'(\/\/[^\n]*|\/\*[\s\S]*?\*\/)',
    multiLine: true,
  );

  int modified = 0;

  for (final file in dartFiles) {
    final content = await file.readAsString();
    final cleaned = content.replaceAll(commentRegex, '').trimRight();

    if (content != cleaned) {
      await file.writeAsString('$cleaned\n');
      modified++;
      print('🧹 Cleaned: ${file.path}');
    }
  }

  print('\n✅ تمت إزالة التعليقات من $modified ملف Dart.');
}
