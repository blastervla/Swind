//
//  BindeableLabel.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 07/03/2020.
//

import UIKit

public class BindeableLabel: UILabel {

    /// Closure to be called when button gets tapped.
    /// - Note: This is an alternative to the usage of the `bind` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
    public var onTap: (() -> Void)? = nil
    
    /// Closure to be called when button gets long tapped (ie: long-pressed).
    /// - Note: This is an alternative to the usage of the `bindForLongTap` method,
    ///         but not mutually exclusive. This means that you can use
    ///         whichever method you like to create the binding, or even
    ///         both, none will be ignored (ie: if you setup both, you'll
    ///         actually receive both callbacks).
    public var onLongTap: (() -> Void)? = nil
    
    var tapBindeeSelector: Selector?
    var tapBindee: NSObject?
    var longTapBindeeSelector: Selector?
    var longTapBindee: NSObject?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupGestureRecognizers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongTap))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(singleTap)
        self.addGestureRecognizer(longPress)
    }
    
    /// This function binds the view so that, when it gets tapped,
    /// it'll perform the given selector on the `bindee`.
    ///
    /// - Warning: no check will be made to see if the bindee can actually
    ///            perform the selector, so this might blow up if it can't.
    ///
    /// - Parameter bindee: The object that contains the `bindeeSeelctor`
    /// - Parameter bindeeSelector: Selector to be called on `bindee` upon tap.
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.tapBindee = bindee
        self.tapBindeeSelector = bindeeSelector
    }
    
    /// This function binds the view so that, when it gets long tapped (ie: long-pressed),
    /// it'll perform the given selector on the `bindee`.
    ///
    /// - Warning: no check will be made to see if the bindee can actually
    ///            perform the selector, so this might blow up if it can't.
    ///
    /// - Parameter bindee: The object that contains the `bindeeSeelctor`
    /// - Parameter bindeeSelector: Selector to be called on `bindee` upon long tap.
    public func bindForLongTap(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.longTapBindee = bindee
        self.longTapBindeeSelector = bindeeSelector
    }
    
    @objc func didTap(sender: UILabel) {
        self.onTap?()
        self.tapBindee?.perform(self.tapBindeeSelector)
    }
    
    @objc func didLongTap(sender: UILabel) {
        self.onLongTap?()
        self.longTapBindee?.perform(self.longTapBindeeSelector)
    }

}
