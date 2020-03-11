//
//  BaseViewModelTableAdapterProtocol.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 10/03/2020.
//

import UIKit

public protocol BaseViewModelTableAdapterProtocol {
    /// Method that should return the ViewModel for the given position of the
    /// TableView.
    func getViewModelForPosition(_ indexPath: IndexPath) -> BaseViewModel
    
    /// Method that should return the Binder for the view at the given position of the
    /// TableView.
    func getBinderForModel(_ model: BaseViewModel) -> BaseBinderProtocol.Type
    
    /// Method that should return the parent of all views (usually the ViewController)
    func getParent() -> BaseViewProtocol
    
    /// Method that should return the amount of sections of the table
    func getSectionAmount() -> Int
    
    /// Method that should return the amount of rows for the table
    func getRowAmount(for section: Int) -> Int
    
    /// Method that should return the reuse identifier for the given View Model
    func getReuseId(_ model: BaseViewModel) -> String
}
