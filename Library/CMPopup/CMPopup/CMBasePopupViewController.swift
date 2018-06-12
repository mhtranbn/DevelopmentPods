/**
 @file      CMBasePopupViewController.swift
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

import UIKit

/**
 Base class for view controllers which are showed as popup.

 The root view of this view controller will be resized to fit with the target view and be showed as the background.
 The content view should be subview of root view.

 **NOTE**: this view controller uses `CMPopupController` to do popup showing, so do not present modally
 an other view controller from this controller.
 */
open class CMBasePopupViewController: UIViewController {

    public var popupController: CMPopupController!
    private var mySelf: CMBasePopupViewController?
    /// Allow user tap background as Cancel event
    @IBInspectable public var isDismissOnBack = false

    public weak var popupOwnerViewController: UIViewController?

    open func makePopupController() -> CMPopupController {
        let popup = CMPopupController(view: self.view)
        popup.showingAnimationAction = CMPopupController.showingAnimationPopCenter
        popup.hidingAnimationAction = CMPopupController.hiddingAnimationPopCenter
        popup.layoutAction = CMPopupController.layoutInsets
        popup.layoutParams = UIEdgeInsets()
        return popup
    }

    private func setupPopupControllerIfNeeded() {
        if popupController != nil { return }
        popupController = makePopupController()
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupPopupControllerIfNeeded()
    }

    /// Show this controller as popup inside target view
    open func popMeUp(animate: Bool, targetView: UIView?) {
        guard mySelf == nil else { return }
        mySelf = self
        setupPopupControllerIfNeeded()
        popupController.hideWhenTapBackground = isDismissOnBack
        popupController.targetView = targetView
        popupController.show(animate)
    }

    /// Show this controller as popup inside target viewcontroller's view
    public func popMeUp(animate: Bool, targetViewController: UIViewController?) {
        guard mySelf == nil else { return }
        popMeUp(animate: animate, targetView: targetViewController?.view)
        popupOwnerViewController = targetViewController
    }

    /// Show this controller as popup inside AppDelegate window
    public func popMeUp(_ animate: Bool) {
        let window = UIApplication.shared.delegate?.window ?? nil
        popMeUp(animate: animate, targetView: window)
    }

    /// Show with animation this controller as popup inside AppDelegate window
    public func popMeUp() {
        popMeUp(true)
    }

    public func popMeDown(_ animate: Bool) {
        guard mySelf != nil else { return }
        popupController.hide(animate)
        mySelf = nil
    }

    public func popMeDown() {
        popMeDown(true)
    }

}
