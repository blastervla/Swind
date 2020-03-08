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

    /// Closure to be called when checkbox value changes, with the new value
    /// as an argument.
    /// - Note: This is an alternative to the usage of the `bind` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
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
    
    /// This function binds the view so that, when its value changes,
    /// it'll perform the given selector on the `bindee`.
    ///
    /// - Warning: no check will be made to see if the bindee can actually
    ///            perform the selector, so this might blow up if it can't.
    ///
    /// - Parameter bindee: The object that contains the `bindeeSeelctor`
    /// - Parameter bindeeSelector: Selector to be called on `bindee` upon change.
    ///                             It must receive an `NSNumber` argument, which will
    ///                             contain the new `Bool` value of the checkbox.
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.bindee = bindee
        self.bindeeSelector = bindeeSelector
    }
    
    @objc func checkboxChangedState(_ checkbox: M13Checkbox!) {
        self.onChange?(self.isChecked)
        self.bindee?.perform(self.bindeeSelector, with: NSNumber(booleanLiteral: self.isChecked))
    }

}
