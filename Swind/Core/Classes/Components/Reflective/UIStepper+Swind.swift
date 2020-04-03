//
//  UIStepper+Swind.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 4/2/20.
//

import UIKit

public extension UIStepper {
    
    @nonobjc static private var onIncreaseKey  = "swind_onIncrease"
    
    /// Closure to be called when stepper value increases.
    var swind_onIncrease: ((Double) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &UIStepper.onIncreaseKey) as? ((Double) -> Void)
        }
        set {
            self.addSwindTargetIfNeeded()
            objc_setAssociatedObject(self, &UIStepper.onIncreaseKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onDecreaseKey  = "swind_onDecrease"
    
    /// Closure to be called when stepper value decreases.
    var swind_onDecrease: ((Double) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &UIStepper.onDecreaseKey) as? ((Double) -> Void)
        }
        set {
            self.addSwindTargetIfNeeded()
            objc_setAssociatedObject(self, &UIStepper.onDecreaseKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onChangeKey  = "swind_onChange"
    
    /// Closure to be called when stepper value changes (this handles both
    /// increases and decreases).
    /// - Note: This is an alternative to the usage of the `bind` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
    var swind_onChange: ((Double) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &UIStepper.onChangeKey) as? ((Double) -> Void)
        }
        set {
            self.addSwindTargetIfNeeded()
            objc_setAssociatedObject(self, &UIStepper.onChangeKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onChangeBindeeSelectorKey  = "swind_onChangeBindeeSelector"
    private var swind_onChangeBindeeSelector: Selector? {
        get {
            guard let selectorStr = objc_getAssociatedObject(self, &UIStepper.onChangeBindeeSelectorKey) as? String else {
                return nil
            }
            return NSSelectorFromString(selectorStr)
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UIStepper.onChangeBindeeSelectorKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UIStepper.onChangeBindeeSelectorKey, NSStringFromSelector(newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onChangeBindeeKey  = "swind_onChangeBindee"
    private var swind_onChangeBindee: NSObject? {
        get {
            return (objc_getAssociatedObject(self, &UIStepper.onChangeBindeeKey) as? SwindWeakReferenceWrapper)?.obj
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UIStepper.onChangeBindeeKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UIStepper.onChangeBindeeKey, SwindWeakReferenceWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @nonobjc static private var didAddOnChangeTargetKey  = "swind_didAddOnChangeTarget"
    private var swind_didAddChangeTarget: Bool {
        get {
            return (objc_getAssociatedObject(self, &UIStepper.didAddOnChangeTargetKey) as? NSNumber)?.boolValue ?? false
        }
        set {
            objc_setAssociatedObject(self, &UIStepper.didAddOnChangeTargetKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @nonobjc static private var previousValueKey  = "swind_previousValue"
    private var swind_previousValue: Double {
        get {
            guard let num = objc_getAssociatedObject(self, &UIStepper.previousValueKey) as? NSNumber else { return 0}
            return Double(truncating: num)
        }
        set {
            objc_setAssociatedObject(self, &UIStepper.previousValueKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
    ///                             contain the new `Double` value of the stepper.
    func swind_bindForChange(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.addSwindTargetIfNeeded()
        self.swind_onChangeBindee = bindee
        self.swind_onChangeBindeeSelector = bindeeSelector
    }
    
    private func addSwindTargetIfNeeded() {
        if !self.swind_didAddChangeTarget {
            self.addTarget(self, action: #selector(swind_stepperValueChanged), for: .valueChanged)
        }
    }
    
    @objc func swind_stepperValueChanged(sender: UIStepper) {
           let didIncrease = self.swind_previousValue < self.value
           self.swind_previousValue = self.value
           
           self.swind_onChange?(self.value)
           if didIncrease {
               self.swind_onIncrease?(self.value)
           } else {
               self.swind_onDecrease?(self.value)
           }
           self.swind_onChangeBindee?.perform(self.swind_onChangeBindeeSelector, with: NSNumber(value: self.value))
       }
}
