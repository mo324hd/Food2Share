//
//  Untitled.swift
//  ZAJEL
//
//  Created by wael on 26/05/2025.
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

@IBDesignable
class DashedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 8 {
        didSet { updateView() }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet { updateView() }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet { updateView() }
    }
    
    @IBInspectable var dashLength: CGFloat = 6 {
        didSet { updateView() }
    }
    
    @IBInspectable var dashSpacing: CGFloat = 3 {
        didSet { updateView() }
    }

    private var dashLayer: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }

    private func updateView() {
        
        dashLayer?.removeFromSuperlayer()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "dashedBorder"
        shapeLayer.frame = bounds
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.lineWidth = borderWidth
        shapeLayer.lineDashPattern = [NSNumber(value: Float(dashLength)), NSNumber(value: Float(dashSpacing))]

        layer.addSublayer(shapeLayer)
        dashLayer = shapeLayer
    }
}

@IBDesignable
class RoundedImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet { updateView() }
    }
    
    @IBInspectable var makeCircular: Bool = false {
        didSet { updateView() }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { updateView() }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet { updateView() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }

    private func updateView() {
        if makeCircular {
            layer.cornerRadius = min(bounds.width, bounds.height) / 2
        } else {
            layer.cornerRadius = cornerRadius
        }
        
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        clipsToBounds = true
    }
}
