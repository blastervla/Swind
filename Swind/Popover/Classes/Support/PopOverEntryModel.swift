//
//  PopOverEntryModel.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 14/03/2020.
//

import UIKit

public class PopOverEntryModel: BaseViewModel {
    public let popOverId: String
    public let entryId: String
    public let text: String
    public let associatedViewModel: BaseViewModel?
    
    init(popOverId: String, entryId: String, text: String, associatedViewModel: BaseViewModel?) {
        self.popOverId = popOverId
        self.entryId = entryId
        self.text = text
        self.associatedViewModel = associatedViewModel
    }
}
