//
//  BaseVM.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/3/20.
//  Copyright © 2020 Vladimir Pomsztein. All rights reserved.
//

open class BaseViewModel: NSObject {

    /// Closure to be setup on the `bind` method of the model's
    /// Binder. This will get called each time `notifyChange` is
    /// called on the ViewModel.
    public var onChange: (() -> Void)?
    
    open func isSameAs(model: BaseViewModel) -> Bool {
        return self == model.self
    }
    
    static func == (lhs: BaseViewModel, rhs: BaseViewModel) -> Bool {
        return lhs.isSameAs(model: rhs)
    }
    
    /// Method to be called whenever a UI change should be impacted.
    /// Each call to this method will internally execute the `onChange`
    /// closure, so plan updates accordingly (by batch if possible) so
    /// as to avoid any performance penalties.
    public func notifyChange() {
        self.onChange?()
    }

}
