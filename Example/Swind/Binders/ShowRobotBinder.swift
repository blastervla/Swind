//
//  ShowRobotBinder.swift
//  Swind_Example
//
//  Created by Vladimir Pomsztein on 3/7/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Swind

class ShowRobotBinder: BaseBinderProtocol {
    static func bind(parent: BaseViewProtocol, view: Any, viewModel: BaseViewModel) {
        guard let view = view as? ShowRobotController, let viewModel = viewModel as? RobotModel else { return }
        
        viewModel.onChange(view) { [weak view] in
            guard let view = view else { return }
            view.label.text = viewModel.toString()
        }
        viewModel.notifyChange()
    }
}
