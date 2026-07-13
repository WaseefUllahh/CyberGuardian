
import 'dart:io';

void main() {
  final logFile = File(r'C:\\Users\wajer danger\.gemini\antigravity-ide\brain\ec58c72c-7475-4d27-b76c-b2b94911f478\.system_generated\tasks\task-724.log');
  final logContent = logFile.readAsStringSync();
  
  final regex = RegExp(r'Invalid constant value - (.*?):(\d+):(\d+)');
  final matches = regex.allMatches(logContent);
  
  final fileLines = <String, List<int>>{};
  
  for (final match in matches) {
    final file = match.group(1)!;
    final line = int.parse(match.group(2)!) - 1;
    fileLines.putIfAbsent(file, () => []).add(line);
  }
  
  for (final file in fileLines.keys) {
    final f = File(file);
    if (!f.existsSync()) continue;
    
    final lines = f.readAsLinesSync();
    var changed = false;
    for (final line in fileLines[file]!) {
      if (line >= 0 && line < lines.length) {
        for (var i = line; i >= 0 && i >= line - 5; i--) {
          if (lines[i].contains('const ')) {
            lines[i] = lines[i].replaceFirst('const ', '');
            changed = true;
            break;
          }
        }
      }
    }
    if (changed) {
      f.writeAsStringSync(lines.join('\n'));
      stdout.writeln('Fixed $file');
    }
  }
}

