
import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (var file in files) {
    var content = file.readAsStringSync();
    var lines = content.split('\n');
    var changed = false;
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('AppColors') && lines[i].contains('const ')) {
        lines[i] = lines[i].replaceAll(RegExp(r'const\s+'), '');
        changed = true;
      }
    }
    if (changed) {
      file.writeAsStringSync(lines.join('\n'));
    }
  }
}

