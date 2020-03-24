//
//  PopOverViewController.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 14/03/2020.
//

import UIKit

public typealias PopupMenu = PopOverViewController
public typealias PopOverEntry = (id: String, text: String, model: BaseViewModel?)

public class PopOverViewController: UIViewController, BaseViewProtocol {

    @IBOutlet weak var stackView: BindeableStackView!
    
    public var entries = [PopOverEntry]()
    public var parentView: BaseViewProtocol?
    public var id: String = "default"
    
    public static func show<T: UIViewController & BaseViewProtocol>(parent: T, source: UIView, entries: [PopOverEntry], id: String = "default") {
        show(presenter: parent, parent: parent, source: source, entries: entries, id: id)
    }
    
    public static func show(presenter: UIViewController, parent: BaseViewProtocol, source: UIView, entries: [PopOverEntry], id: String = "default") {
        let popupController = PopOverViewController()
        popupController.id = id
        popupController.parentView = parent
        popupController.entries = entries
        popupController.popoverPresentationController?.sourceView = source
        popupController.popoverPresentationController?.sourceRect = source.bounds
        popupController.popoverPresentationController?.permittedArrowDirections = resolveArrowDirection(source: source, entries: entries)
        popupController.popoverPresentationController?.delegate = popupController
        presenter.present(popupController, animated: true, completion: nil)
    }
    
    private static let ENTRY_HEIGHT = 48
    
    private static func resolveArrowDirection(source: UIView, entries: [PopOverEntry]) -> UIPopoverArrowDirection {
        let roughHeight = CGFloat(ENTRY_HEIGHT * entries.count)
        
        guard let sourceEndY = source.superview?.convert(CGPoint(x: source.frame.origin.x + source.frame.size.width, y: source.frame.origin.y + source.frame.size.height), to: nil).y else { return .up }
        
        let screenHeight = UIScreen.main.bounds.height - 32
        
        if screenHeight - sourceEndY < roughHeight {
            return .down
        } else {
            return .up
        }
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
        vmEntries.addAll(entries.map { PopOverEntryModel(popOverId: self.id, entryId: $0.id, text: $0.text, associatedViewModel: $0.model) })
        
        self.stackView.bind(vmEntries, parent: self, layoutNibName: String(describing: PopOverEntryView.self), bundle: .init(for: PopOverEntryView.self), binder: PopOverEntryBinder.self)
        
        self.preferredWidth = self.stackView.subviews.map { $0.systemLayoutSizeFitting(.zero).width }.max() ?? 96
        self.preferredContentSize = CGSize(width: 52, height: 1)
    }
    
    public func onClick(_ v: UIView, _ viewModel: BaseViewModel) {
        self.dismiss(animated: true) {
            self.parentView?.onClick?(v, viewModel)
        }
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
