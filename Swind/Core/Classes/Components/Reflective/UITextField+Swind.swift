//
//  UITextField+Swind.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 4/2/20.
//

import UIKit

public extension UITextField {

    @nonobjc static private var onTextChangeKey  = "swind_onTextChange"
    
    /// Closure to be called when text changes, with the new text as an
    /// argument.
    /// - Note: This is an alternative to the usage of the `bind` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
    var swind_onTextChange: ((String) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &UITextField.onTextChangeKey) as? ((String) -> Void)
        }
        set {
            self.addSwindTargetIfNeeded()
            objc_setAssociatedObject(self, &UITextField.onTextChangeKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onTextChangeBindeeSelectorKey  = "swind_onTextChangeBindeeSelector"
    private var swind_onTextChangeBindeeSelector: Selector? {
        get {
            guard let selectorStr = objc_getAssociatedObject(self, &UITextField.onTextChangeBindeeSelectorKey) as? String else {
                return nil
            }
            return NSSelectorFromString(selectorStr)
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UITextField.onTextChangeBindeeSelectorKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UITextField.onTextChangeBindeeSelectorKey, NSStringFromSelector(newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onTextChangeBindeeKey  = "swind_onTextChangeBindee"
    private var swind_onTextChangeBindee: NSObject? {
        get {
            return (objc_getAssociatedObject(self, &UITextField.onTextChangeBindeeKey) as? SwindWeakReferenceWrapper)?.obj
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UITextField.onTextChangeBindeeKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UITextField.onTextChangeBindeeKey, SwindWeakReferenceWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @nonobjc static private var didAddOnTextChangeTargetKey  = "swind_didAddOnTextChangeTarget"
    private var swind_didAddChangeTarget: Bool {
        get {
            return (objc_getAssociatedObject(self, &UITextField.didAddOnTextChangeTargetKey) as? NSNumber)?.boolValue ?? false
        }
        set {
            objc_setAssociatedObject(self, &UITextField.didAddOnTextChangeTargetKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// This function binds the view so that, when its text changes,
    /// it'll perform the given selector on the `bindee`.
    ///
    /// - Warning: no check will be made to see if the bindee can actually
    ///            perform the selector, so this might blow up if it can't.
    ///
    /// - Parameter bindee: The object that contains the `bindeeSeelctor`
    /// - Parameter bindeeSelector: Selector to be called on `bindee` upon change.
    ///                             It must receive a `String` argument, which will
    ///                             contain the new text.
    func swind_bindForTextChange(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.addSwindTargetIfNeeded()
        self.swind_onTextChangeBindee = bindee
        self.swind_onTextChangeBindeeSelector = bindeeSelector
    }
    
    private func addSwindTargetIfNeeded() {
        if !self.swind_didAddChangeTarget {
            self.addTarget(self, action: #selector(swind_textFieldDidChange), for: .editingChanged)
        }
    }
    
    @objc func swind_textFieldDidChange(sender: UITextField) {
        self.swind_onTextChange?(self.text ?? "")
        self.swind_onTextChangeBindee?.perform(self.swind_onTextChangeBindeeSelector, with: self.text ?? "")
    }
}
