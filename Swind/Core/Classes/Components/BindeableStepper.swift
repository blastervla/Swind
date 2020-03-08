//
//  BindeableStepper.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/4/20.
//

import UIKit

public class BindeableStepper: UIStepper {

    /// Closure to be called when stepper value increases.
    public var onIncrease: ((Double) -> Void)? = nil
    
    /// Closure to be called when stepper value descreases.
    public var onDecrease: ((Double) -> Void)? = nil
    
    /// Closure to be called when stepper value changes (this handles both
    /// increases and decreases).
    /// - Note: This is an alternative to the usage of the `bind` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
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
    
    /// This function binds the view so that, when its value changes,
    /// it'll perform the given selector on the `bindee`.
    ///
    /// - Warning: no check will be made to see if the bindee can actually
    ///            perform the selector, so this might blow up if it can't.
    ///
    /// - Parameter bindee: The object that contains the `bindeeSeelctor`
    /// - Parameter bindeeSelector: Selector to be called on `bindee` upon change.
    ///                             It must receive an `NSNumber` argument, which will
    ///                             contain the new `Double` value of the stepper.
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
