//
//  UISwitch+Swind.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 4/2/20.
//

import UIKit

public extension UISwitch {

    @nonobjc static private var onChangeKey  = "swind_onChange"
    
    /// Closure to be called when switch value changes, with the new value
    /// as an argument.
    /// - Note: This is an alternative to the usage of the `bind` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
    var swind_onChange: ((Bool) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &UISwitch.onChangeKey) as? ((Bool) -> Void)
        }
        set {
            self.addSwindTargetIfNeeded()
            objc_setAssociatedObject(self, &UISwitch.onChangeKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onChangeBindeeSelectorKey  = "swind_onChangeBindeeSelector"
    private var swind_onChangeBindeeSelector: Selector? {
        get {
            guard let selectorStr = objc_getAssociatedObject(self, &UISwitch.onChangeBindeeSelectorKey) as? String else {
                return nil
            }
            return NSSelectorFromString(selectorStr)
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UISwitch.onChangeBindeeSelectorKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UISwitch.onChangeBindeeSelectorKey, NSStringFromSelector(newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onChangeBindeeKey  = "swind_onChangeBindee"
    private var swind_onChangeBindee: NSObject? {
        get {
            return (objc_getAssociatedObject(self, &UISwitch.onChangeBindeeKey) as? SwindWeakReferenceWrapper)?.obj
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UISwitch.onChangeBindeeKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UISwitch.onChangeBindeeKey, SwindWeakReferenceWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @nonobjc static private var didAddOnChangeTargetKey  = "swind_didAddOnChangeTarget"
    private var swind_didAddChangeTarget: Bool {
        get {
            return (objc_getAssociatedObject(self, &UISwitch.didAddOnChangeTargetKey) as? NSNumber)?.boolValue ?? false
        }
        set {
            objc_setAssociatedObject(self, &UISwitch.didAddOnChangeTargetKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// This function binds the view so that, when its value changes,
    /// it'll perform the given selector on the `bindee`.
    ///
    /// - Warning: no check will be made to see if the bindee can actually
    ///            perform the selector, so this might blow up if it can't.
    ///
    /// - Parameter bindee: The object that contains the `bindeeSeelctor`
    /// - Parameter bindeeSelector: Selector to be called on `bindee` upon change.
    ///                             It must receive an `NSNumber` argument, which will
    ///                             contain the new `Bool` value of the switch.
    func swind_bindForChange(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.addSwindTargetIfNeeded()
        self.swind_onChangeBindee = bindee
        self.swind_onChangeBindeeSelector = bindeeSelector
    }
    
    private func addSwindTargetIfNeeded() {
        if !self.swind_didAddChangeTarget {
            self.addTarget(self, action: #selector(swind_switchValueChanged), for: .valueChanged)
        }
    }
    
    @objc func swind_switchValueChanged(sender: UISwitch) {
           self.swind_onChange?(self.isOn)
           self.swind_onChangeBindee?.perform(self.swind_onChangeBindeeSelector, with: NSNumber(booleanLiteral: self.isOn))
       }
}
