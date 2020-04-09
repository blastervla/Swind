//
//  UIView+Swind.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 4/2/20.
//

import UIKit

public extension UIView {
    @nonobjc static private var onTapConstantKey  = "swind_onTap"
    
    /// Closure to be called when button gets tapped.
    /// - Note: This is an alternative to the usage of the `bind` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
    var swind_onTap: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &UIView.onTapConstantKey) as? (() -> Void)
        }
        set {
            self.addSwindTargetIfNeeded()
            objc_setAssociatedObject(self, &UIView.onTapConstantKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onLongTapConstantKey  = "swind_onLongTap"
    
    /// Closure to be called when button gets long tapped (ie: long-pressed).
    /// - Note: This is an alternative to the usage of the `bindForLongTap` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
    var swind_onLongTap: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &UIView.onLongTapConstantKey) as? (() -> Void)
        }
        set {
            self.addSwindTargetIfNeeded()
            objc_setAssociatedObject(self, &UIView.onLongTapConstantKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var tapBindeeSelectorKey  = "swind_tapBindeeSelector"
    private var swind_tapBindeeSelector: Selector? {
        get {
            guard let selectorStr = objc_getAssociatedObject(self, &UIView.tapBindeeSelectorKey) as? String else {
                return nil
            }
            return NSSelectorFromString(selectorStr)
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UIView.tapBindeeSelectorKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UIView.tapBindeeSelectorKey, NSStringFromSelector(newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var tapBindeeKey  = "swind_tapBindee"
    private var swind_tapBindee: NSObject? {
        get {
            return (objc_getAssociatedObject(self, &UIView.tapBindeeKey) as? SwindWeakReferenceWrapper)?.obj
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UIView.tapBindeeKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UIView.tapBindeeKey, SwindWeakReferenceWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @nonobjc static private var longTapBindeeSelectorKey  = "swind_longTapBindeeSelector"
    private var swind_longTapBindeeSelector: Selector? {
        get {
            guard let selectorStr = objc_getAssociatedObject(self, &UIView.longTapBindeeSelectorKey) as? String else {
                return nil
            }
            return NSSelectorFromString(selectorStr)
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UIView.longTapBindeeSelectorKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UIView.longTapBindeeSelectorKey, NSStringFromSelector(newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var longTapBindeeKey  = "swind_longTapBindee"
    private var swind_longTapBindee: NSObject? {
        get {
            return (objc_getAssociatedObject(self, &UIView.longTapBindeeKey) as? SwindWeakReferenceWrapper)?.obj
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UIView.longTapBindeeKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UIView.longTapBindeeKey, SwindWeakReferenceWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @nonobjc static private var didAddTargetKey  = "swind_didAddTarget"
    private var swind_didAddTarget: Bool {
        get {
            return (objc_getAssociatedObject(self, &UIView.didAddTargetKey) as? NSNumber)?.boolValue ?? false
        }
        set {
            objc_setAssociatedObject(self, &UIView.didAddTargetKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// This function binds the view so that, when it gets tapped,
    /// it'll perform the given selector on the `bindee`.
    ///
    /// - Warning: no check will be made to see if the bindee can actually
    ///            perform the selector, so this might blow up if it can't.
    ///
    /// - Parameter bindee: The object that contains the `bindeeSeelctor`
    /// - Parameter bindeeSelector: Selector to be called on `bindee` upon tap.
    func swind_bindForTap(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.addSwindTargetIfNeeded()
        self.swind_tapBindee = bindee
        self.swind_tapBindeeSelector = bindeeSelector
    }
    
    /// This function binds the view so that, when it gets long tapped (ie: long-pressed),
    /// it'll perform the given selector on the `bindee`.
    ///
    /// - Warning: no check will be made to see if the bindee can actually
    ///            perform the selector, so this might blow up if it can't.
    ///
    /// - Parameter bindee: The object that contains the `bindeeSeelctor`
    /// - Parameter bindeeSelector: Selector to be called on `bindee` upon long tap.
    func swind_bindForLongTap(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.addSwindTargetIfNeeded()
        self.swind_longTapBindee = bindee
        self.swind_longTapBindeeSelector = bindeeSelector
    }
    
    private func addSwindTargetIfNeeded() {
        if !self.swind_didAddTarget {
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(swind_didTap))
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(swind_didLongTap))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(singleTap)
            self.addGestureRecognizer(longPress)
        }
    }
    
    @objc func swind_didTap(sender: UIView) {
        self.swind_onTap?()
        self.swind_tapBindee?.perform(self.swind_tapBindeeSelector)
    }
    
    @objc func swind_didLongTap(sender: UILongPressGestureRecognizer) {
        if (sender.state == .began) {
            self.swind_onLongTap?()
            self.swind_longTapBindee?.perform(self.swind_longTapBindeeSelector)
        }
    }
}
