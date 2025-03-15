//
//  TodoValidator.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import Foundation

struct TodoValidator {
    static func validateTitle(_ title: String) -> Bool {
        return !title.isEmpty
    }

    static func validateDate(_ dateString: String) -> Bool {
        return Date.fromString(dateString) != nil
    }
}
