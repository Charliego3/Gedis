//
//  NSButtonAyLoading.swift
//  Gedis
//
//  Created by whimthen on 2020/4/24.
//  Copyright © 2020 whimthen. All rights reserved.
//

import Cocoa

private var subViewsTempKey: Void?

extension AyLoading where Base: NSButton {
    
    private var subViewsTemp: [NSView] {
        get {
            return objc_getAssociatedObject(base, &subViewsTempKey) as? [NSView] ?? []
        }
        set {
            objc_setAssociatedObject(base, &subViewsTempKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @discardableResult
    public func startLoading(message: String? = nil) -> Bool {
        guard !base.ay.indicatorView.isLoading else { return false }
        base.isEnabled = false
        prepareStartLoading()
        base.ay.startAnimation(message)
        return true
    }
    
    @discardableResult
    public func stopLoading() -> Bool {
        guard base.ay.indicatorView.isLoading else { return false }
        prepareStopLoading()
        base.ay.stopAnimation { [weak base] in
            base?.isEnabled = true
        }
        return true
    }
    
    private func prepareStartLoading() {
        subViewsTemp = base.subviews.filter {
            "NSButtonTextField" == String(describing: type(of: $0))
        }
        for item in subViewsTemp {
            item.ay.removeFromSuperview(animated: true)
        }
    }
    
    private func prepareStopLoading() {
        for item in subViewsTemp {
            base.ay.addSubview(item, animated: true)
        }
    }
}
