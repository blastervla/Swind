//
//  BaseVM.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/3/20.
//  Copyright © 2020 Vladimir Pomsztein. All rights reserved.
//

open class BaseViewModel: NSObject {

    private var onChanges: [() -> Void] = []
    /// Closure to be setup on the `bind` method of the model's
    /// Binder. This will get called each time `notifyChange` is
    /// called on the ViewModel.
    public var onChange: (() -> Void)? {
        didSet {
            guard let onChange = self.onChange else {
                self.onChanges = []
                return
            }
            self.onChanges = [onChange]
        }
    }
    
    open func isSameAs(model: BaseViewModel) -> Bool {
        return self == model.self
    }
    
    static func == (lhs: BaseViewModel, rhs: BaseViewModel) -> Bool {
        return lhs.isSameAs(model: rhs)
    }
    
    public func addOnChangeHandler(_ addedOnChange: @escaping () -> Void) {
        self.onChanges += [addedOnChange]
    }
    
    /// Method to be called whenever a UI change should be impacted.
    /// Each call to this method will internally execute the `onChange`
    /// closure, so plan updates accordingly (by batch if possible) so
    /// as to avoid any performance penalties.
    public func notifyChange() {
        self.onChanges.forEach {
            $0()
        }
    }

}
