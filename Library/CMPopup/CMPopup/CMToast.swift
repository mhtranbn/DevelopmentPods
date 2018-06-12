/**
 @file      CMToast.swift
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

import UIKit
import RSUtils

public class CMToast: NSObject {
    
    /** Label font. Default System font 17. */
    @objc public static var font = UIFont.systemFont(ofSize: 17)
    /** Text color. Default White. */
    @objc public static var textColor = UIColor.white
    /** Background color. Default Black with alpha 0.6. */
    @objc public static var backgroundColor = UIColor.black.withAlphaComponent(0.7)
    /** Corner radius. Default 5.0. */
    @objc public static var cornerRadius: CGFloat = 5.0
    /** Label shadow color. Default nil. */
    @objc public static var shadowColor: UIColor? = nil
    /** Label shadow offset. Default {1.0 ,1.0}. */
    @objc public static var shadowOffset = CGSize(width: 1.0, height: 1.0)
    /** Limit width of text. Default is 2/3 of screen size. */
    @objc public static var limitWidth: CGFloat = 0
    /** Padding from label and background view. */
    @objc public static var padding: CGFloat = 10.0
    /** Prevent user to tap through. Default not. */
    @objc public static var isLock: Bool = false
    /** Time to show. Default 2.0 second. */
    @objc public static var duration = 2.0
    /** Time to play animation. Default 0.3 second. */
    @objc public static var animationDuration: TimeInterval = 0.3
    /** Force to show as square */
    @objc public static var forceSquare = false
    
    private class func _show(text: String, animation: Bool, image: UIImage?, imageSize: CGSize?) {
        var limitSize: CGFloat!
        if limitWidth > 0 {
            limitSize = limitWidth
        } else {
            limitSize = UIScreen.main.bounds.size.width * 2.0 / 3.0
        }
        let label = UILabel(frame: CGRect(x: padding, y: padding, width: limitSize, height: 10))
        label.backgroundColor = .clear
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = font
        label.lineBreakMode = .byWordWrapping
        label.textColor = textColor
        label.shadowColor = shadowColor
        label.shadowOffset = shadowOffset
        label.translatesAutoresizingMaskIntoConstraints = false
        let textSize = label.textRect(forBounds: CGRect(x: 0, y: 0, width: limitSize, height: CGFloat.greatestFiniteMagnitude),
                                      limitedToNumberOfLines: label.numberOfLines).size
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: textSize.width + 2 * padding, height: textSize.height + 2 * padding))
        backgroundView.backgroundColor = backgroundColor
        backgroundView.layer.cornerRadius = cornerRadius
        backgroundView.clipsToBounds = true
        backgroundView.isUserInteractionEnabled = isLock
        
        var imageView: UIImageView?
        if let image = image {
            imageView = UIImageView(image: image)
            var imgSz: CGSize!
            if let size = imageSize {
                imgSz = size
            } else {
                imgSz = image.size
            }
            imageView!.backgroundColor = .clear
            imageView!.contentMode = .scaleAspectFit
            imageView!.clipsToBounds = true
            imageView!.translatesAutoresizingMaskIntoConstraints = false
            backgroundView.addSubview(imageView!)
            var constraint = NSLayoutConstraint(item: imageView!, attribute: .width, relatedBy: .equal,
                                                toItem: nil, attribute: .notAnAttribute,
                                                multiplier: 1.0, constant: imgSz.width)
            imageView!.addConstraint(constraint)
            constraint = NSLayoutConstraint(item: imageView!, attribute: .height, relatedBy: .equal,
                                            toItem: nil, attribute: .notAnAttribute,
                                            multiplier: 1.0, constant: imgSz.height)
            imageView!.addConstraint(constraint)
            constraint = NSLayoutConstraint(item: imageView!, attribute: .centerX, relatedBy: .equal,
                                            toItem: backgroundView, attribute: .centerX,
                                            multiplier: 1.0, constant: 0)
            backgroundView.addConstraint(constraint)
            var frame = backgroundView.frame
            frame.size.height += padding + imgSz.height
            backgroundView.frame = frame
        }
        
        backgroundView.addSubview(label)
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-padding-[label]-padding-|",
                                                         options: NSLayoutFormatOptions(rawValue: 0),
                                                         metrics: ["padding": padding],
                                                         views: ["label": label])
        backgroundView.addConstraints(constraints)
        if let imageView = imageView {
            constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[image]-padding-[label]-padding-|",
                                                         options: NSLayoutFormatOptions(rawValue: 0),
                                                         metrics: ["padding": padding],
                                                         views: ["label": label, "image": imageView])
        } else {
            constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[label]-padding-|",
                                                         options: NSLayoutFormatOptions(rawValue: 0),
                                                         metrics: ["padding": padding],
                                                         views: ["label": label])
        }
        backgroundView.addConstraints(constraints)
        
        if forceSquare {
            var max = backgroundView.frame.size.width
            if max < backgroundView.frame.size.height { max = backgroundView.frame.size.height }
            let rect = CGRect(x: 0, y: 0, width: max, height: max)
            backgroundView.frame = rect
        }
        
        let popup = CMPopupController(view: backgroundView)
        popup.selfSetupPopCenter()
        popup.animationDuration = animationDuration
        popup.showingAnimationAction = {(popup, finishAction) in
            let bkgView = popup.popupView.superview!
            bkgView.alpha = 0
            UIView.setAnimationCurve(.easeIn)
            UIView.animate(withDuration: popup.animationDuration, animations: {
                bkgView.alpha = 1.0
            }, completion: {_ in
                if let action = finishAction {
                    action()
                }
            })
        }
        popup.hidingAnimationAction = {(popup, finishAction) in
            let bkgView = popup.popupView.superview!
            bkgView.alpha = 1.0
            UIView.setAnimationCurve(.easeOut)
            UIView.animate(withDuration: popup.animationDuration, animations: {
                bkgView.alpha = 0
            }, completion: {_ in
                if let action = finishAction {
                    action()
                }
            })
        }
        popup.backgroundColor = isLock ? .clear : nil
        popup.show(animated: animation, autoHideDuration: duration)
    }
    
    @objc public class func show(_ text: String) {
        _show(text: text, animation: true, image: nil, imageSize: nil)
    }
    
    @objc public class func show(_ text: String, animation: Bool) {
        _show(text: text, animation: animation, image: nil, imageSize: nil)
    }
    
    @objc public class func show(text: String, image: UIImage) {
        _show(text: text, animation: true, image: image, imageSize: image.size)
    }
    
    @objc public class func show(text: String, animation: Bool, image: UIImage, imageSize: CGSize) {
        _show(text: text, animation: animation, image: image, imageSize: imageSize)
    }
    
}
