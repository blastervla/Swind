//
//  BaseViewProtocol.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/7/20.
//

import UIKit

@objc public protocol BaseViewProtocol {
    @objc optional func onClick(_ v: UIView, _ viewModel: BaseViewModel)
    @objc optional func onLongClick(_ v: UIView, _ viewModel: BaseViewModel) -> Bool
    @objc optional func onAnyLongClick(_ v: UIView, _ any: Any) -> Bool
    @objc optional func onAnyClick(_ v: UIView, _ any: Any)
}
