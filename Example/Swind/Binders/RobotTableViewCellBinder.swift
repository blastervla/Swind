//
//  RobotTableViewCellBinder.swift
//  Swind_Example
//
//  Created by Vladimir Pomsztein on 10/03/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Swind

class RobotTableViewCellBinder: BaseBinderProtocol {
    static func bind(parent: BaseViewProtocol, view: Any, viewModel: BaseViewModel) {
        guard let view = view as? RobotTableViewCell, let viewModel = viewModel as? RobotModel else { return }
        
        view.nameLabel.text = viewModel.name
        view.genderLabel.text = viewModel.gender
        view.personalityLabel.text = viewModel.personality
        view.strLabel.text = "Strength: \(viewModel.strengthText)"
        view.pwrLabel.text = "Power: \(viewModel.powerText)"
        view.aiLabel.text = "AI: \(viewModel.aiText)"
    }
}
