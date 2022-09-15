import 'package:analyzer/dart/analysis/results.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class FileObject {
  FileObject(this.path);

  final String path;

  bool get isCore => path.contains('/lib/core/');
  bool get isData => path.contains('/lib/data/');
  bool get isDomain => path.contains('/lib/domain/');
  bool get isUI => path.contains('/lib/ui/');

  bool get shouldCheckLayerImports => isCore || isData || isDomain || isUI;

  String get libDir => path.substring(0, path.indexOf('/lib/'));
  String get relativePath => path.substring(path.indexOf('/lib/'));

  bool inSameLib(String path) {
    return path.startsWith(libDir);
  }
}

class ImportObject {
  final int offset;
  final int length;
  final String path;

  ImportObject(this.offset, this.length, this.path);

  bool get isData => path.contains('/lib/data/');
  bool get isUi => path.contains('/lib/ui/');
}

mixin LintContract {
  Stream<Lint> getLints(ResolvedUnitResult unit);

  String lintMessage(String key);

  Lint toLint(String key, LintLocation location,
      {LintSeverity severity = LintSeverity.error}) {
    return Lint(
      code: key,
      message: lintMessage(key),
      severity: severity,
      location: location,
    );
  }
}
