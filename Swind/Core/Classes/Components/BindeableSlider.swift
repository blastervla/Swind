//
//  BindeableSlider.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/3/20.
//

import UIKit

public class BindeableSlider: UISlider {

    /// Handler to be called when value changes, receiving the new `value`
    public var onValueChanged: ((Float) -> Void)? = nil
    var bindeeSelector: Selector?
    var bindee: NSObject?
    var lastValue: Float = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.lastValue = self.value
        self.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.lastValue = self.value
        self.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.bindee = bindee
        self.bindeeSelector = bindeeSelector
    }
    
    @objc func sliderValueChanged(slider: UISlider) {
        if self.value != self.lastValue {
            self.lastValue = self.value
        }
        self.onValueChanged?(self.value)
        self.bindee?.perform(self.bindeeSelector, with: NSNumber(value: self.value))
    }

}
