//
//  BaseViewModelTableDataSource.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 08/03/2020.
//

import UIKit

/// Class to be used as base implementation of a tableview datasource
/// with the use of Swind's view models
open class BaseViewModelTableDataSource: NSObject, UITableViewDataSource {
    
    /// Method that should return the ViewModel for the given position of the
    /// TableView.
    open func getViewModelForPosition(_ indexPath: IndexPath) -> BaseViewModel {
        fatalError("Subclasses need to implement the `getViewModelForPosition()` method.")
    }
    
    /// Method that should return the Binder for the view at the given position of the
    /// TableView.
    open func getBinderForModel(_ model: BaseViewModel) -> BaseBinderProtocol.Type {
        fatalError("Subclasses need to implement the `getBinderForPosition()` method.")
    }
    
    /// Method that should return the parent of all views (usually the ViewController)
    open func getParent() -> BaseViewProtocol {
        fatalError("Subclasses need to implement the `getParent()` method.")
    }
    
    /// Method that should return the nib name for the view at the given position of the
    /// TableView.
    open func getNibNameForModel(_ model: BaseViewModel) -> String {
        fatalError("Subclasses need to implement the `getNibNameForModel()` method.")
    }
    
    /// Method that should return the amount of sections of the table
    open func getSectionAmount() -> Int {
        return 0
    }
    
    /// Method that should return the amount of rows for the table
    open func getRowAmount(for section: Int) -> Int {
        fatalError("Subclasses need to implement the `getRowAmount()` method.")
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return getSectionAmount()
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRowAmount(for: section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = getViewModelForPosition(indexPath)
        let binder = getBinderForModel(viewModel)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: viewModel), for: indexPath)
        binder.bind(parent: getParent(), view: cell, viewModel: viewModel)
        
        return cell
    }
}
