//
//  RuntimeModification.swift
//  ObjectiveKit
//
//  Created by Roy Marmelstein on 14/11/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

public protocol ObjectiveKitRuntimeModification {

    var internalClass: AnyClass { get }

    // MARK: Runtime modification

    /// Add a selector that is implemented on another object to the current class.
    ///
    /// - Parameters:
    ///   - selector: Selector.
    ///   - originalClass: Object implementing the selector.
    func addSelector(_ selector: Selector, from originalClass: AnyClass)

    /// Add a custom method to the current class.
    ///
    /// - Parameters:
    ///   - identifier: Selector name.
    ///   - implementation: Implementation as a closure.
    func addMethod(_ identifier: String, implementation: ImplementationBlock)

    /// Exchange selectors implemented in the current class.
    ///
    /// - Parameters:
    ///   - aSelector: Selector.
    ///   - otherSelector: Selector.
    func exchangeSelector(_ aSelector: Selector, with otherSelector: Selector)

}

extension ObjectiveKitRuntimeModification {

    public func addSelector(_ selector: Selector, from originalClass: AnyClass) {
        guard let method = class_getInstanceMethod(originalClass, selector), let implementation = method_getImplementation(method), let typeEncoding = method_getTypeEncoding(method) else {
            return
        }
        let string = String(cString: typeEncoding)
        class_addMethod(internalClass, selector, implementation, string)
    }

    public func addMethod(_ identifier: String, implementation: ImplementationBlock) {
        let blockObject = unsafeBitCast(implementation, to: AnyObject.self)
        let implementation = imp_implementationWithBlock(blockObject)
        let selector = NSSelectorFromString(identifier)
        let encoding = "v@:f"
        class_addMethod(internalClass, selector, implementation, encoding)
    }

    public func exchangeSelector(_ aSelector: Selector, with otherSelector: Selector) {
        let method = class_getInstanceMethod(internalClass, aSelector)
        let otherMethod = class_getInstanceMethod(internalClass, otherSelector)
        method_exchangeImplementations(method, otherMethod)
    }

}

public extension NSObject {

    /// A convenience method to perform selectors by identifier strings.
    ///
    /// - Parameter identifier: Selector name.
    public func performMethod(_ identifier: String) {
        perform(NSSelectorFromString(identifier))
    }
}

