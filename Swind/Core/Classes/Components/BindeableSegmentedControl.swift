//
//  BindeableSegmentedControl.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/3/20.
//  Copyright © 2020 Vladimir Pomsztein. All rights reserved.
//

import UIKit

public class BindeableSegmentedControl: UISegmentedControl {

    /// Closure to be called when segment gets changed, with the picked
    /// segment index as an argument.
    /// - Note: This is an alternative to the usage of the `bind` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
    public var onSegmentChanged: ((Int) -> Void)? = nil
    
    var bindeeSelector: Selector?
    var bindee: NSObject?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
    }
    
    /// This function binds the view so that, when the segment gets changed,
    /// it'll perform the given selector on the `bindee`.
    ///
    /// - Warning: no check will be made to see if the bindee can actually
    ///            perform the selector, so this might blow up if it can't.
    ///
    /// - Parameter bindee: The object that contains the `bindeeSeelctor`
    /// - Parameter bindeeSelector: Selector to be called on `bindee` upon change.
    ///                             It must receive an `NSNumber` argument, which will
    ///                             contain the new `Int` selectedSegmentIndex of the control.
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.bindee = bindee
        self.bindeeSelector = bindeeSelector
    }
    
    @objc func didChangeSegment(sender: UISegmentedControl) {
        self.onSegmentChanged?(self.selectedSegmentIndex)
        self.bindee?.perform(self.bindeeSelector, with: NSNumber(value: self.selectedSegmentIndex))
    }

}
