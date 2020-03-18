//
//  BindeableBottomSheet.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 15/03/2020.
//

import UIKit
import MaterialComponents

public typealias BottomSheetDialog = MDCBottomSheetController

extension MDCBottomSheetController {
    @discardableResult
    public static func show<T: UIViewController & BaseViewProtocol>(inContext parent: T, with model: BaseViewModel, layout controller: BindeableBottomSheetDelegate, binder: BaseBinderProtocol.Type, dragDownToDismiss: Bool = true, completion: (() -> Void)? = nil) -> MDCBottomSheetController {
        let sheet = MDCBottomSheetController(contentViewController: controller)
        
        // Behaviour customization
        sheet.dismissOnDraggingDownSheet = dragDownToDismiss
        
        // UI customization
        let shapeGenerator = MDCRectangleShapeGenerator()
        let cornerTreatment = MDCRoundedCornerTreatment(radius: 16)
        shapeGenerator.topLeftCorner = cornerTreatment
        shapeGenerator.topRightCorner = cornerTreatment
        
        sheet.setShapeGenerator(shapeGenerator, for: .preferred)
        sheet.setShapeGenerator(shapeGenerator, for: .extended)
//        sheet.setShapeGenerator(shapeGenerator, for: .closed)
        
        // Present
        parent.present(sheet, animated: true, completion: completion)
        
        // Bind
        binder.bind(parent: parent, view: controller, viewModel: model)
        
        return sheet
    }
}
