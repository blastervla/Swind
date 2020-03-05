//
//  BaseBinder.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/3/20.
//  Copyright © 2020 Vladimir Pomsztein. All rights reserved.
//

public protocol BaseBinderProtocol {
    static func bind(parent: Any, view: Any, viewModel: BaseVM)
}
