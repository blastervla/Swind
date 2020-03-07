//
//  BaseVM.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/3/20.
//  Copyright © 2020 Vladimir Pomsztein. All rights reserved.
//

open class BaseViewModel: NSObject {

    public var onChange: (() -> Void)?
    
    open func isSameAs(model: BaseViewModel) -> Bool {
        return self == model.self
    }
    
    public func notifyChange() {
        self.onChange?()
    }

}
