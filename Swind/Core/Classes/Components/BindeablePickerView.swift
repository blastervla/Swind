//
//  BindeablePickerView.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/4/20.
//

import UIKit

public class BindeablePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    /// Handler to be called when item is picked, with the picked item's `componentIndex` and `rowIndex` as arguments
    public var onPick: ((Int, Int) -> Void)? = nil
    var bindeeSelector: Selector?
    var bindee: NSObject?
    public var values: [[String]] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
    }
    
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.bindee = bindee
        self.bindeeSelector = bindeeSelector
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.onPick?(component, row)
        self.bindee?.perform(self.bindeeSelector, with: NSNumber(value: component), with: NSNumber(value: row))
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return values.count // number of session
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.values[component].count
        
//        var iterator = values.makeIterator()
//        for _ in 0 ..< component {
//            _ = iterator.next()
//        }
//        return iterator.next()?.value.count ?? 0 // number of dropdown items
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[component][row]
//        var iterator = values.makeIterator()
//        for _ in 0 ..< row {
//            _ = iterator.next()
//        }
//        return iterator.next()?.value[component]
    }
}
