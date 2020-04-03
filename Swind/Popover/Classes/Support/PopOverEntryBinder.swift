//
//  PopOverEntryBinder.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 14/03/2020.
//

import UIKit

class PopOverEntryBinder: BaseBinderProtocol {
    static func bind(parent: BaseViewProtocol, view: Any, viewModel: BaseViewModel) {
        guard let view = view as? PopOverEntryView, let viewModel = viewModel as? PopOverEntryModel else { return }
        
        view.button.onTap = {
            parent.onClick?(view.button, viewModel)
        }
        
        viewModel.onChange(view) { [weak view] in
            guard let view = view else { return }
            view.button.setTitle(viewModel.text, for: .normal)
        }
        viewModel.notifyChange()
    }
    

}
