//
//  PopOverViewController.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 14/03/2020.
//

import UIKit

public typealias PopupMenu = PopOverViewController
public typealias PopOverEntry = (id: String, text: String)

public class PopOverViewController: UIViewController, BaseViewProtocol {

    @IBOutlet weak var stackView: BindeableStackView!
    
    public var entries = [PopOverEntry]()
    public var parentView: BaseViewProtocol?
    public var id: String = "default"
    
    public static func show<T: UIViewController & BaseViewProtocol>(parent: T, source: UIView, entries: [PopOverEntry], id: String = "default") {
        let popupController = PopOverViewController()
        popupController.id = id
        popupController.parentView = parent
        popupController.entries = entries
        popupController.popoverPresentationController?.sourceView = source
        popupController.popoverPresentationController?.sourceRect = source.bounds
        parent.present(popupController, animated: true, completion: nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.popoverPresentationController?.permittedArrowDirections = .up
        self.popoverPresentationController?.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.popoverPresentationController?.permittedArrowDirections = .up
        self.popoverPresentationController?.delegate = self
    }
    
    public override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            return .popover
        }
        set(value) {
            super.modalPresentationStyle = value
        }
    }
    
    var preferredWidth: CGFloat = 96
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        var vmEntries = ObservableArray<BaseViewModel>()
        vmEntries.addAll(entries.map { PopOverEntryModel(popOverId: self.id, entryId: $0.id, text: $0.text) })
        
        self.stackView.bind(vmEntries, parent: self.parentView ?? self, layoutNibName: String(describing: PopOverEntryView.self), bundle: .init(for: PopOverEntryView.self), binder: PopOverEntryBinder.self)
        
        self.preferredWidth = self.stackView.subviews.map { $0.systemLayoutSizeFitting(.zero).width }.max() ?? 96
        self.preferredContentSize = CGSize(width: 52, height: 1)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.150) {
            self.preferredContentSize = CGSize(width: max(self.preferredWidth, 200), height: self.stackView.systemLayoutSizeFitting(.zero).height)
        }
    }
}

extension PopOverViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
