//
//  BindeableMDCTextField.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/3/20.
//  Copyright © 2020 Vladimir Pomsztein. All rights reserved.
//

import UIKit
import MaterialComponents

class BindeableMDCTextField: MDCTextField {

    var onTextChange: ((String) -> Void)? = nil
    var bindeeSelector: Selector?
    var bindee: NSObject?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.bindee = bindee
        self.bindeeSelector = bindeeSelector
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        self.onTextChange?(self.text ?? "")
        self.bindee?.perform(self.bindeeSelector, with: self.text ?? "")
    }

}
