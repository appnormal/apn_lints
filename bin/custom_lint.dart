// This is the entrypoint of our custom linter
import 'dart:isolate';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:apn_lints/lints/layer_check_lint.dart';
import 'package:apn_lints/lints/only_use_l10n_in_ui.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

void main(List<String> args, SendPort sendPort) {
  startPlugin(sendPort, _ApnLintsPlugin());
}

class _ApnLintsPlugin extends PluginBase {
  @override
  Stream<Lint> getLints(ResolvedUnitResult unit) async* {
    yield* LayerCheckLint().getLints(unit);
    yield* OnlyUseL10nInUiLint().getLints(unit);
  }
}
