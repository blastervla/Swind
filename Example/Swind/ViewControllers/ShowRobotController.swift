//
//  ShowRobotController.swift
//  Swind_Example
//
//  Created by Vladimir Pomsztein on 3/7/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Swind

class ShowRobotController: UIViewController, BaseViewProtocol {

    @IBOutlet weak var label: UILabel!
    
    var viewModel: RobotModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewModel = viewModel {
            ShowRobotBinder.bind(parent: self, view: self, viewModel: viewModel)
        }
    }

    func setRobot(_ viewModel: RobotModel) {
        self.viewModel = viewModel
    }

    
}
