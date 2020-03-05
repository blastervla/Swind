//
//  BindeableCheckbox.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/3/20.
//  Copyright © 2020 Vladimir Pomsztein. All rights reserved.
//

import UIKit
import M13Checkbox

public class BindeableCheckbox: M13Checkbox {

    public var onChange: ((Bool) -> Void)? = nil
    var bindeeSelector: Selector?
    var bindee: NSObject?
    
    public var isChecked: Bool {
        return self.checkState == .checked
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(checkboxChangedState), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(checkboxChangedState), for: .valueChanged)
    }
    
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.bindee = bindee
        self.bindeeSelector = bindeeSelector
    }
    
    @objc func checkboxChangedState(_ checkbox: M13Checkbox!) {
        self.onChange?(self.isChecked)
        self.bindee?.perform(self.bindeeSelector, with: NSNumber(booleanLiteral: self.isChecked))
    }

}
