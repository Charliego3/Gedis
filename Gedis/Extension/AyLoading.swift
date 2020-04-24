//
//  AyLoading.swift
//  Gedis
//
//  Created by whimthen on 2020/4/24.
//  Copyright © 2020 whimthen. All rights reserved.
//

import Cocoa

extension NSView: AyLoadingCompatible, AyLoadingAction { }

public typealias AnimatedCompleted = () -> Void

public final class AyLoading<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol AyLoadingCompatible {
    associatedtype CompatibleType
    var ay: CompatibleType { get }
}

public extension AyLoadingCompatible {
    var ay: AyLoading<Self> {
        get { return AyLoading(self) }
    }
}

public protocol AyLoadingAction {
    func startLoading(message: String?) -> Bool
    func stopLoading() -> Bool
}

public extension AyLoadingAction {
    func startLoading(message: String?) -> Bool {
        return false
    }
    
    func stopLoading() -> Bool {
        return false
    }
}
