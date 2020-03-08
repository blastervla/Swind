//
//  BindeableMDCMultilineTextField.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/4/20.
//

import UIKit
import MaterialComponents

public class BindeableMDCMultilineTextField: MDCMultilineTextField, UITextViewDelegate {

    /// Closure to be called when text changes, with the new text as an
    /// argument.
    /// - Note: This is an alternative to the usage of the `bind` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
    public var onTextChange: ((String) -> Void)? = nil
    
    var bindeeSelector: Selector?
    var bindee: NSObject?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textView?.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textView?.delegate = self
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
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.bindee = bindee
        self.bindeeSelector = bindeeSelector
    }
    
    @objc public func textViewDidChange(_ textView: UITextView) {
        self.onTextChange?(self.text ?? "")
        self.bindee?.perform(self.bindeeSelector, with: self.text ?? "")
    }

}
