//
//  Declaration+DeclarationCollecting.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation

extension Declaration where Self: SyntaxChildCollecting {
    // MARK: - DeclarationCollecting

    var collection: DeclarationCollection? {
        guard let collecting = self as? DeclarationCollecting else { return nil }
        return collecting.declarationCollection
    }
}
