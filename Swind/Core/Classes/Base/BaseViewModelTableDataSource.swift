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
    
    open var adapter: BaseViewModelTableAdapterProtocol?
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.adapter?.getSectionAmount() ?? 0
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.adapter?.getRowAmount(for: section) ?? 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.adapter?.getViewModelForPosition(indexPath),
              let binder = self.adapter?.getBinderForModel(viewModel),
              let parent = self.adapter?.getParent(),
              let reuseId = self.adapter?.getReuseId(viewModel)
        else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        binder.bind(parent: parent, view: cell, viewModel: viewModel)
        
        return cell
    }
}
