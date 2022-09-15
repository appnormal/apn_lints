import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:apn_lints/models.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

final _lintMessages = {
  'dont_import_ui_files_in_data':
      'The DATA layer cannot be aware of any classes that live in UI. Refactor and use domain layer',
  'dont_import_data_files_in_ui':
      'The UI layer cannot be aware of any classes that live in data. Refactor and use domain layer',
};

class LayerCheckLint extends RecursiveAstVisitor<void> with LintContract {
  late FileObject fileObject;

  final imports = <ImportObject>[];

  Iterable<ImportObject> get dataOffenders => imports.where(_dataInUiLayer);
  Iterable<ImportObject> get uiOffenders => imports.where(_uiInDataLayer);

  bool _dataInUiLayer(ImportObject import) => import.isData && fileObject.isUI;
  bool _uiInDataLayer(ImportObject import) => import.isUi && fileObject.isData;

  @override
  void visitImportDirective(ImportDirective node) {
    super.visitImportDirective(node);
    final element = node.element2;

    final lib = element?.uri;
    if (lib is DirectiveUriWithLibrary) {
      if (fileObject.inSameLib(lib.source.toString())) {
        imports
            .add(ImportObject(node.offset, node.length, lib.source.toString()));
      }
    }
  }

  @override
  String lintMessage(String key) => _lintMessages[key]!;

  @override
  Stream<Lint> getLints(ResolvedUnitResult unit) async* {
    fileObject = FileObject(unit.path);

    if (!fileObject.shouldCheckLayerImports) {
      return;
    }

    // Walks the code and triggers our implemented visitors
    // in this case `visitImportDirective`
    unit.unit.visitChildren(this);

    yield* loopOffenders(dataOffenders, 'dont_import_data_files_in_ui', unit);
    yield* loopOffenders(uiOffenders, 'dont_import_ui_files_in_data', unit);
  }

  Stream<Lint> loopOffenders(Iterable<ImportObject> offenders, String key,
      ResolvedUnitResult unit) async* {
    for (var offender in offenders) {
      yield toLint(
          key,
          unit.lintLocationFromOffset(offender.offset,
              length: offender.length));
    }
  }
}
