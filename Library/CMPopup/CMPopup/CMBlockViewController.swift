/**
 @file      CMBlockViewController.swift
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

import UIKit
import RSUtils

/** Protocol to block view handle show/hide tasks */
@objc public protocol CMBlockViewProtocol {
    @objc optional func blockViewControllerWillAppear(_ sender: CMBlockViewController, animated: Bool)
    @objc optional func blockViewControllerDidAppear(_ sender: CMBlockViewController, animated: Bool)
    @objc optional func blockViewControllerWillDisappear(_ sender: CMBlockViewController, animated: Bool)
    @objc optional func blockViewControllerDidDisappear(_ sender: CMBlockViewController, animated: Bool)
}

/** Use to block app screen */
public class CMBlockViewController: NSObject, CMPopupClient {
    
    public var operationQueue: OperationQueue?
    
    public typealias CMBlockViewAction = (Bool, () -> Void) -> Void
    private static let kCMBlockLayoutConstraintPrefix = "CMBlockConstraint"
    
    private var showHideNum = 0

    private weak var blockerView: UIView?
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    /** Shared instance */
    @objc public static let sharedInstance = CMBlockViewController()
    /** Number of times `show` - block hides only when this number back to 0 */
    @objc public var showHideCount: Int {
        return showHideNum
    }
    /** Background view */
    @objc public var backgroundColor: UIColor? {
        get {
            return backgroundView.backgroundColor
        }
        set (value) {
            backgroundView.backgroundColor = value
        }
    }

    public override init() {
        super.init()
        setupToBlock(CMIndicatorBlockView())
    }
    
    // MARK: - Private
    
    private func resetBlockerView() {
        if let view = blockerView {
            view.removeFromSuperview()
            var constraintToRm = [NSLayoutConstraint]()
            for constraint in view.constraints {
                if let identifier = constraint.identifier, identifier.hasPrefix(CMBlockViewController.kCMBlockLayoutConstraintPrefix) {
                    constraintToRm.append(constraint)
                }
            }
            view.removeConstraints(constraintToRm)
        }
        blockerView = nil
    }
    
    // MARK: - Configure
    
    /** Block screen with a view. View can inplement `CMBlockViewProtocol` to animate. */
    @objc public func setupToBlock(_ view: UIView) {
        resetBlockerView()
        blockerView = view
        view.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(view)
        var constraint: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .centerX,
                                                                relatedBy: .equal,
                                                                toItem: backgroundView, attribute: .centerX,
                                                                multiplier: 1.0, constant: 0)
        constraint.identifier = CMBlockViewController.kCMBlockLayoutConstraintPrefix + "CenterX"
        backgroundView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: view, attribute: .centerY,
                                        relatedBy: .equal,
                                        toItem: backgroundView, attribute: .centerY,
                                        multiplier: 1.0, constant: 0)
        constraint.identifier = CMBlockViewController.kCMBlockLayoutConstraintPrefix + "CenterY"
        backgroundView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: view, attribute: .width,
                                        relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute,
                                        multiplier: 1.0, constant: view.frame.size.width)
        constraint.identifier = CMBlockViewController.kCMBlockLayoutConstraintPrefix + "Width"
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: view, attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute,
                                        multiplier: 1.0, constant: view.frame.size.height)
        constraint.identifier = CMBlockViewController.kCMBlockLayoutConstraintPrefix + "Height"
        view.addConstraint(constraint)
    }

    // MARK: - Tasks
    
    @objc public func show(_ animated: Bool) {
        if showHideNum == 0 {
            resetAnimations()
            CMPopupManager.sharedInstance.registToShow(popup: self, animation: animated)
        }
        showHideNum += 1
    }
    
    @objc public func hide(_ animated: Bool) {
        showHideNum -= 1
        if showHideNum == 0 {
            resetAnimations()
            CMPopupManager.sharedInstance.registToHide(popup: self, animation: animated, isAlreadyHidden: false)
        } else if showHideNum < 0 {
            showHideNum = 0
        }
    }

    // MARK: - Internal

    private func resetAnimations() {
        backgroundView.layer.removeAllAnimations()
    }

    public func doShowing(animation: Bool, isRestoreFromTemporary: Bool, completion: @escaping () -> Void) {
        weak var wSelf = self
        let completionBlock: () -> Void = {
            guard let me = wSelf else { return }
            if let listener = me.blockerView as? CMBlockViewProtocol,
                let action = listener.blockViewControllerDidAppear {
                action(me, animation)
            }
            completion()
        }
        let targetView: UIView = UIApplication.shared.delegate!.window!!
        targetView.addSubview(backgroundView)
        CMBaseCustomView.addFillLayoutConstrains(for: backgroundView)
        if let listener = blockerView as? CMBlockViewProtocol,
            let action = listener.blockViewControllerWillAppear {
            action(self, animation)
        }
        if animation && backgroundView.superview == nil {
            backgroundView.alpha = 0
            backgroundView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            UIView.setAnimationCurve(.easeOut)
            UIView.animate(withDuration: 0.2, animations: {
                guard let me = wSelf else { return }
                me.backgroundView.alpha = 1.0
                me.backgroundView.transform = CGAffineTransform.identity
            }, completion: {_ in
                completionBlock()
            })
        } else {
            backgroundView.alpha = 1.0
            completionBlock()
        }
    }

    public func doHiding(animation: Bool, isTemporary: Bool, isForced: Bool, completion: @escaping () -> Void) {
        weak var wSelf = self
        if let listener = blockerView as? CMBlockViewProtocol,
            let action = listener.blockViewControllerWillDisappear {
            action(self, animation)
        }
        let completionBlock: (Bool) ->Void = {(_) in
            guard let me = wSelf else { return }
            me.backgroundView.removeFromSuperview()
            me.backgroundView.alpha = 1.0
            if let listener = me.blockerView as? CMBlockViewProtocol,
                let action = listener.blockViewControllerDidDisappear {
                action(me, animation)
            }
            completion()
        }
        if animation && backgroundView.superview != nil {
            UIView.setAnimationCurve(.easeIn)
            UIView.animate(withDuration: 0.2, animations: {
                wSelf?.backgroundView.alpha = 0
            }, completion:completionBlock )
        } else {
            completionBlock(true)
        }
    }
    
}
