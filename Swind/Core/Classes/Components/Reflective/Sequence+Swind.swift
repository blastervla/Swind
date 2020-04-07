//
//  Sequence+Swind.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 4/6/20.
//

import UIKit

extension Array: ParentAware {
    @nonobjc static private var swindParentNotifyConstant: String {
        get { "swind_parentNotify" }
        set {  }
    }
    var parentNotify: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &Array.swindParentNotifyConstant) as? (() -> Void)
        }
        set {
            objc_setAssociatedObject(self, &Array.swindParentNotifyConstant, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var isFirstOrderKind: Bool {
        return false
    }
    
    /// Use this method to add elements in a way that the Swind framework
    /// can cascade notifications.
    public mutating func swind_add(_ newElement: __owned Element) {
        self.append(newElement)
        if var model = newElement as? ParentAware {
            model.parentNotify = self.parentNotify
        }
    }
    
    /// Use this method to add elements in a way that the Swind framework
    /// can cascade notifications.
    public mutating func swind_addAll(_ elems: [Element]) {
        self.append(contentsOf: elems)
        elems.forEach {
            if var model = $0 as? ParentAware {
                model.parentNotify = self.parentNotify
            }
        }
    }
    
    /// Use this method to add elements in a way that the Swind framework
    /// can cascade notifications.
    public mutating func swind_insert(_ newElement: __owned Element, at i: Int) {
        self.insert(newElement, at: i)
        if var model = newElement as? ParentAware {
            model.parentNotify = self.parentNotify
        }
    }
    
    /// Swind wrapper for the `removeAll` Swift method.
    /// Use this method to remove elements in a way that the Swind framework
    /// can cascade notifications.
    @discardableResult
    mutating func swind_removeAll(where condition: (Element) -> Bool) -> [Element] {
        self.removeAll(where: condition)
        self.parentNotify?()
        return self
    }
    
    /// Swind wrapper for the `remove(at:)` Swift method.
    /// Use this method to remove elements in a way that the Swind framework
    /// can cascade notifications.
    @discardableResult
    mutating func swind_remove(at i: Int) -> Element {
        let elem = self.remove(at: i)
        self.parentNotify?()
        return elem
    }
}

extension Array where Element : Equatable {
    /// Removes the passed item from the array, if it is included.
    /// Use this method to remove elements in a way that the Swind framework
    /// can cascade notifications.
    @discardableResult
    mutating func swind_remove(_ item: Element) -> [Element] {
        self.swind_removeAll(where: { $0 == item })
        self.parentNotify?()
        return self
    }
}
