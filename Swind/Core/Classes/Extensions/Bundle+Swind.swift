//
//  Bundle+Swind.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 24/03/2020.
//

import UIKit

public extension Bundle {
    static func swindBundle() -> Bundle? {
        guard let url = Bundle.init(for: BindeableBottomSheet.self).url(forResource: "SwindCore", withExtension: "bundle") else { return nil }
        
        return Bundle(url: url)
    }
}
