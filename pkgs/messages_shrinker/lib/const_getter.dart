import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

Future<List<String>> getConst(List<String> paths) async {
  final AnalysisContextCollection collection = AnalysisContextCollection(
    includedPaths: paths,
  );
  final first = paths[1];
  final AnalysisContext context = collection.contextFor(first);
  final AnalysisSession session = context.currentSession;
  final result = await session.getResolvedUnit(first);
  if (result is ResolvedUnitResult) {
    final messageFinder = ConstFinder();
    result.unit.visitChildren(messageFinder);
    return <String>[];
  } else {
    throw Error();
  }
}

class ConstFinder extends RecursiveAstVisitor {
  @override
  visitFieldDeclaration(FieldDeclaration node) {
    node.visitChildren(this);
    if (node.fields.isConst) {
      print('visited field $node');
    }
  }
}
