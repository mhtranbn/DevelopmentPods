/**
 @file      CMPopupController.swift
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

import UIKit
import RSUtils

@objc public protocol CMPopupDelegate {
    /** Event when user tap background to hide popup */
    @objc optional func popupDidCancel(_ sender: CMPopupController)
    /** Event before showing popup */
    @objc optional func popupWillAppear(_ sender: CMPopupController, animated: Bool)
    /** Event when popup is showed (animation finishes) */
    @objc optional func popupDidAppear(_ sender: CMPopupController, animated: Bool)
    /** Event before hidding popup */
    @objc optional func popupWillDisappear(_ sender: CMPopupController, animated: Bool)
    /** Event when popup is hide (animation finished) */
    @objc optional func popupDidDisappear(_ sender: CMPopupController, animated: Bool)
}

/** Class to control popup view.
 
 Showing flow:
 - Add **backgroundView** as subview of & fitting to target view.
 - Reset **popupView** properties (remove from superview, remove all constraints with prefix `kCMPopupLayoutConstraintPrefix`,
 transform to identity), then add it as subview of subview of **backgroundView**.
 - Execute `layoutAction` to add constraints to **contentView**.
 - If animation is enable, execute `showingAnimationAction` (recommend use transform to make animation).
 
 Hiding flow:
 - If animation is enable, execute `hidingAnimationAction` (recommend use transform to make animation).
 - Reset **popupView** properties.
 */
public class CMPopupController: NSObject, CMPopupClient {
    
    public typealias CMPopupAction = (CMPopupController, (() -> Void)?) -> Void
    
    @objc public static let kCMPopupLayoutConstraintPrefix = "CMPopupConstraint"

    public var operationQueue: OperationQueue?

    // MARK: - Properties
    
    private let contentView: UIView
    private let backgroundView: UIView
    private let backgroundButton: UIButton
    private var autoHideInterfal: TimeInterval?

    /** View to show the popup view inside. If `targetView` & `targetViewController` are not provided,
     use default target (internal window root view controller of CMPopupManager). */
    @objc public weak var targetView: UIView?
    /** Layout action of popup view. Default is center */
    @objc public var layoutAction = CMPopupController.layoutCenter
    @objc public var layoutParams: Any?
    /** Animation action to show/hide popup. Default is pop view in center */
    @objc public var showingAnimationAction = CMPopupController.showingAnimationPushCenter;
    @objc public var hidingAnimationAction = CMPopupController.hiddingAnimationPushCenter;
    /** Animation duration, but animation action can ignore this. */
    @objc public var animationDuration: TimeInterval = 0.3
    /** Delegate */
    @objc public weak var delegate: CMPopupDelegate?
    /** Background color. Set this color to `nil` to allow user tap through */
    @objc public var backgroundColor: UIColor? {
        get {
            return backgroundView.backgroundColor
        }
        set (value) {
            backgroundView.backgroundColor = value
        }
    }
    /** Hide popup when tap background. Default NO. */
    @objc public var hideWhenTapBackground: Bool {
        get {
            return backgroundButton.isUsable
        }
        set (value) {
            backgroundButton.isUsable = value
        }
    }
    /** View is showed as popup */
    @objc public var popupView: UIView {
        return contentView
    }
    /** Addtional info of CMAlertView, similar with view `tag` */
    @objc public var metaInfo: AnyObject?

    // MARK: Initialization & configuration
    
    /** Create new popup with given view. Popup use view `isUserInteractionEnabled` to allow user tap through or not */
    @objc public init(view: UIView) {
        contentView = view
        backgroundView = UIView()
        backgroundView.isUserInteractionEnabled = true
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.clipsToBounds = true
        
        backgroundButton = UIButton(type: UIButtonType.custom)
        backgroundButton.isUsable = false
        backgroundButton.backgroundColor = nil
        backgroundButton.setTitle(nil, for: .normal)
        backgroundView.addSubview(backgroundButton)
        CMBaseCustomView.addFillLayoutConstrains(for: backgroundButton)
        super.init()
        backgroundButton.addTarget(self, action: #selector(background_onTap), for: .touchUpInside)
    }
    
    // MARK: - Private
    
    private func reset(internalView view: UIView) {
        view.removeFromSuperview()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.transform = CGAffineTransform.identity
        view.isHidden = false
        view.alpha = 1.0
        var constraintsToRemove = [NSLayoutConstraint]()
        for constraint in view.constraints {
            if let identifier = constraint.identifier, identifier.hasPrefix(CMPopupController.kCMPopupLayoutConstraintPrefix) {
                constraintsToRemove.append(constraint)
            }
        }
        view.removeConstraints(constraintsToRemove)
    }
    
    private func resetInternalViews() {
        reset(internalView: contentView)
        reset(internalView: backgroundView)
    }
    
    private func prepareToShow() -> UIView {
        resetInternalViews()
        backgroundView.isHidden = true
        var viewTarget: UIView
        if let view = targetView {
            viewTarget = view
        } else {
            viewTarget = UIApplication.shared.delegate!.window!!
        }
        viewTarget.addSubview(backgroundView)
        CMBaseCustomView.addFillLayoutConstrains(for: backgroundView)
        backgroundView.addSubview(contentView)
        backgroundView.isUserInteractionEnabled = contentView.isUserInteractionEnabled
        layoutAction(self, nil)
        viewTarget.setNeedsLayout()
        return viewTarget
    }
    
    @objc internal func background_onTap(_ sender: UIButton) {
        hide(true)
        if let listener = delegate, let action = listener.popupDidCancel {
            action(self)
        }
    }
    
    // MARK: - Control

    @objc public func breakAnimation() {
        backgroundView.layer.removeAllAnimations()
        contentView.layer.removeAllAnimations()
    }

    /** Show popup */
    @objc public func show(_ animated: Bool) {
        breakAnimation()
        autoHideInterfal = nil
        CMPopupManager.sharedInstance.registToShow(popup: self, animation: animated)
    }
    
    @objc public func show(animated: Bool, autoHideDuration: TimeInterval) {
        breakAnimation()
        autoHideInterfal = autoHideDuration
        CMPopupManager.sharedInstance.registToShow(popup: self, animation: animated)
    }
    
    /** Hide popup */
    @objc public func hide(_ animated: Bool) {
        breakAnimation()
        CMPopupManager.sharedInstance.registToHide(popup: self, animation: animated, isAlreadyHidden: false)
    }

    // MARK: - Internal

    public func doShowing(animation: Bool, isRestoreFromTemporary: Bool, completion: @escaping () -> Void) {
        _ = prepareToShow()
        if !isRestoreFromTemporary, let listener = delegate, let action = listener.popupWillAppear {
            action(self, animation)
        }
        weak var wSelf = self
        let completionBlock = {
            guard let me = wSelf else { return }
            if !isRestoreFromTemporary, let listener = me.delegate, let action = listener.popupDidAppear {
                action(me, animation)
            }
            completion()
        }
        if animation {
            backgroundView.isHidden = false
            showingAnimationAction(self, completionBlock)
        } else {
            completionBlock()
        }
        if let autoHide = autoHideInterfal {
            delayToMain(autoHide, {
                wSelf?.hide(animation)
            })
        }
    }

    public func doHiding(animation: Bool, isTemporary: Bool, isForced: Bool, completion: @escaping () -> Void) {
        weak var wSelf = self
        if !isTemporary, let listener = delegate, let action = listener.popupWillDisappear {
            action(self, animation)
        }
        let completionBlock = {
            guard let me = wSelf else { return }
            me.resetInternalViews()
            if !isTemporary, let listener = me.delegate, let action = listener.popupDidDisappear {
                action(me, animation)
            }
            completion()
        }
        if animation {
            hidingAnimationAction(self, completionBlock)
        } else {
            completionBlock()
        }
    }
    
}
