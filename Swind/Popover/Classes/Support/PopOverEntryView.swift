//
//  PopOverEntryView.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 14/03/2020.
//

import UIKit

class PopOverEntryView: UIView {

    @IBOutlet weak var button: BindeableMDCFlatButton!

    override func awakeFromNib() {
        self.button.isUppercaseTitle = false
    }
    
}
