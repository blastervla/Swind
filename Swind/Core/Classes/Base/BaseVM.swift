//
//  BaseVM.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/3/20.
//  Copyright © 2020 Vladimir Pomsztein. All rights reserved.
//

class BaseVM: NSObject {

    public var onChange: (() -> Void)?
    
    open func isSameAs(model: BaseVM) -> Bool {
        return self == model.self
    }
    
    func notifyChange() {
        self.onChange?()
    }

}
