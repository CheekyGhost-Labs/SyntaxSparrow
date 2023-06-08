//
//  Operator+Validity.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation

extension Operator {
    // MARK: - Convenience

    static func isValidIdentifier(_ string: String) -> Bool {
        guard let first = string.first, isValidHeadCharacter(first) else {
            return false
        }

        for character in string.suffix(from: string.startIndex) {
            guard isValidCharacter(character) else { return false }
        }

        return true
    }

    static func isValidHeadCharacter(_ character: Character) -> Bool {
        switch character {
        case // Basic Latin
            "/", "=", "-", "+", "!", "*", "%",
            "<", ">", "&", "|", "^", "?", "~",

            // Latin-1 Supplement
            "\u{00A1}",
            "\u{00A2}",
            "\u{00A3}",
            "\u{00A4}",
            "\u{00A5}",
            "\u{00A6}",
            "\u{00A7}",
            "\u{00A9}",
            "\u{00AB}",
            "\u{00AC}",
            "\u{00AE}",
            "\u{00B0}",
            "\u{00B1}",
            "\u{00B6}",
            "\u{00BB}",
            "\u{00BF}",
            "\u{00D7}",
            "\u{00F7}",

            // General Punctuation
            "\u{2016}" ... "\u{2017}",
            "\u{2020}" ... "\u{2027}",
            "\u{2030}" ... "\u{203E}",
            "\u{2041}" ... "\u{2053}",
            "\u{2055}" ... "\u{205E}",
            "\u{2190}" ... "\u{23FF}",

            // Box Drawing
            "\u{2500}" ... "\u{257F}",

            // Block Elements
            "\u{2580}" ... "\u{259F}",

            // Miscellaneous Symbols
            "\u{2600}" ... "\u{26FF}",

            // Dingbats
            "\u{2700}" ... "\u{2775}",
            "\u{2794}" ... "\u{2BFF}",

            // Supplemental Punctuation
            "\u{2E00}" ... "\u{2E7F}",

            // CJK Symbols and Punctuation
            "\u{3001}" ... "\u{3003}",
            "\u{3008}" ... "\u{3020}",
            "\u{3030}":
            return true
        default:
            return false
        }
    }

    static func isValidCharacter(_ character: Character) -> Bool {
        switch character {
        case "\u{0300}" ... "\u{036F}",
             "\u{1DC0}" ... "\u{1DFF}",
             "\u{20D0}" ... "\u{20FF}",
             "\u{FE00}" ... "\u{FE0F}",
             "\u{FE20}" ... "\u{FE2F}",
             "\u{E0100}" ... "\u{E01EF}":
            return true
        default:
            return isValidHeadCharacter(character)
        }
    }
}
