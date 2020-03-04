//
//  BindeableMDCMultilineTextField.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/4/20.
//

import UIKit
import MaterialComponents

class BindeableMDCMultilineTextField: MDCMultilineTextField, UITextViewDelegate {

    var onTextChange: ((String) -> Void)? = nil
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
    
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.bindee = bindee
        self.bindeeSelector = bindeeSelector
    }
    
    @objc func textViewDidChange(_ textView: UITextView) {
        self.onTextChange?(self.text ?? "")
        self.bindee?.perform(self.bindeeSelector, with: self.text ?? "")
    }

}
