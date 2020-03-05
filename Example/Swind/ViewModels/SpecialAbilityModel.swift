//
//  SpecialAbilityModel.swift
//  Swind_Example
//
//  Created by Vladimir Pomsztein on 3/5/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Swind

class SpecialAbilityModel: BaseVM {
    var specialAbilityText: String = ""
    var type: SpecialAbilityType = .active
    
    @objc func setSpecialAbility(_ text: String) {
        self.specialAbilityText = text
    }
    
    @objc func setType(_ type: NSNumber) {
        self.type = SpecialAbilityType.fromNumber(type)
    }
    
    enum SpecialAbilityType: Int, CaseIterable {
        case active = 0
        case passive = 1
        
        static func fromNumber(_ number: NSNumber) -> SpecialAbilityType {
            if number.intValue == 0 {
                return .active
            } else {
                return .passive
            }
        }
    }
}
