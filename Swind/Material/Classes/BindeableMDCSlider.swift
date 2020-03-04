//
//  BindeableMDCSlider.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/4/20.
//

import UIKit
import MaterialComponents

class BindeableMDCSlider: MDCSlider {

    /// Handler to be called when value changes, receiving the new `value`
    var onValueChanged: ((Float) -> Void)? = nil
    var bindeeSelector: Selector?
    var bindee: NSObject?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.bindee = bindee
        self.bindeeSelector = bindeeSelector
    }
    
    @objc func sliderValueChanged(slider: UISlider) {
        self.onValueChanged?(Float(self.value))
        self.bindee?.perform(self.bindeeSelector, with: NSNumber(value: Float(self.value)))
    }

}
