/**
 @file      CMPopupController+Defaults.swift
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

import UIKit

extension CMPopupController {
    
    // MARK: - Default layout actions
    
    /** Layout **popupView** aligned center to its superview, size constraints use its original frame size.
     
     +------+
     | +--+ |
     | |XX| |
     | +--+ |
     +------+
     */
    @objc public static let layoutCenter: CMPopupAction = {(popup, finishAction) in
        let containerView: UIView = popup.popupView.superview!
        let popupView: UIView = popup.popupView
        var constraint: NSLayoutConstraint = NSLayoutConstraint(item: popupView, attribute: .centerX,
                                                                relatedBy: .equal,
                                                                toItem: containerView, attribute: .centerX,
                                                                multiplier: 1.0, constant: 0)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "CenterX"
        containerView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: popupView, attribute: .centerY,
                                        relatedBy: .equal,
                                        toItem: containerView, attribute: .centerY,
                                        multiplier: 1.0, constant: 0)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "CenterY"
        containerView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: popupView, attribute: .width,
                                        relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute,
                                        multiplier: 1.0, constant: popupView.frame.size.width)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Width"
        popupView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: popupView, attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute,
                                        multiplier: 1.0, constant: popupView.frame.size.height)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Height"
        popupView.addConstraint(constraint)
    }
    
    /** Layout **popupView** aligned top to its superview, width equal superview width,
     height constraints use its original frame size.
     
     +------+
     |XXXXXX|
     +------+
     |      |
     +------+
     */
    @objc public static let layoutTop: CMPopupAction = {(popup, finishAction) in
        let containerView: UIView = popup.popupView.superview!
        let popupView: UIView = popup.popupView
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "|[view]|", options: NSLayoutFormatOptions(),
                                                         metrics: nil, views: ["view": popupView])
        var i = 0
        for constraint in constraints {
            constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Horizontal\(i)"
            i += 1
        }
        containerView.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]", options: NSLayoutFormatOptions(),
                                                     metrics: nil, views: ["view": popupView])
        i = 0
        for constraint in constraints {
            constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Vertical\(i)"
            i += 1
        }
        containerView.addConstraints(constraints)
        let constraint = NSLayoutConstraint(item: popupView, attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil, attribute: .notAnAttribute,
                                            multiplier: 1.0, constant: popupView.frame.size.height)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Height"
        popupView.addConstraint(constraint)
    }
    
    /** Layout **popupView** aligned bottom to its superview, width equal superview width,
     height constraints use its original frame size.
     
     +------+
     |      |
     +------+
     |XXXXXX|
     +------+
     */
    @objc public static let layoutBottom: CMPopupAction = {(popup, finishAction) in
        let containerView: UIView = popup.popupView.superview!
        let popupView: UIView = popup.popupView
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "|[view]|", options: NSLayoutFormatOptions(),
                                                         metrics: nil, views: ["view": popupView])
        var i = 0
        for constraint in constraints {
            constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Horizontal\(i)"
            i += 1
        }
        containerView.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[view]|", options: NSLayoutFormatOptions(),
                                                     metrics: nil, views: ["view": popupView])
        i = 0
        for constraint in constraints {
            constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Vertical\(i)"
            i += 1
        }
        containerView.addConstraints(constraints)
        let constraint = NSLayoutConstraint(item: popupView, attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil, attribute: .notAnAttribute,
                                            multiplier: 1.0, constant: popupView.frame.size.height)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Height"
        popupView.addConstraint(constraint)
    }
    
    /** Layout **popupView** aligned left side to its superview, height equal superview height,
     width constraints use its original frame size.
     
     +--+---+
     |XX|   |
     |XX|   |
     |XX|   |
     +--+---+
     */
    @objc public static let layoutLeft: CMPopupAction = {(popup, finishAction) in
        let containerView: UIView = popup.popupView.superview!
        let popupView: UIView = popup.popupView
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "|[view]", options: NSLayoutFormatOptions(),
                                                         metrics: nil, views: ["view": popupView])
        var i = 0
        for constraint in constraints {
            constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Horizontal\(i)"
            i += 1
        }
        containerView.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutFormatOptions(),
                                                     metrics: nil, views: ["view": popupView])
        i = 0
        for constraint in constraints {
            constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Vertical\(i)"
            i += 1
        }
        containerView.addConstraints(constraints)
        let constraint = NSLayoutConstraint(item: popupView, attribute: .width,
                                            relatedBy: .equal,
                                            toItem: nil, attribute: .notAnAttribute,
                                            multiplier: 1.0, constant: popupView.frame.size.width)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Width"
        popupView.addConstraint(constraint)
    }
    
    /** Layout **popupView** aligned right side to its superview, height equal superview height,
     width constraints use its original frame size.
     
     +---+--+
     |   |XX|
     |   |XX|
     |   |XX|
     +---+--+
     */
    @objc public static let layoutRight: CMPopupAction = {(popup, finishAction) in
        let containerView: UIView = popup.popupView.superview!
        let popupView: UIView = popup.popupView
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "[view]|", options: NSLayoutFormatOptions(),
                                                         metrics: nil, views: ["view": popupView])
        var i = 0
        for constraint in constraints {
            constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Horizontal\(i)"
            i += 1
        }
        containerView.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutFormatOptions(),
                                                     metrics: nil, views: ["view": popupView])
        i = 0
        for constraint in constraints {
            constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Vertical\(i)"
            i += 1
        }
        containerView.addConstraints(constraints)
        let constraint = NSLayoutConstraint(item: popupView, attribute: .width,
                                            relatedBy: .equal,
                                            toItem: nil, attribute: .notAnAttribute,
                                            multiplier: 1.0, constant: popupView.frame.size.width)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Width"
        popupView.addConstraint(constraint)
    }
    
    /** Layout **popupView** using original frame.
     
     +-------+
     | +--+  |
     | |XX|  |
     | +--+  |
     |       |
     +-------+
     */
    @objc public static let layoutAsFrame: CMPopupAction = {(popup, finishAction) in
        let containerView: UIView = popup.popupView.superview!
        let popupView: UIView = popup.popupView
        var constraint: NSLayoutConstraint = NSLayoutConstraint(item: popupView, attribute: .leading,
                                                                relatedBy: .equal,
                                                                toItem: containerView, attribute: .leading,
                                                                multiplier: 1.0, constant: popupView.frame.origin.x)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Leading"
        containerView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: popupView, attribute: .top,
                                        relatedBy: .equal,
                                        toItem: containerView, attribute: .top,
                                        multiplier: 1.0, constant: popupView.frame.origin.y)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Top"
        containerView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: popupView, attribute: .width,
                                        relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute,
                                        multiplier: 1.0, constant: popupView.frame.size.width)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Width"
        popupView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: popupView, attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute,
                                        multiplier: 1.0, constant: popupView.frame.size.height)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Height"
        popupView.addConstraint(constraint)
    }
    
    /** Layout **popupView** using layoutParams as UIEdgeInset.
     
     +-------+
     | +--+  |
     | |XX|  |
     | +--+  |
     |       |
     +-------+
     */
    @objc public static let layoutInsets: CMPopupAction = {(popup, finishAction) in
        guard let insets = popup.layoutParams as? UIEdgeInsets else {
            layoutAsFrame(popup, finishAction)
            return
        }
        let containerView: UIView = popup.popupView.superview!
        let popupView: UIView = popup.popupView
        var constraint: NSLayoutConstraint = NSLayoutConstraint(item: popupView, attribute: .leading,
                                                                relatedBy: .equal,
                                                                toItem: containerView, attribute: .leading,
                                                                multiplier: 1.0, constant: insets.left)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Left"
        containerView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: popupView, attribute: .top,
                                        relatedBy: .equal,
                                        toItem: containerView, attribute: .top,
                                        multiplier: 1.0, constant: insets.top)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Top"
        containerView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: popupView, attribute: .trailing,
                                        relatedBy: .equal,
                                        toItem: containerView, attribute: .trailing,
                                        multiplier: 1.0, constant: -insets.right)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Right"
        containerView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: popupView, attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: containerView, attribute: .bottom,
                                        multiplier: 1.0, constant: -insets.bottom)
        constraint.identifier = CMPopupController.kCMPopupLayoutConstraintPrefix + "Bottom"
        containerView.addConstraint(constraint)
    }
    
    // MARK: - Default showing animation actions
    
    /** Transformt to show popup like model UIAlertController */
    @objc public static let showingAnimationPushCenter: CMPopupAction = {(popup, finishAction) in
        let bkgView = popup.popupView.superview!
        bkgView.alpha = 0
        popup.popupView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.setAnimationCurve(.easeIn)
        UIView.animate(withDuration: popup.animationDuration, animations: {
            bkgView.alpha = 1.0
            popup.popupView.transform = CGAffineTransform.identity
        }, completion: {_ in
            if let action = finishAction {
                action()
            }
        })
    }
    
    /** Using scale transform to animate showing popup from center from small form to true form,
     similar old UIAlertView animation. */
    @objc public static let showingAnimationPopCenter: CMPopupAction = {(popup, finishAction) in
        let bkgView = popup.popupView.superview!
        bkgView.alpha = 0
        popup.popupView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.setAnimationCurve(.easeOut)
        UIView.animate(withDuration: popup.animationDuration * 2.0 / 3.0, animations: {
            bkgView.alpha = 1.0
            popup.popupView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: {_ in
            UIView.setAnimationCurve(.easeIn)
            UIView.animate(withDuration: popup.animationDuration / 3.0, animations: {
                popup.popupView.transform = CGAffineTransform.identity
            }, completion: {_ in
                if let action = finishAction {
                    action()
                }
            })
        })
    }

    private class func execShowingAnimationTranslation(translation: CGAffineTransform, popup: CMPopupController, finishAction: (() -> Void)?){
        let bkgView = popup.popupView.superview!
        bkgView.alpha = 0
        popup.popupView.alpha = 0
        popup.popupView.transform = translation
        UIView.setAnimationCurve(.easeOut)
        UIView.animate(withDuration: popup.animationDuration, animations: {
            bkgView.alpha = 1.0
            popup.popupView.alpha = 1.0
            popup.popupView.transform = CGAffineTransform.identity
        }, completion: {_ in
            if let action = finishAction {
                action()
            }
        })
    }
    
    /** Use translation transform to slide popup view verticaly down */
    @objc public static let showingAnimationDropDown: CMPopupAction = {(popup, finishAction) in
        CMPopupController.execShowingAnimationTranslation(translation: CGAffineTransform(translationX: 0, y: -popup.popupView.frame.size.height),
                                                          popup: popup, finishAction: finishAction)
    }
    
    /** Use translation transform to slide popup view verticaly up */
    @objc public static let showingAnimationPullUp: CMPopupAction = {(popup, finishAction) in
        CMPopupController.execShowingAnimationTranslation(translation: CGAffineTransform(translationX: 0, y: popup.popupView.frame.size.height),
                                                          popup: popup, finishAction: finishAction)
    }
    
    /** Use translation transform to slide popup view horizontaly from left to right */
    @objc public static let showingAnimationSlideLeftToRight: CMPopupAction = {(popup, finishAction) in
        CMPopupController.execShowingAnimationTranslation(translation: CGAffineTransform(translationX: -popup.popupView.frame.size.width, y: 0),
                                                          popup: popup, finishAction: finishAction)
    }
    
    /** Use translation transform to slide popup view horizontaly from right to left */
    @objc public static let showingAnimationSlideRightToLeft: CMPopupAction = {(popup, finishAction) in
        CMPopupController.execShowingAnimationTranslation(translation: CGAffineTransform(translationX: popup.popupView.frame.size.height, y: 0),
                                                          popup: popup, finishAction: finishAction)
    }
    
    // MARK: - Default hiding animation actions
    
    /** Using alpha to fade out popup */
    @objc public static let hiddingAnimationPushCenter: CMPopupAction = {(popup, finishAction) in
        UIView.setAnimationCurve(.easeIn)
        UIView.animate(withDuration: popup.animationDuration, animations: {
            popup.popupView.superview!.alpha = 0
            popup.popupView.alpha = 0
        }, completion: {_ in
            if let action = finishAction {
                action()
            }
        })
    }
    
    /** Using scale transform to hide popup from center by scale to small */
    @objc public static let hiddingAnimationPopCenter: CMPopupAction = {(popup, finishAction) in
        UIView.setAnimationCurve(.easeIn)
        UIView.animate(withDuration: popup.animationDuration * 2.0 / 3.0, animations: {
            popup.popupView.superview!.alpha = 0
            popup.popupView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: {_ in
            if let action = finishAction {
                action()
            }
        })
    }
    
    private class func execHidingAnimationTranslation(translation: CGAffineTransform, popup: CMPopupController, finishAction: (() -> Void)?){
        UIView.setAnimationCurve(.easeIn)
        UIView.animate(withDuration: popup.animationDuration, animations: {
            popup.popupView.superview!.alpha = 0
            popup.popupView.alpha = 0
            popup.popupView.transform = translation
        }, completion: {_ in
            if let action = finishAction {
                action()
            }
        })
    }
    
    /**  */
    @objc public static let hiddingAnimationDropDown: CMPopupAction = {(popup, finishAction) in
        CMPopupController.execHidingAnimationTranslation(translation: CGAffineTransform(translationX: 0, y: popup.popupView.frame.size.height),
                                                         popup: popup, finishAction: finishAction)
    }
    
    /** Using translation transform to slide popup verticaly up */
    @objc public static let hiddingAnimationPullUp: CMPopupAction = {(popup, finishAction) in
        CMPopupController.execHidingAnimationTranslation(translation: CGAffineTransform(translationX: 0, y: -popup.popupView.frame.size.height),
                                                         popup: popup, finishAction: finishAction)
    }
    
    /**  */
    @objc public static let hiddingAnimationSlideLeftToRight: CMPopupAction = {(popup, finishAction) in
        CMPopupController.execHidingAnimationTranslation(translation: CGAffineTransform(translationX: popup.popupView.frame.size.width, y: 0),
                                                         popup: popup, finishAction: finishAction)
    }
    
    /**  */
    @objc public static let hiddingAnimationSlideRightToLeft: CMPopupAction = {(popup, finishAction) in
        CMPopupController.execHidingAnimationTranslation(translation: CGAffineTransform(translationX: -popup.popupView.frame.size.width, y: 0),
                                                         popup: popup, finishAction: finishAction)
    }
    
    // MARK: - Short functions to configure
    
    /** Configure to layout, show, hide like UIAlertViewController */
    @objc public func selfSetupPushCenter(){
        animationDuration = 0.2
        layoutAction = CMPopupController.layoutCenter
        showingAnimationAction = CMPopupController.showingAnimationPushCenter
        hidingAnimationAction = CMPopupController.hiddingAnimationPushCenter
    }
    
    /** Configure to layout, show, hide like old UIAlertView */
    @objc public func selfSetupPopCenter(){
        animationDuration = 0.3
        layoutAction = CMPopupController.layoutCenter
        showingAnimationAction = CMPopupController.showingAnimationPopCenter
        hidingAnimationAction = CMPopupController.hiddingAnimationPopCenter
    }
    
    /** Configure to layout, show, hide popup on top side */
    @objc public func selfSetupDropFromTop(){
        animationDuration = 0.2
        layoutAction = CMPopupController.layoutTop
        showingAnimationAction = CMPopupController.showingAnimationDropDown
        hidingAnimationAction = CMPopupController.hiddingAnimationPullUp
    }
    
    /** Configure to layout, show, hide popup on bottom side */
    @objc public func selfSetupPullFromBottom(){
        animationDuration = 0.2
        layoutAction = CMPopupController.layoutBottom
        showingAnimationAction = CMPopupController.showingAnimationPullUp
        hidingAnimationAction = CMPopupController.hiddingAnimationDropDown
    }
    
    /** Configure to layout, show, hide popup on left side */
    @objc public func selfSetupSlideFromLeft(){
        animationDuration = 0.2
        layoutAction = CMPopupController.layoutLeft
        showingAnimationAction = CMPopupController.showingAnimationSlideLeftToRight
        hidingAnimationAction = CMPopupController.hiddingAnimationSlideRightToLeft
    }
    
    /** Configure to layout, show, hide popup on top side */
    @objc public func selfSetupSlideFromRight(){
        animationDuration = 0.2
        layoutAction = CMPopupController.layoutRight
        showingAnimationAction = CMPopupController.showingAnimationSlideRightToLeft
        hidingAnimationAction = CMPopupController.hiddingAnimationSlideLeftToRight
    }
    
}
