//
//  SwindWeakReferenceWrapper.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 4/2/20.
//

import UIKit

class SwindWeakReferenceWrapper: NSObject {
    public weak var obj: NSObject?
    
    init(_ obj: NSObject) {
        self.obj = obj
    }
}
