//
//  RobotTableAdapter.swift
//  Swind_Example
//
//  Created by Vladimir Pomsztein on 10/03/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Swind

class RobotTableAdapter: BaseViewModelTableDataSource, BaseViewProtocol, BaseViewModelTableAdapterProtocol {
    
    var parent: BaseViewProtocol? = nil
    
    override init() {
        super.init()
        self.adapter = self
    }
    
    /// Method that should return the ViewModel for the given position of the
    /// TableView.
    func getViewModelForPosition(_ indexPath: IndexPath) -> BaseViewModel {
        switch indexPath.row {
        case 0:
            return {
                let model = RobotModel()
                model.name = "Mazinger Z"
                model.personality = "A bit japanese-like, but hey, that's pretty rad! 😎"
                model.gender = model.genderValues[0][0]
                model.strength = 12
                model.power = 12
                model.ai = 6
                return model
            }()
        case 1:
            return {
                let model = RobotModel()
                model.name = "W.A.L.L.E"
                model.personality = "Looking for a trash 🗑 robot? Then here I go!"
                model.gender = model.genderValues[0][0]
                model.strength = 5
                model.power = 3
                model.ai = 22
                return model
                }()
        case 2:
            return {
                let model = RobotModel()
                model.name = "Astro Boy"
                model.personality = "A robo-child, but quite powerful 👊🏻💥"
                model.gender = model.genderValues[0][0]
                model.strength = 8
                model.power = 10
                model.ai = 12
                return model
                }()
        case 3:
            return {
                let model = RobotModel()
                model.name = "Android 18"
                model.personality = "Not really a robot, but meh, who cares right?"
                model.gender = model.genderValues[0][1]
                model.strength = 11
                model.power = 12
                model.ai = 7
                return model
                }()
        default:
            return {
                let model = RobotModel()
                model.name = "Baymax"
                model.personality = "White and fluffy, this robot is like hanging out with a marshmello"
                model.gender = model.genderValues[0][0]
                model.strength = 5
                model.power = 5
                model.ai = 20
                return model
                }()
        }
    }
    
    /// Method that should return the Binder for the view at the given position of the
    /// TableView.
    func getBinderForModel(_ model: BaseViewModel) -> BaseBinderProtocol.Type {
        switch model {
        case is RobotModel:
            return RobotTableViewCellBinder.self
        default:
            return RobotTableViewCellBinder.self // Should never get here
        }
    }
    
    func getReuseId(_ model: BaseViewModel) -> String {
        return String(describing: type(of: model.self))
    }
    
    /// Method that should return the parent of all views (usually the ViewController)
    func getParent() -> BaseViewProtocol {
        return parent ?? self
    }
    
    /// Method that should return the amount of rows for the table
    func getRowAmount(for section: Int) -> Int {
        return 5
    }
    
    func getSectionAmount() -> Int {
        return 1
    }
}
