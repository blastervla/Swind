//
//  BindeableBottomSheetUtils.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 24/03/2020.
//

import UIKit

extension BindeableBottomSheet {
    /// Creates and presents a BindeableBottomSheet with the given parameters.
    /// - Parameter parent: The presentation context. This shall be a `BaseViewProtocol`
    ///                     implementation on a `UIViewController` (as it will also be
    ///                     used to present the sheet) that will be used upon binding.
    ///                     **Note:** Should you need to separate these, use the other method
    ///                     overload (`show(inContext:presenter: ...)`)
    /// - Parameter model: The ViewModel that should be used to bind the layout
    /// - Parameter layout: The layout to bind.
    /// - Parameter binder: The binder to use for binding.
    /// - Parameter hasFullScreen: Trait indicating if the bottom sheet has fullscreen
    ///                            functionality enabled. `true` by default
    /// - Parameter outsideTapCloses: Trait indicating if the bottom sheet can be closed by
    ///                               tapping outside of it. `false` by default
    /// - Parameter preferredContentHeight: Indicates the preferredContentSize height for the
    ///                                     content view. Calculated automatically if left `nil`.
    /// - Parameter completion: Presentation completion callback.
    /// - Returns: The bound bottom sheet
    @discardableResult
    public static func show<T: UIViewController & BaseViewProtocol>(inContext parent: T,
                                                                    with model: BaseViewModel,
                                                                    layout controller: UIViewController,
                                                                    binder: BaseBinderProtocol.Type,
                                                                    hasFullScreen: Bool = true,
                                                                    outsideTapCloses: Bool = false,
                                                                    preferredContentHeight: Float? = nil,
                                                                    completion: (() -> Void)? = nil) -> BindeableBottomSheet {
        return BindeableBottomSheet.show(inContext: parent, presenter: parent, with: model, layout: controller, binder: binder, hasFullScreen: hasFullScreen, outsideTapCloses: outsideTapCloses, preferredContentHeight: preferredContentHeight, completion: completion)
    }
    
    /// Creates and presents a BindeableBottomSheet with the given parameters.
    /// - Parameter parent: The presentation context. This shall be a `BaseViewProtocol`
    ///                     implementation that will be used upon binding.
    ///                     **Note:** Should you need to separate these, use the other method
    ///                     overload (`show(inContext:presenter: ...)`)
    /// - Parameter presenter: The UIViewController that should present the sheet.
    /// - Parameter model: The ViewModel that should be used to bind the layout
    /// - Parameter layout: The layout to bind.
    /// - Parameter binder: The binder to use for binding.
    /// - Parameter hasFullScreen: Trait indicating if the bottom sheet has fullscreen
    ///                            functionality enabled. `true` by default
    /// - Parameter outsideTapCloses: Trait indicating if the bottom sheet can be closed by
    ///                               tapping outside of it. `false` by default
    /// - Parameter preferredContentHeight: Indicates the preferredContentSize height for the
    ///                                     content view. Calculated automatically if left `nil`.
    /// - Parameter completion: Presentation completion callback.
    /// - Returns: The bound bottom sheet
    @discardableResult
    public static func show(inContext parent: BaseViewProtocol,
                            presenter: UIViewController,
                            with model: BaseViewModel,
                            layout controller: UIViewController,
                            binder: BaseBinderProtocol.Type,
                            hasFullScreen: Bool = true,
                            outsideTapCloses: Bool = false,
                            preferredContentHeight: Float? = nil,
                            completion: (() -> Void)? = nil) -> BindeableBottomSheet {
        // Bind
        controller.view.layoutIfNeeded()
        binder.bind(parent: parent, view: controller, viewModel: model)
        
        let sheet = createAndPresentBottomSheet(presenter: presenter,
                                                layout: controller.view,
                                                hasFullScreen: hasFullScreen,
                                                outsideTapCloses: outsideTapCloses,
                                                preferredContentHeight: preferredContentHeight,
                                                completion: completion)
        
        sheet.setContent(controller)
        
        return sheet
    }
    
    /// Creates and presents a BindeableBottomSheet with the given parameters.
    /// - Parameter parent: The presentation context. This shall be a `BaseViewProtocol`
    ///                     implementation on a `UIViewController` (as it will also be
    ///                     used to present the sheet) that will be used upon binding.
    ///                     **Note:** Should you need to separate these, use the other method
    ///                     overload (`show(inContext:presenter: ...)`)
    /// - Parameter model: The ViewModel that should be used to bind the layout
    /// - Parameter layout: The layout to bind.
    /// - Parameter binder: The binder to use for binding.
    /// - Parameter hasFullScreen: Trait indicating if the bottom sheet has fullscreen
    ///                            functionality enabled. `true` by default
    /// - Parameter outsideTapCloses: Trait indicating if the bottom sheet can be closed by
    ///                               tapping outside of it. `false` by default
    /// - Parameter preferredContentHeight: Indicates the preferredContentSize height for the
    ///                                     content view. Calculated automatically if left `nil`.
    /// - Parameter completion: Presentation completion callback.
    /// - Returns: The bound bottom sheet
    @discardableResult
    public static func show<T: UIViewController & BaseViewProtocol>(inContext parent: T,
                                                                    with model: BaseViewModel,
                                                                    layout view: UIView,
                                                                    binder: BaseBinderProtocol.Type,
                                                                    hasFullScreen: Bool = true,
                                                                    outsideTapCloses: Bool = false,
                                                                    preferredContentHeight: Float? = nil,
                                                                    completion: (() -> Void)? = nil) -> BindeableBottomSheet {
        return BindeableBottomSheet.show(inContext: parent, presenter: parent, with: model, layout: view, binder: binder, hasFullScreen: hasFullScreen, outsideTapCloses: outsideTapCloses, preferredContentHeight: preferredContentHeight, completion: completion)
    }
    
    /// Creates and presents a BindeableBottomSheet with the given parameters.
    /// - Parameter parent: The presentation context. This shall be a `BaseViewProtocol`
    ///                     implementation that will be used upon binding.
    ///                     **Note:** Should you need to separate these, use the other method
    ///                     overload (`show(inContext:presenter: ...)`)
    /// - Parameter presenter: The UIViewController that should present the sheet.
    /// - Parameter model: The ViewModel that should be used to bind the layout
    /// - Parameter layout: The layout to bind.
    /// - Parameter binder: The binder to use for binding.
    /// - Parameter hasFullScreen: Trait indicating if the bottom sheet has fullscreen
    ///                            functionality enabled. `true` by default
    /// - Parameter outsideTapCloses: Trait indicating if the bottom sheet can be closed by
    ///                               tapping outside of it. `false` by default
    /// - Parameter preferredContentHeight: Indicates the preferredContentSize height for the
    ///                                     content view. Calculated automatically if left `nil`.
    /// - Parameter completion: Presentation completion callback.
    /// - Returns: The bound bottom sheet
    @discardableResult
    public static func show(inContext parent: BaseViewProtocol,
                            presenter: UIViewController,
                            with model: BaseViewModel,
                            layout view: UIView,
                            binder: BaseBinderProtocol.Type,
                            hasFullScreen: Bool = true,
                            outsideTapCloses: Bool = false,
                            preferredContentHeight: Float? = nil,
                            completion: (() -> Void)? = nil) -> BindeableBottomSheet {
        // Bind
        view.layoutIfNeeded()
        binder.bind(parent: parent, view: view, viewModel: model)
        
        let sheet = createAndPresentBottomSheet(presenter: presenter,
                                                layout: view,
                                                hasFullScreen: hasFullScreen,
                                                outsideTapCloses: outsideTapCloses,
                                                preferredContentHeight: preferredContentHeight,
                                                completion: completion)
        
        sheet.setContent(view)
        
        return sheet
    }
    
    /// Creates and presents a BindeableBottomSheet with the given parameters.
    /// - Parameter presenter: The UIViewController that should present the sheet.
    /// - Parameter layout: The layout to present.
    /// - Parameter hasFullScreen: Trait indicating if the bottom sheet has fullscreen
    ///                            functionality enabled. `true` by default
    /// - Parameter outsideTapCloses: Trait indicating if the bottom sheet can be closed by
    ///                               tapping outside of it. `false` by default
    /// - Parameter preferredContentHeight: Indicates the preferredContentSize height for the
    ///                                     content view. Calculated automatically if left `nil`.
    /// - Parameter completion: Presentation completion callback.
    /// - Returns: The bottom sheet
    @discardableResult
    public static func show(presenter: UIViewController,
                            layout view: UIView,
                            hasFullScreen: Bool = true,
                            outsideTapCloses: Bool = false,
                            preferredContentHeight: Float? = nil,
                            completion: (() -> Void)? = nil) -> BindeableBottomSheet {
        let sheet = createAndPresentBottomSheet(presenter: presenter,
                                                layout: view,
                                                hasFullScreen: hasFullScreen,
                                                outsideTapCloses: outsideTapCloses,
                                                preferredContentHeight: preferredContentHeight,
                                                completion: completion)
        
        sheet.setContent(view)
        
        return sheet
    }
    
    /// Creates and presents a BindeableBottomSheet with the given parameters.
    /// - Parameter presenter: The UIViewController that should present the sheet.
    /// - Parameter layout: The layout to present.
    /// - Parameter hasFullScreen: Trait indicating if the bottom sheet has fullscreen
    ///                            functionality enabled. `true` by default
    /// - Parameter outsideTapCloses: Trait indicating if the bottom sheet can be closed by
    ///                               tapping outside of it. `false` by default
    /// - Parameter preferredContentHeight: Indicates the preferredContentSize height for the
    ///                                     content view. Calculated automatically if left `nil`.
    /// - Parameter completion: Presentation completion callback.
    /// - Returns: The bottom sheet
    @discardableResult
    public static func show(presenter: UIViewController,
                            layout controller: UIViewController,
                            hasFullScreen: Bool = true,
                            outsideTapCloses: Bool = false,
                            preferredContentHeight: Float? = nil,
                            completion: (() -> Void)? = nil) -> BindeableBottomSheet {
        let sheet = createAndPresentBottomSheet(presenter: presenter,
                                                layout: controller.view,
                                                hasFullScreen: hasFullScreen,
                                                outsideTapCloses: outsideTapCloses,
                                                preferredContentHeight: preferredContentHeight,
                                                completion: completion)
        
        sheet.setContent(controller)
        
        return sheet
    }
    
    fileprivate static func createAndPresentBottomSheet(presenter: UIViewController,
                                                        layout view: UIView,
                                                        hasFullScreen: Bool,
                                                        outsideTapCloses: Bool,
                                                        preferredContentHeight: Float?,
                                                        completion: (() -> Void)?) -> BindeableBottomSheet {
        let sheet = BindeableBottomSheet(hasFullscreen: hasFullScreen, outsideTapCloses: outsideTapCloses)
        
        let cgSize = view.systemLayoutSizeFitting(UIScreen.main.bounds.size)
        let roughContentHeight = min(preferredContentHeight ?? Float(cgSize.height), Float(UIScreen.main.bounds.height))
        sheet.endingThreshold = min(CGFloat(roughContentHeight + 175) / UIScreen.main.bounds.height, 0.95)
        sheet.startingThreshold = min(CGFloat(roughContentHeight + 100) / UIScreen.main.bounds.height, 0.9)
        sheet.collapseThreshold = min(CGFloat(roughContentHeight + 25) / UIScreen.main.bounds.height, 0.67)
        sheet.view.backgroundColor = UIColor.clear
        sheet.modalPresentationStyle = .overFullScreen
        
        // Present
        presenter.present(sheet, animated: true, completion: completion)
        
        return sheet
    }
}
