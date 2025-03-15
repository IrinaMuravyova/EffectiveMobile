//
//  BaseTodoDescription.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 13.03.2025.
//

import UIKit

class BaseTodoDescription: PlaceholderTextView {
    private let figmaColor = UIColor(hex: "#F4F4F4")
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupDescriptionTextView()
    }
    
    convenience init() {
        self.init(frame: .zero, textContainer: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDescriptionTextView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isEditable = false
        self.isScrollEnabled = false
        self.font = UIFont.systemFont(ofSize: 12)
        self.textColor = figmaColor
        self.alpha = 1
        
        self.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
}
