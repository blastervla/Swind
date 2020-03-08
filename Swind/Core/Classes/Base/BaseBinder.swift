//
//  BaseBinder.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/3/20.
//  Copyright © 2020 Vladimir Pomsztein. All rights reserved.
//

public protocol BaseBinderProtocol {
    /// Method created for the sole purpose of executing all view bindings.
    static func bind(parent: Any, view: Any, viewModel: BaseViewModel)
}
