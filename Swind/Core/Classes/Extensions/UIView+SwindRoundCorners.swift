//
//  UIViewSwindRoundCorners+Swind.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 23/03/2020.
//

import UIKit

extension UIView {

    public func swind_roundCorners(radius: CGFloat, corners: UIRectCorner) {
        let rounded = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        self.layer.mask = shape
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

}
