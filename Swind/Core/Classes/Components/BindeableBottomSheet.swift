//
//  BindeableBottomSheet.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 23/03/2020.
//

import UIKit

public class BindeableBottomSheet: UIViewController {
    
    @IBOutlet private weak var navbarBackgroundView: UIView!
    @IBOutlet private weak var navbarSeparatorView: UIView!
    @IBOutlet private weak var modalCloseButton: UIImageView!
    @IBOutlet private weak var modalHandle: UIView!
    
    @IBOutlet private weak var modalView: UIView!
    @IBOutlet private weak var contentContainer: UIView!
    
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topContainerConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topNavbarSeparatorConstraint: NSLayoutConstraint!
    @IBOutlet private weak var closeButtonHeightConstraint: NSLayoutConstraint!
    
    private var blurEffectView: UIVisualEffectView?
    
    private var carryOverTranslation: CGFloat = 0.0
    
    var collapseThreshold: CGFloat = 0.5
    var startingThreshold: CGFloat = 0.6
    var endingThreshold: CGFloat = 0.7
    
    var fullscreenBlock: (() -> Void)?
    
    var isFullscreen: Bool = false
    var isClosing: Bool = false
    
    private var isAnimating: Bool = false
    private var isTouchingModal: Bool = false
    
    private let hasFullscreen: Bool
    private let isPannable: Bool
    private let canBounce: Bool
    private let outsideTapCloses: Bool
    
    private var decelerationTimer: Timer?
    
    private var scrollview: UIScrollView?
    
    public var onDismiss: (() -> Void)?
    
    init(hasFullscreen: Bool = true, outsideTapCloses: Bool = false) {
        self.hasFullscreen = hasFullscreen
        self.isPannable = false // TODO: Add proper support for pannable
        self.canBounce = true // TODO: Add proper support for canBounce
        self.outsideTapCloses = outsideTapCloses
        super.init(nibName: String(describing: BindeableBottomSheet.self), bundle: Bundle.swindBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.hasFullscreen = true
        self.isPannable = false // TODO: Add proper support for pannable
        self.canBounce = true // TODO: Add proper support for canBounce
        self.outsideTapCloses = false
        super.init(coder: aDecoder)
    }
    
    public func setOnDismissListener(_ listener: (() -> Void)?) {
        self.onDismiss = listener
    }
    
    public func setContent(_ content: UIView) {
        content.translatesAutoresizingMaskIntoConstraints = false
        self.contentContainer.addSubview(content)
        self.contentContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .alignAllCenterX, metrics: nil, views: ["view": content]))
        self.contentContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .alignAllCenterY, metrics: nil, views: ["view": content]))
        
        commonSetContent(content)
    }
    
    public func setContent(_ content: UIViewController) {
        guard let contentView = content.view else { return }
        self.addChild(content)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(contentView)
        
        self.contentContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .alignAllCenterX, metrics: nil, views: ["view": contentView]))
        self.contentContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .alignAllCenterY, metrics: nil, views: ["view": contentView]))
        
        content.didMove(toParent: self)
        commonSetContent(contentView)
    }
    
    public func setCloseImage(_ image: UIImage?) {
        self.modalCloseButton.image = image
    }
    
    private func commonSetContent(_ content: UIView) {
        let scrollViews = content.subviews.compactMap { view in view as? UIScrollView }
        guard let scrollview = scrollViews.first else { return }
        
        self.scrollview = scrollview
        scrollview.isScrollEnabled = false
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setCloseImage(UIImage(named: "ic_swind_close", in: Bundle.swindBundle(), compatibleWith: nil))
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fix for plus devices
        
        self.view.frame = UIScreen.main.bounds
        
        self.view.layoutIfNeeded()
        
        self.modalHandle.layer.cornerRadius = 2.0
        self.modalView.swind_roundCorners(radius: 8.0, corners: [.topLeft, .topRight])
        
        self.topConstraint.constant = self.view.frame.height
        
        self.addOverlay()
        self.prepareUIForModal()
        
        self.modalCloseButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.close)))
        
        if (outsideTapCloses) {
            self.blurEffectView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.close)))
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.layoutIfNeeded()
        self.setToStartingPosition(time: 0.2)
    }
    
    @objc public func close() { // We use this to avoid tapGesture from sending a completion closure that crashes the app
        self.dismiss(animated: true)
    }
    
    override public func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        guard self.presentedViewController == nil else {
            self.presentedViewController?.dismiss(animated: animated, completion: nil)
            return
        }
        if animated {
            self.isClosing = true
            UIView.animate(withDuration: 0.2, animations: {[weak self] in
                guard let strongSelf = self else { return }
                strongSelf.topConstraint.constant = strongSelf.view.frame.height
                strongSelf.blurEffectView?.alpha = 0.0
                strongSelf.view.layoutIfNeeded()
            }) { [weak self] finish in
                if finish {
                    guard let strongSelf = self else { return }
                    strongSelf.dismiss(animated: false) {
                        completion?()
                    }
                }
            }
        } else {
            super.dismiss(animated: false) {
                self.onDismiss?()
                completion?()
            }
        }
    }
    
    @IBAction func panRecognizer(recognizer: UIPanGestureRecognizer) {
        if (recognizer.state == .ended) {
            if (!self.isFullscreen && !self.isClosing) {
                if (!self.isPannable && self.topConstraint.constant < self.view.frame.height * (1 - collapseThreshold)) {
                    self.setToStartingPosition(time: 0.1)
                } else if (!self.isPannable) {
                    self.dismiss(animated: true)
                } else {
                    self.decelerationTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] (_: Timer) in
                        guard let strongSelf = self else { return }
                        
                        if (abs(strongSelf.carryOverTranslation) < 1) {
                            strongSelf.carryOverTranslation = 0.0
                            strongSelf.decelerationTimer?.invalidate()
                            return
                        }
                        
                        strongSelf.topConstraint.constant += strongSelf.carryOverTranslation * 0.15
                        strongSelf.carryOverTranslation = strongSelf.carryOverTranslation * 0.85
                        strongSelf.view.layoutIfNeeded()
                    }
                }
            }
        } else if (!self.isAnimating) {
            self.panModal(recognizer: recognizer)
        }
    }
    
    private func setToStartingPosition(time: TimeInterval) {
        self.isAnimating = true
        UIView.animate(withDuration: time, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.topConstraint.constant = strongSelf.view.frame.height * (1 - strongSelf.startingThreshold)
            strongSelf.blurEffectView?.alpha = 1.0
            strongSelf.view.layoutIfNeeded()
        }) { [weak self] (_: Bool) in
            guard let strongSelf = self else { return }
            strongSelf.isAnimating = false
        }
    }
    
    private func addOverlay() {
        //only apply the blur if the user hasn't disabled transparency effects
        if (!UIAccessibility.isReduceTransparencyEnabled) {
            view.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.insertSubview(blurEffectView, at: 0) //if you have more UIViews, use an insertSubview API to place it where needed
            blurEffectView.alpha = 0
            
            self.blurEffectView = blurEffectView
        } else {
            view.backgroundColor = .black
        }
    }
    
    private func panModal(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.modalView)
        let velocity = recognizer.velocity(in: self.modalView)
        
        let y = self.topConstraint.constant
        let newY = y + translation.y
        
        self.isTouchingModal = true
        if (self.hasFullscreen && newY < self.view.frame.height * (1 - endingThreshold)) {
            // Animate to top
            self.scrollview?.isScrollEnabled = true
            self.isFullscreen = true
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.prepareUIForFullscreen()
                strongSelf.topConstraint.constant = 0
                strongSelf.blurEffectView?.alpha = 0.0
                strongSelf.view.layoutIfNeeded()
            }) { [weak self] (_: Bool) in
                guard let strongSelf = self else { return }
                strongSelf.fullscreenBlock?()
            }
            self.modalView.removeGestureRecognizer(recognizer)
        } else if (self.view.frame.height - self.topConstraint.constant > self.view.frame.height * endingThreshold && velocity.y > 1200) {
            self.setToStartingPosition(time: 0.1)
        } else {
            if (!self.isAnimating && newY > self.view.frame.height * (1 - collapseThreshold)) {
                // Animate blur effect to fade out
                let amount = (newY - self.view.frame.height * (1 - collapseThreshold))
                let normalizer = (self.view.frame.height * collapseThreshold)
                self.blurEffectView?.alpha = 1 - amount / normalizer
            } else {
                self.blurEffectView?.alpha = 1
            }
            
            if (self.canBounce || !self.isAnimating && newY > self.view.frame.height * (1 - startingThreshold)) {
                self.topConstraint.constant += translation.y
                if (!self.canBounce && !self.isPannable) { // We don't allow the modal to be above the startingThreshold
                    self.topConstraint.constant = max(self.view.frame.height * (1 - startingThreshold), self.topConstraint.constant)
                }
                self.carryOverTranslation = translation.y * 0.0005 * abs(velocity.y)
                self.view.layoutIfNeeded()
            }
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.modalView)
    }
    
    private func prepareUIForModal() {
        self.navbarSeparatorView.alpha = 0.0
        self.navbarBackgroundView.alpha = 0.0
        self.modalCloseButton.alpha = 0.0
        self.modalCloseButton.isUserInteractionEnabled = false
        self.topContainerConstraint.constant = 4.0
        self.topNavbarSeparatorConstraint.constant = 5.0
        self.closeButtonHeightConstraint.constant = 0.0
        
        self.modalHandle.alpha = 1.0
    }
    
    private func prepareUIForFullscreen() {
        self.navbarSeparatorView.alpha = 1.0
        self.navbarBackgroundView.alpha = 1.0
        self.modalCloseButton.alpha = 1.0
        self.modalCloseButton.isUserInteractionEnabled = true
        self.topContainerConstraint.constant = 0.0
        self.topNavbarSeparatorConstraint.constant = 30.0
        self.closeButtonHeightConstraint.constant = 42.0
        
        self.modalHandle.alpha = 0.0
    }

}
