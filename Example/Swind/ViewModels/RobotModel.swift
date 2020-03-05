//
//  RobotModel.swift
//  Swind_Example
//
//  Created by Vladimir Pomsztein on 3/5/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Swind

class RobotModel: BaseVM {
    var name: String = ""
    var gender: String = ""
    var wantsToBeARealKid: Bool = false
    var strength: Float = 10
    var power: Float = 10
    var ai: Float = 10
    var specialAbilities: [SpecialAbilityModel] = []
    var personality: String = ""
    
    var nameErrorText: String {
        return name.isEmpty ? "Brrr... Brrr... Please setup a name for your robot..." : ""
    }
    
    var strengthText: String {
        return String(Int(strength))
    }
    var powerText: String {
        return String(Int(power))
    }
    var aiText: String {
        return String(Int(ai))
    }
    
    var genderValues: [[String]] = [["Robo-man", "Robo-woman"]]
    
    var observableSpecialAbilities: ObservableArray<SpecialAbilityModel> = []
    
    @objc func setName(_ name: String) {
        self.name = name
        self.notifyChange()
    }
    
    @objc func setGender(_ component: NSNumber, _ row: NSNumber) {
        self.gender = genderValues[component.intValue][row.intValue]
        self.notifyChange()
    }
    
    @objc func setWantsToBeARealKid(_ doesWant: NSNumber) {
        self.wantsToBeARealKid = doesWant.boolValue
    }
        
    @objc func setStrength(_ newStrength: NSNumber) {
        // Balance out points
        let diff = newStrength.floatValue - strength
        self.power -= diff / 2
        self.ai -= diff / 2
        
        // Minimum of 0
        self.power = max(0, self.power)
        self.ai = max(0, self.ai)
        
        // Set value
        self.strength = newStrength.floatValue
        
        notifyChange()
    }
    
    @objc func setPower(_ newPower: NSNumber) {
        // Balance out points
        let diff = newPower.floatValue - power
        self.strength -= diff / 2
        self.ai -= diff / 2
        
        // Minimum of 0
        self.strength = max(0, self.strength)
        self.ai = max(0, self.ai)
        
        // Set value
        self.power = newPower.floatValue
        
        notifyChange()
    }
    
    @objc func setAi(_ newAi: NSNumber) {
        // Balance out points
        let diff = newAi.floatValue - ai
        self.strength -= diff / 2
        self.power -= diff / 2
        
        // Minimum of 0
        self.strength = max(0, self.strength)
        self.power = max(0, self.power)
        
        // Set value
        self.ai = newAi.floatValue
        
        notifyChange()
    }
    
    @objc func addSpecialAbility() {
        self.observableSpecialAbilities.add(SpecialAbilityModel())
    }
    
    @objc func removeSpecialAbility() {
        self.observableSpecialAbilities.removeLast()
    }
    
    @objc func setPersonality(_ text: String) {
        self.personality = text
        self.notifyChange()
    }
    
    func update() -> RobotModel {
        self.specialAbilities = self.observableSpecialAbilities.elements.filter { !$0.specialAbilityText.isEmpty }
        return self
    }
}
