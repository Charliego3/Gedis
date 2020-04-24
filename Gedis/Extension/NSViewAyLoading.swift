//
//  NSViewAyLoading.swift
//  Gedis
//
//  Created by whimthen on 2020/4/24.
//  Copyright © 2020 whimthen. All rights reserved.
//

import Cocoa

public extension AyLoading where Base: NSView {
    
    func addSubview(_ view: NSView, animated: Bool, completed: AnimatedCompleted? = nil) {
        let originAlpha = view.alphaValue
        view.alphaValue = 0
        base.addSubview(view)
        let animations: (NSAnimationContext) -> Void = { context in
            context.duration = animated ? 0.3 : 0.0
            view.animator().alphaValue = originAlpha
        }
        let completion: () -> Void = {
            completed?()
        }
        NSAnimationContext.runAnimationGroup(animations, completionHandler: completion)
    }
    
    func removeFromSuperview(animated: Bool, completed: AnimatedCompleted? = nil) {
        let originAlpha = base.alphaValue
        let animations: (NSAnimationContext) -> Void = { [weak base] context in
            context.duration = animated ? 0.3 : 0.0
            base?.animator().alphaValue = 0.0
        }
        let completion: () -> Void = { [weak base] in
            base?.alphaValue = originAlpha
            base?.removeFromSuperview()
            completed?()
        }
        NSAnimationContext.runAnimationGroup(animations, completionHandler: completion)
    }
}

private var indicatorViewTempKey: Void?

extension AyLoading where Base: NSView {
    
    private var indicatorViewTemp: IndicatorView? {
        get {
            return objc_getAssociatedObject(base, &indicatorViewTempKey) as? IndicatorView
        }
        set {
            objc_setAssociatedObject(base, &indicatorViewTempKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var indicatorView: IndicatorView {
        if let val = indicatorViewTemp {
            return val
        }
        let indicator = IndicatorView()
        indicatorViewTemp = indicator
        return indicator
    }
    
    @discardableResult
    public func startLoading(message: String? = nil) -> Bool {
        guard !indicatorView.isLoading else {
            return false
        }
        startAnimation(message)
        return true
    }
    
    @discardableResult
    public func stopLoading() -> Bool {
        guard indicatorView.isLoading else {
            return false
        }
        stopAnimation()
        return true
    }
    
    func startAnimation(_ message: String?) {
        setupIndicatorView()
        indicatorView.startAnimating()
        indicatorView.message = message
    }
    
    func stopAnimation(completed: AnimatedCompleted? = nil) {
        indicatorView.stopAnimating(completed: completed)
    }
    
    private func setupIndicatorView() {
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        base.addSubview(indicatorView)
        let centerX = NSLayoutConstraint(item: indicatorView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: base,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0.0)
        let centerY = NSLayoutConstraint(item: indicatorView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: base,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0.0)
        base.addConstraint(centerX)
        base.addConstraint(centerY)
    }
    
}
