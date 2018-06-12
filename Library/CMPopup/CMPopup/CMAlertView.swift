/**
 @file      CMAlertView.swift
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

import Foundation
import SWUtils
import RSUtils

/** CMAlertView event receiver protocol */
@objc public protocol CMAlertViewDelegate {
    /** Before show alert view */
    @objc optional func alertViewWillAppear(_ alertView: CMAlertView, animated: Bool)
    /** When alert view finish to display */
    @objc optional func alertViewDidAppear(_ alertView: CMAlertView, animated: Bool)
    /** Before hide alert view */
    @objc optional func alertViewWillDisappear(_ alertView: CMAlertView, animated: Bool)
    /** When alert view finish to hide */
    @objc optional func alertViewDidDisappear(_ alertView: CMAlertView, animated: Bool)
    /** User did select a button & alert view dismissed */
    func alertViewDidSelect(_ alertView: CMAlertView, index: Int)
}

// MARK: -
/** Wrap of UIAlertController with CMPopupManager.
 
 2 working modes:
 - Mode 1: use custom window of CMPopupManager to show alert.
 - Mode 2: If presenter view controller is provided, use that view controller to present alert view controller.
 If no view controller is given, use the top view controller to present alert view controller.
 
 Default init function make alert view with style Alert and mode 1. For other modes, use other init functions.
 */
public class CMAlertView: NSObject, CMPopupClient {
    
    /** Alert title */
    @objc public var title: String?
    /** Alert message */
    @objc public var message: String?
    /** Title of Destructive button (use with Action Sheet) */
    @objc public var destructiveButton: String?
    /** Title of Cancel button. If not provided on iPad, Action Sheet will add a default button for Cancel action */
    @objc public var cancelButton: String?
    /** Title of other buttons */
    @objc public var otherButtons: [String]?
    /** Map for button action => Button title: Action */
    public var buttonActions: [String: (String, Int) -> Void]?
    /** Addtional info of CMAlertView, similar with view `tag` */
    @objc public var metaInfo: Any?
    /** Event receiver */
    @objc public weak var delegate: CMAlertViewDelegate?
    /** Prefer action for Alert style - valid value from 0, available from iOS 9.0 */
    @objc public var preferActionIndex: Int = -1
    /** Target to show Action Sheet in iIpad. */
    @objc public var popoverTargetView: UIView?
    /** The rectangle in the specified view in which to anchor the popover. Note that the default view frame (0, screen-height, screen-width, 1).*/
    @objc public var popoverTargetFrame: CGRect = CGRect.null
    /** Call `Cancel` action/delegate if popopu is forced to close. */
    @objc public var isForceCloseAsCancel = true

    @objc public weak var presenterViewController: UIViewController?
    
    private let style: UIAlertControllerStyle
    private var alertView: UIAlertController?
    private var textFieldsConfiguration = [(UITextField) -> Void]()

    public var operationQueue: OperationQueue?

    /// Bridge property of UIAlertController
    @objc public var textFields: [UITextField]? {
        return alertView?.textFields
    }

    /// Bridge function of UIAlertController
    public func addTextField(_ configuration: @escaping (UITextField) -> Void) {
        textFieldsConfiguration.append(configuration)
    }

    public override var description: String {
        var meta = "<nil>"
        if let info = metaInfo {
            meta =  "\(info)"
        }
        return "\(super.description) meta=\(meta) content=\((title ?? message) ?? "<nil>")"
    }
    
    // MARK: - Initialize
    
    /** Create new alert view with style Alert and use custom window of CMPopupManager to show up */
    @objc public override init() {
        style = .alert
        super.init()
    }
    
    /** Create new alert view
     
     Parameters:
     - alertStyle: Alert style (Alert/Action sheet)
     - useCustomWindow: If true, use custom window of CMPopupManager to show alert.
     If false, find top view controller (from RSUtils) to present alert immediately.
     */
    @objc public init(alertStyle: UIAlertControllerStyle) {
        style = alertStyle
        super.init()
    }
    
    /** Create new alert view
     
     Parameters:
     - alertStyle: Alert style (Alert/Action sheet)
     - presenter: View controller to present alert view
     */
    @objc public init(alertStyle: UIAlertControllerStyle, useViewControllerToPresent presenter: UIViewController) {
        presenterViewController = presenter
        style = alertStyle
        super.init()
    }
    
    // MARK: - Private
    
    private func getPopoverTarget() -> UIView {
        if let view = popoverTargetView {
            return view
        } else if let controller = presenterViewController {
            return controller.view
        } else if let topVC = UIViewController.getTop() {
            return topVC.view
        }
        return UIApplication.shared.delegate!.window!!
    }
    
    private func makeAlertController() {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        weak var wSelf = self
        let addAlertAction = {(title: String, style: UIAlertActionStyle, index: Int, logName: String) in
            let action = UIAlertAction(title: title, style: style, handler: {(sender) in
                guard let me = wSelf else { return }
                if let delegate = me.delegate, let action = delegate.alertViewWillDisappear {
                    action(me, true)
                }
                if let delegate = me.delegate {
                    delegate.alertViewDidSelect(me, index: index)
                }
                if let actionMap = me.buttonActions, let action = actionMap[title] {
                    action(title, index)
                }
                CMPopupManager.sharedInstance.registToHide(popup: me, animation: true, isAlreadyHidden: true)
            })
            alert.addAction(action)
            if #available(iOS 9.0, *), wSelf?.preferActionIndex == index {
                alert.preferredAction = action
            }
        }
        
        var index = 0
        if let destructive = destructiveButton {
            let num = index
            addAlertAction(destructive, .destructive, num, "Destructive")
            index += 1
        }
        if let buttons = otherButtons {
            for caption in buttons {
                let num = index
                addAlertAction(caption, .default, num, "Button")
                index += 1
            }
        }
        if let cancel = cancelButton {
            let num = index
            addAlertAction(cancel, .cancel, num, "Cancel")
        } else if style == .actionSheet && UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            let num = index
            addAlertAction("", .cancel, num, "Default Cancel for iPad")
        }
        
        if style == .actionSheet && UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            let view = getPopoverTarget()
            let popover = alert.popoverPresentationController!
            popover.sourceView = view
            if !popoverTargetFrame.isNull {
                popover.sourceRect = popoverTargetFrame
            } else if popoverTargetView == nil {
                popover.sourceRect = CGRect(x: view.frame.size.width / 2, y: 0, width: 1, height: 1)
            }
        }
        for action in textFieldsConfiguration {
            alert.addTextField(configurationHandler: action)
        }

        alertView = alert
    }
    
    // MARK: - Public
    
    /**
     Regist to show alert. Alert must be setup before call this
     */
    @objc public func show(_ animated: Bool) {
        CMPopupManager.sharedInstance.registToShow(popup: self, animation: animated)
    }
    
    /** Dismiss alert view */
    @objc public func dismiss(_ animated: Bool) {
       CMPopupManager.sharedInstance.registToHide(popup: self, animation: animated, isAlreadyHidden: false)
    }

    public func doShowing(animation: Bool, isRestoreFromTemporary: Bool, completion: @escaping () -> Void) {
        if alertView == nil { makeAlertController() }
        if !isRestoreFromTemporary, let delegate = self.delegate, let action = delegate.alertViewDidAppear {
            action(self, animation)
        }
        weak var wSelf = self
        let completionBlock = {
            guard let me = wSelf else { return }
            if !isRestoreFromTemporary, let delegate = me.delegate, let action = delegate.alertViewDidAppear {
                action(me, animation)
            }
            completion()
        }
        if let controller = self.presenterViewController {
            controller.presentOnTop(with: alertView!, animated: animation, completion: completionBlock)
        } else {
            UIViewController.presentOnTop(with: alertView!, animated: animation, completion: completionBlock)
        }
    }

    public func doHiding(animation: Bool, isTemporary: Bool, isForced: Bool, completion: @escaping () -> Void) {
        guard let alert = alertView else { return }
        if !isTemporary, let delegate = self.delegate, let action = delegate.alertViewWillDisappear {
            action(self, animation)
        }
        if isForced && isForceCloseAsCancel {
            let actions = alert.actions
            if actions.count > 0 {
                var cancelIndex: Int?
                for index in 0 ..< actions.count {
                    let action = actions[index]
                    if action.style == .cancel {
                        cancelIndex = index
                        break
                    }
                }
                if let index = cancelIndex {
                    if let delegate = self.delegate  {
                        delegate.alertViewDidSelect(self, index: index)
                    }
                    if let title = actions[index].title, let action = buttonActions?[title] {
                        action(title, index)
                    }
                }
            }
        }
        alert.dismiss(animated: animation, completion: {
            completion()
        })
    }
    
}
