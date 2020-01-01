//
//  UIView+Extensions.swift
//  Adastra
//
//  Created by Abdelrahman-Arw on 12/19/19.
//  Copyright © 2019 Abdelrahman-Arw. All rights reserved.
//

import UIKit
enum LinePosition {
    case linePositionTop
    case linePositionBottom
}
extension UIView {
    
    func setBorder(width: CGFloat = 1, color: UIColor, cornerRadius: CGFloat = 5) {
        layer.cornerRadius = cornerRadius
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func setShadow(color: UIColor = UIColor.black, offset: CGSize = CGSize(width: 1, height: 2.5), radius: CGFloat = 4, opacity: Float = 0.15) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.masksToBounds = false
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setCornerRadius(radius: CGFloat = 5, isClipped: Bool = false, isRounded: Bool = false) {
        if isRounded {
            layer.cornerRadius = self.frame.height / 2
        } else {
            layer.cornerRadius = radius
        }
        layer.masksToBounds = isClipped
    }
    
    func setRoundCorners(corners: CACornerMask, radius: CGFloat = 5) {
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = corners
        } else {
            // Fallback on earlier versions
        }
    }
    
    func addFitSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    func addLine(position: LinePosition, color: UIColor, width: Double, distance: Double? = 10.0) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)
        let metrics = ["width": NSNumber(value: width)]
        let views = ["lineView": lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:  "H:|-10-[lineView]-10-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
        switch position {
        case .linePositionTop:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:  "V:|-\(distance!)-[lineView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
        case .linePositionBottom:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[lineView(width)]-\(distance!)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
        }
    }
}
