//
//  SkipByDefaultVisitor.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `SyntaxVisitor` subclass that returns `.skipChildren` for any visitaions.
class SkipByDefaultVisitor: SyntaxVisitor {
    override func visit(_: ImportPathComponentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ImportPathComponentListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AccessorBlockSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AccessorDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AccessorEffectSpecifiersSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AccessorDeclListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AccessorParametersSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ActorDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ArrayElementListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ArrayElementSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ArrayExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ArrayTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ArrowExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AsExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AssignmentExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AssociatedTypeDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AttributeListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AttributeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AttributedTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AvailabilityArgumentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AvailabilityConditionSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SpecializeAvailabilityArgumentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AvailabilityLabeledArgumentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AvailabilityArgumentListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PlatformVersionItemSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PlatformVersionItemListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PlatformVersionSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: AwaitExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: BackDeployedAttributeArgumentsSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: BinaryOperatorExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: BooleanLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: BorrowExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: BreakStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SwitchCaseItemListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SwitchCaseItemSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: CatchClauseListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: CatchClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: CatchItemListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: CatchItemSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ClassRestrictionTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ClosureCaptureListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ClosureCaptureSpecifierSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ClosureCaptureSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ClosureCaptureClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ClosureExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ClosureShorthandParameterListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ClosureShorthandParameterSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ClosureParameterClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ClosureParameterListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ClosureParameterSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ClosureSignatureSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: CodeBlockItemListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: CodeBlockItemSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: CodeBlockSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: CompositionTypeElementListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: CompositionTypeElementSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: CompositionTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ConditionElementListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ConditionElementSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ConformanceRequirementSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SomeOrAnyTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ContinueStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ConventionAttributeArgumentsSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ConventionWitnessMethodAttributeArgumentsSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: CopyExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DeclModifierDetailSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DeclModifierSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DeclNameArgumentListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DeclNameArgumentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DeclNameArgumentsSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DeferStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DeinitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DerivativeAttributeArgumentsSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DesignatedTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DesignatedTypeListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DictionaryElementListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DictionaryElementSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DictionaryExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DictionaryTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DifferentiabilityArgumentListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DifferentiabilityArgumentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DifferentiabilityWithRespectToArgumentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DifferentiabilityArgumentsSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DifferentiableAttributeArgumentsSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DiscardAssignmentExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DiscardStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DoStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DocumentationAttributeArgumentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DocumentationAttributeArgumentListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DynamicReplacementAttributeArgumentsSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: EditorPlaceholderDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: EditorPlaceholderExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: EffectsAttributeArgumentListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: EnumCaseDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: EnumCaseElementListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: EnumCaseElementSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: EnumCaseParameterClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: EnumCaseParameterListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: EnumCaseParameterSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ExposeAttributeArgumentsSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ExprListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ExpressionPatternSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ExpressionSegmentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ExpressionStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: FallThroughStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: FloatLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ForStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ForceUnwrapExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: FunctionEffectSpecifiersSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: FunctionParameterListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: FunctionParameterSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: FunctionSignatureSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: FunctionTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: GenericArgumentClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: GenericArgumentListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: GenericArgumentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: GenericParameterClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: GenericParameterListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: GenericParameterSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: GenericRequirementListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: GenericRequirementSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: GenericWhereClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: GuardStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DeclReferenceExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: IdentifierPatternSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: IfConfigClauseListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: IfConfigClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: IfConfigDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: IfExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ImplementsAttributeArgumentsSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ImplicitlyUnwrappedOptionalTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ImportDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: InOutExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: InfixOperatorExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: InheritedTypeListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: InheritedTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: InitializerClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: IntegerLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: IsExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: IsTypePatternSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: KeyPathComponentListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: KeyPathComponentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: KeyPathExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: KeyPathOptionalComponentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: KeyPathPropertyComponentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: KeyPathSubscriptComponentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: LabeledSpecializeArgumentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: LabeledStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: LayoutRequirementSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MacroDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MacroExpansionDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MacroExpansionExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MatchingPatternConditionSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MemberBlockSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MemberBlockItemSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MemberBlockItemListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MemberTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MetatypeTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MissingDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MissingExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MissingPatternSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MissingStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MissingSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MissingTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: DeclModifierListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ConsumeExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MultipleTrailingClosureElementListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: MultipleTrailingClosureElementSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: NamedOpaqueReturnTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: NilLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ObjCSelectorPieceSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ObjCSelectorPieceListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: OpaqueReturnTypeOfAttributeArgumentsSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: OperatorDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: OperatorPrecedenceAndTypesSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: OptionalBindingConditionSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: OptionalChainingExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: OptionalTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: OriginallyDefinedInAttributeArgumentsSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PackElementExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PackExpansionExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PackExpansionTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PackElementTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: FunctionParameterClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PatternBindingListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PatternBindingSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PostfixIfConfigExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PostfixOperatorExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PoundSourceLocationArgumentsSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PoundSourceLocationSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PrecedenceGroupAssignmentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PrecedenceGroupAssociativitySyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PrecedenceGroupAttributeListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PrecedenceGroupDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PrecedenceGroupNameSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PrecedenceGroupNameListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PrecedenceGroupRelationSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PrefixOperatorExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PrimaryAssociatedTypeClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PrimaryAssociatedTypeListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PrimaryAssociatedTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: RegexLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: RepeatStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ReturnClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ReturnStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SameTypeRequirementSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: IdentifierTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SourceFileSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SpecializeAttributeArgumentListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: GenericSpecializationExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: StringLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: StringLiteralSegmentListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: StringSegmentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SubscriptDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SubscriptCallExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SuperExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SuppressedTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SwitchCaseLabelSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SwitchCaseListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SwitchCaseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SwitchDefaultLabelSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SwitchExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: SpecializeTargetFunctionArgumentSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: TernaryExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ThrowStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: TryExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: LabeledExprListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: LabeledExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: TupleExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: TuplePatternElementListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: TuplePatternElementSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: TuplePatternSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: TupleTypeElementListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: TupleTypeElementSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: TupleTypeSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: TypeAnnotationSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: TypeEffectSpecifiersSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: TypeExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: InheritanceClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: TypeInitializerClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: TypeAliasDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: UnavailableFromAsyncAttributeArgumentsSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: UnderscorePrivateAttributeArgumentsSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: UnexpectedNodesSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: UnresolvedAsExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: UnresolvedIsExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: PatternExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: UnresolvedTernaryExprSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: ValueBindingPatternSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: VersionTupleSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: WhereClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: WhileStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: WildcardPatternSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: YieldedExpressionSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: YieldedExpressionListSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: YieldedExpressionsClauseSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: YieldStmtSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    override func visit(_: TokenSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }
}
