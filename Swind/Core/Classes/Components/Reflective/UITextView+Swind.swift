//
//  UITextView+Swind.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 4/2/20.
//

import UIKit

public extension UITextView {

    @nonobjc static private var onTextChangeKey  = "swind_onTextChange"
    
    /// Closure to be called when text changes, with the new text as an
    /// argument.
    ///
    /// - Warning: this property won't work intendedly if you later on set the TextView
    ///            delegate. Should you need to set the delegate, be sure to do so by
    ///            calling the `swind_setDelegate` method.
    ///
    /// - Note: This is an alternative to the usage of the `bind` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
    var swind_onTextChange: ((String) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &UITextView.onTextChangeKey) as? ((String) -> Void)
        }
        set {
            self.addSwindTargetIfNeeded()
            objc_setAssociatedObject(self, &UITextView.onTextChangeKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onTextChangeBindeeSelectorKey  = "swind_onTextChangeBindeeSelector"
    private var swind_onTextChangeBindeeSelector: Selector? {
        get {
            guard let selectorStr = objc_getAssociatedObject(self, &UITextView.onTextChangeBindeeSelectorKey) as? String else {
                return nil
            }
            return NSSelectorFromString(selectorStr)
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UITextView.onTextChangeBindeeSelectorKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UITextView.onTextChangeBindeeSelectorKey, NSStringFromSelector(newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @nonobjc static private var onTextChangeBindeeKey  = "swind_onTextChangeBindee"
    private var swind_onTextChangeBindee: NSObject? {
        get {
            return (objc_getAssociatedObject(self, &UITextView.onTextChangeBindeeKey) as? SwindWeakReferenceWrapper)?.obj
        }
        set {
            guard let newValue = newValue else {
                objc_setAssociatedObject(self, &UITextView.onTextChangeBindeeKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UITextView.onTextChangeBindeeKey, SwindWeakReferenceWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @nonobjc static private var didAddOnTextChangeTargetKey  = "swind_didAddOnTextChangeTarget"
    private var swind_didAddChangeTarget: Bool {
        get {
            return (objc_getAssociatedObject(self, &UITextView.didAddOnTextChangeTargetKey) as? NSNumber)?.boolValue ?? false
        }
        set {
            objc_setAssociatedObject(self, &UITextView.didAddOnTextChangeTargetKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @nonobjc static private var swindDelegateKey  = "swind_Delegate"
    private var swind_Delegate: UITextViewDelegate? {
        get {
            return (objc_getAssociatedObject(self, &UITextView.swindDelegateKey) as? SwindWeakReferenceWrapper)?.obj as? UITextViewDelegate
        }
        set {
            guard let newValue = newValue as? NSObject else {
                objc_setAssociatedObject(self, &UITextView.swindDelegateKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return
            }
            objc_setAssociatedObject(self, &UITextView.swindDelegateKey, SwindWeakReferenceWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// This function binds the view so that, when its text changes,
    /// it'll perform the given selector on the `bindee`.
    ///
    /// - Warning: no check will be made to see if the bindee can actually
    ///            perform the selector, so this might blow up if it can't.
    ///
    /// - Warning: this method won't work if you later on set the TextView delegate.
    ///            should you need to set the delegate, be sure to do so by calling
    ///            the `swind_setDelegate` method.
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
    
    /// Call this function to set your own delegate to the UITextView without breaking
    /// swind's functionality.
    ///
    /// - Warning: be really careful when setting the UITextView as its own delegate,
    ///            as swind's implementation depends on that and doing so might
    ///            generate an infinite recursion loop.
    ///
    func swind_setDelegate<T: NSObject & UITextViewDelegate>(_ delegate: T) {
        self.swind_Delegate = delegate
    }
    
    private func addSwindTargetIfNeeded() {
        if !self.swind_didAddChangeTarget {
            self.delegate = self
        }
    }
}

extension UITextView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        self.swind_Delegate?.textViewDidChange?(textView)
        self.swind_onTextChange?(textView.text)
        self.swind_onTextChangeBindee?.perform(self.swind_onTextChangeBindeeSelector, with: textView.text ?? "")
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        self.swind_Delegate?.textViewDidEndEditing?(textView)
    }
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.swind_Delegate?.textViewDidBeginEditing?(textView)
    }
    public func textViewDidChangeSelection(_ textView: UITextView) {
        self.swind_Delegate?.textViewDidChangeSelection?(textView)
    }
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return self.swind_Delegate?.textViewShouldEndEditing?(textView) ?? true
    }
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return self.swind_Delegate?.textViewShouldBeginEditing?(textView) ?? true
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return self.swind_Delegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return self.swind_Delegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return self.swind_Delegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
    }
}

