//
//  UnregisteredClass.swift
//  ObjectiveKit
//
//  Created by Roy Marmelstein on 11/11/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

typealias ImplementationBlock = @convention(block) () -> Void

/// An object that allows you to introspect and modify classes through the ObjC runtime.
public class ObjectiveClass <T: NSObject> {

    private var internalClass: AnyClass

    init() {
        self.internalClass = T.classForCoder()
    }

    // MARK: Introspection

    /// Get all selectors implemented by the class.
    ///
    /// - Returns: An array of selectors.
    public func allSelectors() -> [Selector] {
        var count: CUnsignedInt = 0
        var selectors = [Selector]()
        let methodList = class_copyMethodList(internalClass, &count)
        for i in (0..<Int(count)) {
            let unwrapped  = methodList?[i].unsafelyUnwrapped
            if let selector = method_getName(unwrapped) {
                selectors.append(selector)
            }
        }
        free(methodList)
        return selectors
    }

    /// Get all protocols implemented by the class.
    ///
    /// - Returns: An array of protocol names.
    public func allProtocols() -> [String] {
        var count: CUnsignedInt = 0
        var protocols = [String]()
        let protocolList = class_copyProtocolList(internalClass, &count)
        for i in (0..<Int(count)) {
            let unwrapped  = protocolList?[i].unsafelyUnwrapped
            if let protocolName = protocol_getName(unwrapped) {
                let string = String(cString: protocolName)
                protocols.append(string)
            }
        }
        return protocols
    }

    /// Get all properties implemented by the class.
    ///
    /// - Returns: An array of property names.
    public func allProperties() -> [String] {
        var count: CUnsignedInt = 0
        var properties = [String]()
        let propertyList = class_copyPropertyList(internalClass, &count)
        for i in (0..<Int(count)) {
            let unwrapped  = propertyList?[i].unsafelyUnwrapped
            if let propretyName = property_getName(unwrapped) {
                let string = String(cString: propretyName)
                properties.append(string)
            }
        }
        free(propertyList)
        return properties
    }

    // MARK: Runtime modification

    /// Add a selector that is implemented on another object to the current class.
    ///
    /// - Parameters:
    ///   - selector: Selector.
    ///   - object: Object implementing the selector.
    public func addSelectorToClass(_ selector: Selector, fromClass originalClass: AnyClass) {
        guard let method = class_getInstanceMethod(originalClass, selector), let implementation = method_getImplementation(method), let typeEncoding = method_getTypeEncoding(method) else {
            return
        }
        let string = String(cString: typeEncoding)
        class_addMethod(internalClass, selector, implementation, string)
    }

    /// Add a custom method to the current class.
    ///
    /// - Parameters:
    ///   - identifier: Selector name.
    ///   - implementation: Implementation as a closure.
    public func addMethodToClass(_ identifier: String, implementation: ImplementationBlock) {
        let blockObject = unsafeBitCast(implementation, to: AnyObject.self)
        let implementation = imp_implementationWithBlock(blockObject)
        let selector = NSSelectorFromString(identifier)
        let encoding = "v@:f"
        class_addMethod(internalClass, selector, implementation, encoding)
    }

    /// Exchange selectors implemented in the current class.
    ///
    /// - Parameters:
    ///   - aSelector: Selector.
    ///   - otherSelector: Selector.
    public func exchangeSelector(_ aSelector: Selector, with otherSelector: Selector) {
        let method = class_getInstanceMethod(internalClass, aSelector)
        let swizzledMethod = class_getInstanceMethod(internalClass, otherSelector)
        method_exchangeImplementations(method, swizzledMethod)
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


