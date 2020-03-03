//
//  BindeableSegmentedControl.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/3/20.
//  Copyright © 2020 Vladimir Pomsztein. All rights reserved.
//

import UIKit

class BindeableSegmentedControl: UISegmentedControl {

    var onSegmentChanged: ((Int) -> Void)? = nil
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
    
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.bindee = bindee
        self.bindeeSelector = bindeeSelector
    }
    
    @objc func didChangeSegment(sender: UISegmentedControl) {
        self.onSegmentChanged?(self.selectedSegmentIndex)
        self.bindee?.perform(self.bindeeSelector, with: NSNumber(value: self.selectedSegmentIndex))
    }

}
