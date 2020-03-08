//
//  BindeableMDCSlider.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/4/20.
//

import UIKit
import MaterialComponents

public class BindeableMDCSlider: MDCSlider {

    /// Closure to be called when value gets changed, with the new value
    /// as an argument.
    /// - Note: This is an alternative to the usage of the `bind` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
    public var onValueChanged: ((Float) -> Void)? = nil
    
    /// Wrapper provided to use value as a Swift `Float` instead of `CGFloat`.
    /// This maps to the field `value` of the original value
    public var floatValue: Float {
        get {
            return Float(self.value)
        }
        set(value) {
            self.value = CGFloat(value)
        }
    }
    
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
    
    /// This function binds the view so that, when its value changes,
    /// it'll perform the given selector on the `bindee`.
    ///
    /// - Warning: no check will be made to see if the bindee can actually
    ///            perform the selector, so this might blow up if it can't.
    ///
    /// - Note: Please ensure this view gets proper width size in accordance with
    ///         its possible value size (ie: its value span) in order to get a
    ///         smooth sliding performance.
    ///
    /// - Parameter bindee: The object that contains the `bindeeSeelctor`
    /// - Parameter bindeeSelector: Selector to be called on `bindee` upon change.
    ///                             It must receive an `NSNumber` argument, which will
    ///                             contain the new `Float` value of the slider.
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.bindee = bindee
        self.bindeeSelector = bindeeSelector
    }
    
    @objc func sliderValueChanged(slider: UISlider) {
        self.onValueChanged?(Float(self.value))
        self.bindee?.perform(self.bindeeSelector, with: NSNumber(value: Float(self.value)))
    }

}
