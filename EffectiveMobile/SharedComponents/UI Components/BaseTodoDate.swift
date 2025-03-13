//
//  BaseTodoDate.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 13.03.2025.
//

import UIKit

class BaseTodoDate: BaseTodoDescription {
    
    override var alpha: CGFloat {
        get {
            return super.alpha
        }
        set {
            super.alpha = newValue * 0.5
        }
    }
}
