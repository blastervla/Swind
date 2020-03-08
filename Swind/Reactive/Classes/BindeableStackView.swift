//
//  BindeableStackView.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/3/20.
//  Copyright © 2020 Vladimir Pomsztein. All rights reserved.
//

import UIKit

public class BindeableStackView: UIStackView {

    var nibName: String = ""
    var bundle: Bundle?
    var binder: BaseBinderProtocol.Type?
    
    /// This function binds the view so that, when the entries change,
    /// it'll automatically update its contents so as to reflect the data
    /// represented in the `entries` array by using the other method parameters.
    ///
    /// - Warning: Should any problem arise when trying to load the nib, the view
    ///            contents _will_ remain empty. This doesn't apply to Outlet issues.
    ///
    /// - Parameter entries: The actual entries containing the data that should be
    ///                      reflected on the StackView content.
    /// - Parameter parent: Parent object of this view and its potential subviews,
    ///                     will be used when executing the bindings for each entry.
    /// - Parameter layoutNibName: Nib name that'll be used to represent each entry.
    /// - Parameter bundle: `Bundle` to be used to load the nib with its `layoutNibName`
    /// - Parameter binder: `Binder` type that will be used to bind each entry with its view
    public func bind<T: BaseViewModel>(_ entries: ObservableArray<T>, parent: Any, layoutNibName nibName: String, bundle: Bundle, binder: BaseBinderProtocol.Type) {
        self.nibName = nibName
        self.bundle = bundle
        self.binder = binder
        var entries = entries
        
        _ = entries.rx_elements().subscribe(onNext: { [weak self] (array) in
            guard let strongSelf = self else { return }
            strongSelf.updateView(array, parent: parent)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.updateView(entries.elements, parent: parent)
    }
    
    private func updateView<T: BaseViewModel>(_ elements: [T], parent: Any) {
        self.swind_removeAllArrangedSubviews()
        
        elements.forEach { viewModel in
            let view = self.bundle?.loadNibNamed(self.nibName, owner: self, options: nil)?.first as? UIView
            
            if let view = view {
                self.addArrangedSubview(view)
                self.binder?.bind(parent: parent, view: view, viewModel: viewModel)
            }
        }
    }

}
