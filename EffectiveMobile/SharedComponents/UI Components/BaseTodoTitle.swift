//
//  BaseTodoTitle.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 13.03.2025.
//

import UIKit

class BaseTodoTitle: PlaceholderTextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupTitleTextView()
    }
    
    convenience init() {
        self.init(frame: .zero, textContainer: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleTextView(){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.isEditable = false
        self.isScrollEnabled = false
        self.setLetterSpacing(-0.43)
        
        self.textContainerInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
    }
}
