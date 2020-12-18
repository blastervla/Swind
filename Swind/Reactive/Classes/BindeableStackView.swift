//
//  BindeableStackView.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/3/20.
//  Copyright © 2020 Vladimir Pomsztein. All rights reserved.
//

import UIKit

class BindeableStackView: UIStackView {

    var nibName: String = ""
    var bundle: Bundle?
    var binder: BaseBinderProtocol.Type?
    
    public func bind<T: BaseVM>(_ entries: ObservableArray<T>, parent: Any, layoutNibName nibName: String, bundle: Bundle, binder: BaseBinderProtocol.Type) {
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
    
    private func updateView<T: BaseVM>(_ elements: [T], parent: Any) {
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
