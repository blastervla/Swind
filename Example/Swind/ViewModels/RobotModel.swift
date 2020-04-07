//
//  RobotModel.swift
//  Swind_Example
//
//  Created by Vladimir Pomsztein on 3/5/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Swind

class RobotModel: BaseViewModel {
    override var notificationCascadeType: BaseViewModel.NotificationCascadeType {
        get { return .all }
        set {}
    }
    
    var name: String = ""
    var gender: String = ""
    var wantsToBeARealKid: Bool = false
    var strength: Float = 10
    var power: Float = 10
    var ai: Float = 10
    var specialAbilities: [SpecialAbilityModel] = []
    var personality: String = ""
    
    var nameErrorText: String = ""
    
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
    
    override init() {
        self.gender = genderValues[0][0]
    }
    
    @objc func setName(_ name: String) {
        self.name = name
        if !name.isEmpty {
            self.nameErrorText = ""
        }
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
//        while diff > 0 {
//            var pointsTaken: Float = 0
//            if self.power > 0 {
//                self.power -= 1
//                pointsTaken += 1
//            }
//            if self.ai > 0 {
//                self.ai -= 1
//                pointsTaken += 1
//            }
//            if self.power > 2 - pointsTaken {
//                self.power -= 2 - pointsTaken
//            } else if self.ai > 2 - pointsTaken {
//                self.ai -= 2 - pointsTaken
//            } else {
//                self.strength -= 2 - pointsTaken
//            }
//            diff -= 2
//        }
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
    
    func validate() -> Bool {
        self.nameErrorText = self.name.isEmpty ? "Brrr... Brrr... Please setup a name for your robot..." : ""
        notifyChange()
        
        return !self.name.isEmpty
    }
    
    func update() -> RobotModel {
        self.specialAbilities = self.observableSpecialAbilities.elements.filter { !$0.specialAbilityText.isEmpty }
        return self
    }
    
    func toString() -> String {
        return """
        Buzz... buzz...
        
        My name is \(name).
        I'm a \(gender) that \(self.wantsToBeARealKid ? "wants" : "doesn't want") to be a real kid.
        
        My stats are:
        Strength: \(Int(strength))
        Power: \(Int(power))
        AI: \(Int(ai))
        
        So... FEAR ME!
        
        Also, I have the following special abilities:
        \(specialAbilities.map { "- \($0.type.toString()): \($0.specialAbilityText)" }.joined(separator: "\n"))
        
        As for my personality...
        \(personality)
        
        Douzo yoroshiku!
        """
    }
}
