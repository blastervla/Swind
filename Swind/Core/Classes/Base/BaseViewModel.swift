//
//  BaseVM.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/3/20.
//  Copyright © 2020 Vladimir Pomsztein. All rights reserved.
//

protocol ParentAware {
    var parentNotify: (() -> Void)? { get set }
    var isFirstOrderKind: Bool { get }
}

open class BaseViewModel: NSObject, ParentAware {
    
    /// Enum depicting the Notification Cascade strategies
    public enum NotificationCascadeType {
        /// No child objects will report to this View Model when changes occur
        case none
        /// Only first order child objects will report to this View Model when changes occur.
        /// That is, only direct variables in the hierarchy (not embedded in Arrays or Dictionaries)
        case firstOrder
        /// All child BaseViewModel objects will notify its parent when changes are applied to them
        case all
    }
    
    private class ChangeEntryWeakReferenceWrapper {
        weak var view: AnyObject?
        
        init(view: AnyObject) {
            self.view = view
        }
    }
    
    private class ChangeEntry {
        var views: [ChangeEntryWeakReferenceWrapper] = []
        var onChangeClosure: () -> Void
        
        init(views: [AnyObject], onChangeClosure: @escaping () -> Void) {
            self.views = views.map { ChangeEntryWeakReferenceWrapper(view: $0) }
            self.onChangeClosure = onChangeClosure
        }
    }

    public var parentNotify: (() -> Void)?
    var isFirstOrderKind: Bool = true
    
    private var onChanges: [ChangeEntry] = []
    
    /// Method stating which objects should have Notification Cascading.
    ///
    /// - Note: All objects stated here should be declared as `@objc dynamic`
    open func notificationCascadeObjects() -> [String] {
        return []
    }
    
    public override init() {
        super.init()
        
        let mirror = Mirror(reflecting: self)
        let notificationCascadeObjs = self.notificationCascadeObjects()
        
        for child in mirror.children {
            if let key = child.label, notificationCascadeObjs.contains(key), var model = child.value as? ParentAware {
                model.parentNotify = { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.notifyChange()
                }
                self.setValue(model, forKey: key)
            }
        }
    }
    
    open func isSameAs(model: BaseViewModel) -> Bool {
        return self == model.self
    }
    
    static func == (lhs: BaseViewModel, rhs: BaseViewModel) -> Bool {
        return lhs.isSameAs(model: rhs)
    }
    
    /// Method to setup bindings for the view.
    ///
    /// - Parameter view: View in which bindings will be executed
    ///
    /// - Parameter onChange: Closure to be setup on the `bind`
    ///                       method of the model's Binder. This
    ///                       will get called each time `notifyChange`
    ///                       is called on the ViewModel.
    ///
    public func onChange(_ view: AnyObject, _ onChange: @escaping () -> Void) {
        self.onChanges += [ChangeEntry(views: [view], onChangeClosure: onChange)]
    }
    
    /// Method to setup bindings for the views.
    ///
    /// - Parameter views: Views in which bindings will be executed
    ///
    /// - Parameter onChange: Closure to be setup on the `bind`
    ///                       method of the model's Binder. This
    ///                       will get called each time `notifyChange`
    ///                       is called on the ViewModel.
    ///
    public func onChange(_ views: [AnyObject], _ onChange: @escaping () -> Void) {
        self.onChanges += [ChangeEntry(views: views, onChangeClosure: onChange)]
    }
    
    /// Method to remove all previous bindings
    ///
    /// - Note: You most probably want to call this when binding
    ///         views that will be recycled
    public func removeAllBindings() {
        self.onChanges = []
    }
    
    /// Method to be called whenever a UI change should be impacted.
    /// Each call to this method will internally execute the `onChange`
    /// closures, so plan updates accordingly (by batch if possible) so
    /// as to avoid any performance penalties.
    public func notifyChange() {
        var toRemove = [Int]()
        
        parentNotify?()
        for i in 0..<self.onChanges.count {
            let onChange = self.onChanges[i]
            if onChange.views.allSatisfy({ $0.view == nil }) {
                toRemove += [i]
            }
            
            onChange.onChangeClosure() // Execute bindings
        }
        
        // Cleanup unused closures
        for i in stride(from: toRemove.count - 1, through: 0, by: -1) {
            self.onChanges.remove(at: toRemove[i])
        }
    }

}
