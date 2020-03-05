//
//  BindeableStepper.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/4/20.
//

import UIKit

public class BindeableStepper: UIStepper {

    public var onIncrease: ((Double) -> Void)? = nil
    public var onDecrease: ((Double) -> Void)? = nil
    public var onChange: ((Double) -> Void)? = nil
    var bindeeSelector: Selector?
    var bindee: NSObject?
    
    var previousValue: Double = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.previousValue = self.value
        self.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.previousValue = self.value
        self.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
    }
    
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.bindee = bindee
        self.bindeeSelector = bindeeSelector
    }
    
    @objc func stepperValueChanged(sender: UIStepper) {
        let didIncrease = self.previousValue < self.value
        self.previousValue = self.value
        
        self.onChange?(self.value)
        if didIncrease {
            self.onIncrease?(self.value)
        } else {
            self.onDecrease?(self.value)
        }
        self.bindee?.perform(self.bindeeSelector, with: NSNumber(value: self.value))
    }

}
