//
//  BindeableTextField.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/3/20.
//  Copyright © 2020 Vladimir Pomsztein. All rights reserved.
//

import UIKit

public class BindeableTextField: UITextField {

    public var onTextChange: (() -> Void)? = nil
    public var bindeeSelector: Selector?
    public var bindee: NSObject?

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
        self.onTextChange?()
        self.bindee?.perform(self.bindeeSelector, with: self.text ?? "")
    }

}
