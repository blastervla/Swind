//
//  BindeableMDCCard.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 07/03/2020.
//

import UIKit
import MaterialComponents

public class BindeableMDCCard: MDCCard {

    public var onTap: (() -> Void)? = nil
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
    
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.tapBindee = bindee
        self.tapBindeeSelector = bindeeSelector
    }
    
    public func bindForLongTap(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.longTapBindee = bindee
        self.longTapBindeeSelector = bindeeSelector
    }
    
    @objc func didTap(sender: UIButton) {
        self.onTap?()
        self.tapBindee?.perform(self.tapBindeeSelector)
    }
    
    @objc func didLongTap(sender: UIButton) {
        self.onLongTap?()
        self.longTapBindee?.perform(self.longTapBindeeSelector)
    }

}
