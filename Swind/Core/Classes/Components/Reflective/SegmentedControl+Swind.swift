//
//  UISegmentedControl+Swind.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 4/2/20.
//

import UIKit

public extension UISegmentedControl {
    @nonobjc static private var onSegmentChangeKey  = "swind_onSegmentChange"
    
    /// Closure to be called when segment gets changed, with the picked
    /// segment index as an argument.
    /// - Note: This is an alternative to the usage of the `bind` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
    var swind_onSegmentChange: ((Int) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &UISegmentedControl.onSegmentChangeKey) as? ((Int) -> Void)
        }
        set {
            self.addSwindTargetIfNeeded()
            objc_setAssociatedObject(self, &UISegmentedControl.onSegmentChangeKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onSegmentChangeBindeeSelectorKey  = "swind_onSegmentChangeBindeeSelector"
    private var swind_onSegmentChangeBindeeSelector: Selector? {
        get {
            guard let selectorStr = objc_getAssociatedObject(self, &UISegmentedControl.onSegmentChangeBindeeSelectorKey) as? String else {
                return nil
            }
            return NSSelectorFromString(selectorStr)
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UISegmentedControl.onSegmentChangeBindeeSelectorKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UISegmentedControl.onSegmentChangeBindeeSelectorKey, NSStringFromSelector(newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onSegmentChangeBindeeKey  = "swind_onSegmentChangeBindee"
    private var swind_onSegmentChangeBindee: NSObject? {
        get {
            return (objc_getAssociatedObject(self, &UISegmentedControl.onSegmentChangeBindeeKey) as? SwindWeakReferenceWrapper)?.obj
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UISegmentedControl.onSegmentChangeBindeeKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UISegmentedControl.onSegmentChangeBindeeKey, SwindWeakReferenceWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @nonobjc static private var didAddOnSegmentChangeTargetKey  = "swind_didAddOnSegmentChangeTarget"
    private var swind_didAddPickTarget: Bool {
        get {
            return (objc_getAssociatedObject(self, &UISegmentedControl.didAddOnSegmentChangeTargetKey) as? NSNumber)?.boolValue ?? false
        }
        set {
            objc_setAssociatedObject(self, &UISegmentedControl.didAddOnSegmentChangeTargetKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// This function binds the view so that, when the segment gets changed,
    /// it'll perform the given selector on the `bindee`.
    ///
    /// - Warning: no check will be made to see if the bindee can actually
    ///            perform the selector, so this might blow up if it can't.
    ///
    /// - Parameter bindee: The object that contains the `bindeeSeelctor`
    /// - Parameter bindeeSelector: Selector to be called on `bindee` upon change.
    ///                             It must receive an `NSNumber` argument, which will
    ///                             contain the new `Int` selectedSegmentIndex of the control.
    func swind_bindForChange(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.addSwindTargetIfNeeded()
        self.swind_onSegmentChangeBindee = bindee
        self.swind_onSegmentChangeBindeeSelector = bindeeSelector
    }
    
    private func addSwindTargetIfNeeded() {
        if !self.swind_didAddPickTarget {
            self.addTarget(self, action: #selector(swind_didChangeSegment), for: .valueChanged)
        }
    }
    
    @objc func swind_didChangeSegment(sender: UISegmentedControl) {
           self.swind_onSegmentChange?(self.selectedSegmentIndex)
           self.swind_onSegmentChangeBindee?.perform(self.swind_onSegmentChangeBindeeSelector, with: NSNumber(value: self.selectedSegmentIndex))
       }
}
