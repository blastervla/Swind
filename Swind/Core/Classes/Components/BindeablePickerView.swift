//
//  BindeablePickerView.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/4/20.
//

import UIKit

public class BindeablePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    /// Closure to be called when item is picked, with the picked item's
    /// `componentIndex` and `rowIndex` passed as arguments (in that order)
    /// - Note: This is an alternative to the usage of the `bind` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
    public var onPick: ((Int, Int) -> Void)? = nil
    
    var bindeeSelector: Selector?
    var bindee: NSObject?
    
    /// Actual values of the picker. Parent array represents components and
    /// should contain child arrays representing the rows of each component.
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
    
    /// This function binds the view so that, when a new item is picked,
    /// it'll perform the given selector on the `bindee`.
    ///
    /// - Warning: no check will be made to see if the bindee can actually
    ///            perform the selector, so this might blow up if it can't.
    ///
    /// - Parameter bindee: The object that contains the `bindeeSeelctor`
    /// - Parameter bindeeSelector: Selector to be called on `bindee` upon pick.
    ///                             It must receive two `NSNumber` arguments, which will
    ///                             contain the new `Int` values of the selected component
    ///                             and row (in that order).
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
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[component][row]
    }
}
