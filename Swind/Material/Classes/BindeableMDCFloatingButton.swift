//
//  BindeableMDCFloatingButton.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/4/20.
//

import UIKit
import MaterialComponents

public class BindeableMDCFloatingButton: MDCFloatingButton {

    public var onTap: (() -> Void)? = nil
    var bindeeSelector: Selector?
    var bindee: NSObject?
    
    override init(frame: CGRect, shape: MDCFloatingButtonShape) {
        super.init(frame: frame, shape: shape)
        self.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.bindee = bindee
        self.bindeeSelector = bindeeSelector
    }
    
    @objc func didTap(sender: UIButton) {
        self.onTap?()
        self.bindee?.perform(self.bindeeSelector)
    }

}
