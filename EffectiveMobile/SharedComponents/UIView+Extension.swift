//
//  UIView+Extension.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 11.03.2025.
//

import UIKit

extension UIView {
    func setLetterSpacing(_ letterSpacing: CGFloat) {
        if let label = self as? UILabel, let text = label.text {
            label.attributedText = NSAttributedString(string: text, attributes: [.kern: letterSpacing])
        } else if let textField = self as? UITextField, let text = textField.text {
            textField.attributedText = NSAttributedString(string: text, attributes: [.kern: letterSpacing])
        } else if let textView = self as? UITextView, let text = textView.text {
            textView.attributedText = NSAttributedString(string: text, attributes: [.kern: letterSpacing])
        }
    }
}
