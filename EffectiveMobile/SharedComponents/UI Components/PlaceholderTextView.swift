//
//  PlaceholderTextView.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import UIKit

class PlaceholderTextView: UITextView {
    var placeholder: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }

    var placeholderColor: UIColor = .gray {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }

    @objc private func textDidChange() {
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if text.isEmpty {
            let placeholderRect = CGRect(
                x: textContainerInset.left + 4,
                y: textContainerInset.top,
                width: bounds.width - textContainerInset.left - textContainerInset.right,
                height: bounds.height - textContainerInset.top - textContainerInset.bottom
            )

            let attributes: [NSAttributedString.Key: Any] = [
                .font: font ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: placeholderColor
            ]

            placeholder.draw(in: placeholderRect, withAttributes: attributes)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
