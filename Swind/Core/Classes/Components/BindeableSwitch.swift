//
//  BindeableSwitch.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/4/20.
//

import UIKit

public class BindeableSwitch: UISwitch {

    public var onChange: ((Bool) -> Void)? = nil
    var bindeeSelector: Selector?
    var bindee: NSObject?
    
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
    
    @objc func checkboxChangedState(_ switch: UISwitch!) {
        self.onChange?(self.isOn)
        self.bindee?.perform(self.bindeeSelector, with: NSNumber(booleanLiteral: self.isOn))
    }

}
