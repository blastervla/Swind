//
//  RobotBinder.swift
//  Swind_Example
//
//  Created by Vladimir Pomsztein on 3/5/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Swind

class RobotBinder: BaseBinderProtocol {
    static func bind(parent: BaseViewProtocol, view: Any, viewModel: BaseViewModel) {
        guard let view = view as? ViewController, let viewModel = viewModel as? RobotModel else { return }
        
        view.nameTextField.bind(viewModel, #selector(viewModel.setName))
        
        view.genderPickerView.bind(viewModel, #selector(viewModel.setGender))
        view.realKidSwitch.bind(viewModel, #selector(viewModel.setWantsToBeARealKid))
        
        view.strengthSlider.bind(viewModel, #selector(viewModel.setStrength))
        view.powerSlider.bind(viewModel, #selector(viewModel.setPower))
        view.aiSlider.bind(viewModel, #selector(viewModel.setAi))
        view.specialAbilitiesStepper.onIncrease = { _ in
            viewModel.addSpecialAbility()
        }
        view.specialAbilitiesStepper.onDecrease = { _ in
            viewModel.removeSpecialAbility()
        }
        view.specialAbilitiesContainer.bind(viewModel.observableSpecialAbilities, parent: parent, layoutNibName: String(describing: RobotSpecialAbilityLayout.self), bundle: .init(for: self), binder: SpecialAbilityBinder.self)
        view.personalityTextView.bind(viewModel, #selector(viewModel.setPersonality))
        
        viewModel.onChange = {
            view.nameErrorLabel.text = viewModel.nameErrorText
            view.genderTextField.text = viewModel.gender
            view.strengthScoreLabel.text = viewModel.strengthText
            view.powerScoreLabel.text = viewModel.powerText
            view.aiScoreLabel.text = viewModel.aiText
            
            view.strengthSlider.value = viewModel.strength
            view.powerSlider.value = viewModel.power
            view.aiSlider.value = viewModel.ai
        }
        
        viewModel.notifyChange()
    }
}
