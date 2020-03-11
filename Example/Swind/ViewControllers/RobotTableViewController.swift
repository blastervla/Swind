//
//  RobotTableViewController.swift
//  Swind_Example
//
//  Created by Vladimir Pomsztein on 10/03/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Swind

class RobotTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let adapter: RobotTableAdapter = RobotTableAdapter()
    var touchedVM: RobotModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: String(describing: RobotTableViewCell.self), bundle: .init(for: RobotTableViewController.self)), forCellReuseIdentifier: String(describing: RobotModel.self))
        
        self.tableView.dataSource = adapter
        self.tableView.delegate = self
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ShowRobotController, segue.identifier == "ShowRobotFromTable", let model = self.touchedVM {
            destinationVC.setRobot(model)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
}

extension RobotTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.touchedVM = self.adapter.getViewModelForPosition(indexPath) as? RobotModel
        self.performSegue(withIdentifier: "ShowRobotFromTable", sender: self)
    }
}
