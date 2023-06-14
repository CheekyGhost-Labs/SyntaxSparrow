//
//  DeclarationComponent.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation

/// Public protocol that any semantic elements not considered a declaration will conform to.
/// A declaration component is considered a semantic element that supports or decorates a declaration such as attributes, modifiers, generic parameter/requirement, parameters, etc
public protocol DeclarationComponent: SyntaxRepresenting {}
