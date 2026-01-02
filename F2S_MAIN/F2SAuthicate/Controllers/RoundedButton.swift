//
//  RoundedButton.swift
//  F2SAuthicate
//
//  Created by abdulaziz on 19/12/2025.
//


import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 20 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }

    @IBInspectable var shadow: Bool = false {
        didSet {
            if shadow {
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOpacity = 0.25
                self.layer.shadowOffset = CGSize(width: 0, height: 4)
                self.layer.shadowRadius = 4
                self.layer.masksToBounds = false
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
    }
}


@IBDesignable
class RoundedLabel: UILabel {

    @IBInspectable var cornerRadius: CGFloat = 8 {
        didSet {
            updateView()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            updateView()
        }
    }

    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            updateView()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }

    private func updateView() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
    }
}
