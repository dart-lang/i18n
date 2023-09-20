import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

Map<String, Map<String, int>> getMessageNumbers(
  Map<String, Set<String>> messages,
  Map<String, String> generatedFiles,
) {
  final Map<String, Map<String, int>> map = {};
  for (final generatedFile in generatedFiles.entries) {
    final result = parseFile(
      path: generatedFile.value,
      featureSet: FeatureSet.latestLanguageVersion(),
    );
    final messageFinder =
        MessageNumberFinder(generatedFile.key, messages[generatedFile.key]!);
    result.unit.visitChildren(messageFinder);
    final numbersForClasses = messageFinder.numbersForClasses;
    map[generatedFile.key] = numbersForClasses;
  }
  return map;
}

class MessageNumberFinder extends RecursiveAstVisitor {
  final String className;
  final Set<String> messages;
  MessageNumberFinder(this.className, this.messages);

  final Map<String, int> numbersForClasses = {};

  @override
  visitClassDeclaration(ClassDeclaration node) {
    if (node.name.lexeme == '${className}Index') {
      node.visitChildren(this);
    }
  }

  @override
  visitVariableDeclaration(VariableDeclaration node) {
    if (messages.contains(node.name.lexeme)) {
      final initializer = node.initializer;
      if (initializer is IntegerLiteral) {
        numbersForClasses[node.name.lexeme] = initializer.value!;
      }
    }
  }
}
