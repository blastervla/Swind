//
//  BindeablePickerView.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/4/20.
//

import UIKit

class BindeablePickerView: UIPickerView, UIPickerViewDelegate {

    /// Handler to be called when item is picked, with the picked item's `index` and its component `index` as arguments
    var onPick: ((Int, Int) -> Void)? = nil
    var bindeeSelector: Selector?
    var bindee: NSObject?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.bindee = bindee
        self.bindeeSelector = bindeeSelector
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.onPick?(row, component)
        self.bindee?.perform(self.bindeeSelector, with: NSNumber(value: row), with: NSNumber(value: component))
    }

}
