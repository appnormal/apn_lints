import 'package:analyzer/dart/analysis/results.dart';
import 'package:apn_lints/models.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class OnlyUseL10nInUiLint with LintContract {
  @override
  String lintMessage(String key) => 'Translations should only be known and used in the UI layer.';

  @override
  Stream<Lint> getLints(ResolvedUnitResult unit) async* {
    final fileObject = FileObject(unit.path);

    if (fileObject.isUI) {
      return;
    }

    final regex = RegExp(r'(L10n\.translate.+),');
    final matches = regex.allMatches(unit.content);

    for (var match in matches) {
      yield toLint(
        'only_use_l10n_in_ui_lint',
        unit.lintLocationFromOffset(match.start, length: match.end - match.start - 1),
        severity: LintSeverity.warning,
      );
    }
  }
}
