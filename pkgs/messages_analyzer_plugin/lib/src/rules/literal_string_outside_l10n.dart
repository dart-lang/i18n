// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:meta/meta.dart';

class LiteralStringOutsideL10nRule extends AnalysisRule {
  static const code = LintCode(
    'literal_string_outside_l10n',
    'Hardcoded string literal should be extracted to ARB.',
    correctionMessage: 'Try extracting the string to an ARB file.',
  );

  LiteralStringOutsideL10nRule()
      : super(name: code.lowerCaseName, description: code.problemMessage);

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final path = context.definingUnit.file.path;

    // Exclude generated files and test files.
    if (context.isInTestDirectory ||
        path.endsWith('.g.dart') ||
        path.endsWith('.freezed.dart') ||
        path.contains('/test/') ||
        path.contains('/integration_test/') ||
        path.contains('/test_driver/')) {
      return;
    }

    final visitor = _Visitor(this);
    registry.addSimpleStringLiteral(this, visitor);
    registry.addStringInterpolation(this, visitor);
  }

  @visibleForTesting
  static bool shouldLintNode(Expression node) {
    var textValue = '';
    if (node is SimpleStringLiteral) {
      textValue = node.value;
    } else if (node is StringInterpolation) {
      final buffer = StringBuffer();
      for (final element in node.elements) {
        if (element is InterpolationString) {
          buffer.write(element.value);
        }
      }
      textValue = buffer.toString();
    } else {
      return false;
    }

    // Exclude empty or whitespace-only strings.
    if (textValue.trim().isEmpty) {
      return false;
    }

    // Exclude string literals inside directives (e.g. import, export, part).
    if (node.parent is Directive) {
      return false;
    }

    // Exclude string literals inside annotations / metadata.
    if (node.thisOrAncestorOfType<Annotation>() != null) {
      return false;
    }

    // Exclude strings in assert statements or assert initializers.
    if (node.thisOrAncestorOfType<AssertStatement>() != null ||
        node.thisOrAncestorOfType<AssertInitializer>() != null) {
      return false;
    }

    // Exclude throw expressions (exceptions and errors).
    if (node.thisOrAncestorOfType<ThrowExpression>() != null) {
      return false;
    }

    // Exclude direct variable assignments / initializers (e.g. final key = '...');
    final parent = node.parent;
    if (parent is VariableDeclaration && parent.initializer == node) {
      return false;
    }
    if (parent is AssignmentExpression && parent.rightHandSide == node) {
      return false;
    }

    // Exclude print(...) calls.
    final invocation = node.thisOrAncestorOfType<MethodInvocation>();
    if (invocation != null) {
      final targetName = invocation.methodName.name;
      if (targetName == 'print') {
        return false;
      }
    }

    return true;
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final LiteralStringOutsideL10nRule rule;

  _Visitor(this.rule);

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    if (LiteralStringOutsideL10nRule.shouldLintNode(node)) {
      rule.reportAtNode(node);
    }
  }

  @override
  void visitStringInterpolation(StringInterpolation node) {
    if (LiteralStringOutsideL10nRule.shouldLintNode(node)) {
      rule.reportAtNode(node);
    }
  }
}
