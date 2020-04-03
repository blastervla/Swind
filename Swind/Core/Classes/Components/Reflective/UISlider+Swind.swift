//
//  UISlider+Swind.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 4/2/20.
//

import UIKit

public extension UISlider {
    @nonobjc static private var onValueChangeKey  = "swind_onValueChange"
    
    /// Closure to be called when value gets changed, with the new value
    /// as an argument.
    /// - Note: This is an alternative to the usage of the `bind` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
    var swind_onValueChange: ((Float) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &UISlider.onValueChangeKey) as? ((Float) -> Void)
        }
        set {
            self.addSwindTargetIfNeeded()
            objc_setAssociatedObject(self, &UISlider.onValueChangeKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onValueChangeBindeeSelectorKey  = "swind_onValueChangeBindeeSelector"
    private var swind_onValueChangeBindeeSelector: Selector? {
        get {
            guard let selectorStr = objc_getAssociatedObject(self, &UISlider.onValueChangeBindeeSelectorKey) as? String else {
                return nil
            }
            return NSSelectorFromString(selectorStr)
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UISlider.onValueChangeBindeeSelectorKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UISlider.onValueChangeBindeeSelectorKey, NSStringFromSelector(newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onValueChangeBindeeKey  = "swind_onValueChangeBindee"
    private var swind_onValueChangeBindee: NSObject? {
        get {
            return (objc_getAssociatedObject(self, &UISlider.onValueChangeBindeeKey) as? SwindWeakReferenceWrapper)?.obj
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UISlider.onValueChangeBindeeKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UISlider.onValueChangeBindeeKey, SwindWeakReferenceWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @nonobjc static private var didAddOnValueChangeTargetKey  = "swind_didAddOnValueChangeTarget"
    private var swind_didAddChangeTarget: Bool {
        get {
            return (objc_getAssociatedObject(self, &UISlider.didAddOnValueChangeTargetKey) as? NSNumber)?.boolValue ?? false
        }
        set {
            objc_setAssociatedObject(self, &UISlider.didAddOnValueChangeTargetKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// This function binds the view so that, when its value changes,
    /// it'll perform the given selector on the `bindee`.
    ///
    /// - Warning: no check will be made to see if the bindee can actually
    ///            perform the selector, so this might blow up if it can't.
    ///
    /// - Note: Please ensure this view gets proper width size in accordance with
    ///         its possible value size (ie: its value span) in order to get a
    ///         smooth sliding performance.
    ///
    /// - Parameter bindee: The object that contains the `bindeeSeelctor`
    /// - Parameter bindeeSelector: Selector to be called on `bindee` upon change.
    ///                             It must receive an `NSNumber` argument, which will
    ///                             contain the new `Float` value of the slider.
    func swind_bindForChange(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.addSwindTargetIfNeeded()
        self.swind_onValueChangeBindee = bindee
        self.swind_onValueChangeBindeeSelector = bindeeSelector
    }
    
    private func addSwindTargetIfNeeded() {
        if !self.swind_didAddChangeTarget {
            self.addTarget(self, action: #selector(swind_sliderValueChanged), for: .valueChanged)
        }
    }
    
    @objc func swind_sliderValueChanged(sender: UISlider) {
           self.swind_onValueChange?(self.value)
           self.swind_onValueChangeBindee?.perform(self.swind_onValueChangeBindeeSelector, with: NSNumber(value: self.value))
       }
}
