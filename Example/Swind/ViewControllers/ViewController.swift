//
//  ViewController.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 03/03/2020.
//  Copyright (c) 2020 Vladimir Pomsztein. All rights reserved.
//

import UIKit
import Swind

class ViewController: UIViewController, BaseViewProtocol {

    @IBOutlet weak var nameTextField: BindeableTextField!
    @IBOutlet weak var nameErrorLabel: BindeableLabel!
    
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var realKidSwitch: BindeableSwitch!
    
    @IBOutlet weak var strengthSlider: BindeableSlider!
    @IBOutlet weak var strengthScoreLabel: UILabel!
    @IBOutlet weak var powerSlider: BindeableSlider!
    @IBOutlet weak var powerScoreLabel: UILabel!
    @IBOutlet weak var aiSlider: BindeableSlider!
    @IBOutlet weak var aiScoreLabel: UILabel!
    
    @IBOutlet weak var specialAbilitiesStepper: BindeableStepper!
    @IBOutlet weak var specialAbilitiesContainer: BindeableStackView!
    
    @IBOutlet weak var personalityTextView: BindeableTextView!
    
    let genderPickerView = BindeablePickerView()
    
    let viewModel: RobotModel = RobotModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePickerView()
        getBinder().bind(parent: self, view: self, viewModel: viewModel)
    }
    
    func getBinder() -> BaseBinderProtocol.Type {
        return RobotBinder.self
    }

    func configurePickerView() {
        self.genderTextField.inputView = genderPickerView
        self.genderPickerView.values = viewModel.genderValues
    }
    
    override var inputAccessoryView: UIView? {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.endEdittingPicker))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return false
    }

    @objc func endEdittingPicker() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ShowRobotController, segue.identifier == "ShowRobotSegue" {
            destinationVC.setRobot(self.viewModel.update())
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ShowRobotSegue" {
            return viewModel.validate()
        }
        return true
    }
}

