//
//  SpecialAbilityBinder.swift
//  Swind_Example
//
//  Created by Vladimir Pomsztein on 3/5/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Swind

class SpecialAbilityBinder: BaseBinderProtocol {
    static func bind(parent: Any, view: Any, viewModel: BaseViewModel) {
        guard let view = view as? RobotSpecialAbilityLayout, let viewModel = viewModel as? SpecialAbilityModel else { return }
        
        view.specialAbilityTextField.bind(viewModel, #selector(viewModel.setSpecialAbility))
        view.activePassiveSegmentControl.bind(viewModel, #selector(viewModel.setType))
        
        view.specialAbilityTextField.text = viewModel.specialAbilityText
        view.activePassiveSegmentControl.selectedSegmentIndex = viewModel.type.rawValue
    }
}
