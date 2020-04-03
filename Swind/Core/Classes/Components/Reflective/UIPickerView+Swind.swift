//
//  UIPickerView+Swind.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 4/2/20.
//

import UIKit

public extension UIPickerView {
    @nonobjc static private var onPickConstantKey  = "swind_onPick"
    
    /// Closure to be called when item is picked, with the picked item's
    /// `componentIndex` and `rowIndex` passed as arguments (in that order)
    /// - Note: This is an alternative to the usage of the `bind` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
    var swind_onPick: ((Int, Int) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &UIPickerView.onPickConstantKey) as? ((Int, Int) -> Void)
        }
        set {
            self.addSwindTargetIfNeeded()
            objc_setAssociatedObject(self, &UIPickerView.onPickConstantKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onPickBindeeSelectorKey  = "swind_onPickBindeeSelector"
    private var swind_onPickBindeeSelector: Selector? {
        get {
            guard let selectorStr = objc_getAssociatedObject(self, &UIPickerView.onPickBindeeSelectorKey) as? String else {
                return nil
            }
            return NSSelectorFromString(selectorStr)
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UIPickerView.onPickBindeeSelectorKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UIPickerView.onPickBindeeSelectorKey, NSStringFromSelector(newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onPickBindeeKey  = "swind_onPickBindee"
    private var swind_onPickBindee: NSObject? {
        get {
            return (objc_getAssociatedObject(self, &UIPickerView.onPickBindeeKey) as? SwindWeakReferenceWrapper)?.obj
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UIPickerView.onPickBindeeKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UIPickerView.onPickBindeeKey, SwindWeakReferenceWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @nonobjc static private var didAddPickTargetKey  = "swind_didAddPickTarget"
    private var swind_didAddPickTarget: Bool {
        get {
            return (objc_getAssociatedObject(self, &UIPickerView.didAddPickTargetKey) as? NSNumber)?.boolValue ?? false
        }
        set {
            objc_setAssociatedObject(self, &UIPickerView.didAddPickTargetKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @nonobjc static private var swindValuesKey  = "swind_values"
    
    /// Actual values of the picker. Parent array represents components and
    /// should contain child arrays representing the rows of each component.
    var swind_values: [[String]] {
        get {
            return objc_getAssociatedObject(self, &UIPickerView.swindValuesKey) as? [[String]] ?? []
        }
        set {
            self.addSwindTargetIfNeeded()
            objc_setAssociatedObject(self, &UIPickerView.swindValuesKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
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
    func swind_bindForPick(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.addSwindTargetIfNeeded()
        self.swind_onPickBindee = bindee
        self.swind_onPickBindeeSelector = bindeeSelector
    }
    
    private func addSwindTargetIfNeeded() {
        if !self.swind_didAddPickTarget {
            self.delegate = self
            self.dataSource = self
        }
    }
}

extension UIPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.swind_onPick?(component, row)
        self.swind_onPickBindee?.perform(self.swind_onPickBindeeSelector, with: NSNumber(value: component), with: NSNumber(value: row))
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return swind_values.count // number of session
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.swind_values[component].count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return swind_values[component][row]
    }
}
