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
public class ObjectiveClass <T: NSObject>: ObjectiveKitRuntimeModification {

    public var internalClass: AnyClass

    // MARK: Lifecycle

    /// Init
    public init() {
        self.internalClass = T.classForCoder()
    }

    // MARK: Introspection

    /// Get all instance variables implemented by the class.
    ///
    /// - Returns: An array of instance variables.
    public var ivars: [String] {
        var count: CUnsignedInt = 0
        var ivars = [String]()
        let ivarList = class_copyIvarList(internalClass, &count)
        for i in 0..<Int(count) {
            let unwrapped  = ivarList?[i].unsafelyUnwrapped
            guard let ivar = ivar_getName(unwrapped) else { continue }
            let string = String(cString: ivar)
            ivars.append(string)
        }
        free(ivarList)
        return ivars
    }


    /// Get all selectors implemented by the class.
    ///
    /// - Returns: An array of selectors.
    public var selectors: [Selector]  {
        var count: CUnsignedInt = 0
        var selectors = [Selector]()
        let methodList = class_copyMethodList(internalClass, &count)
        for i in 0..<Int(count) {
            let unwrapped  = methodList?[i].unsafelyUnwrapped
            guard let selector = method_getName(unwrapped) else { continue }
            selectors.append(selector)
        }
        free(methodList)
        return selectors
    }

    /// Get all protocols implemented by the class.
    ///
    /// - Returns: An array of protocol names.
    public var protocols: [String] {
        var count: CUnsignedInt = 0
        var protocols = [String]()
        let protocolList = class_copyProtocolList(internalClass, &count)
        for i in 0..<Int(count) {
            let unwrapped  = protocolList?[i].unsafelyUnwrapped
            guard let protocolName = protocol_getName(unwrapped) else { continue }
            let string = String(cString: protocolName)
            protocols.append(string)
        }
        return protocols
    }

    /// Get all properties implemented by the class.
    ///
    /// - Returns: An array of property names.
    public var properties: [String] {
        var count: CUnsignedInt = 0
        var properties = [String]()
        let propertyList = class_copyPropertyList(internalClass, &count)
        for i in 0..<Int(count) {
            let unwrapped  = propertyList?[i].unsafelyUnwrapped
            guard let propretyName = property_getName(unwrapped) else { continue }
            let string = String(cString: propretyName)
            properties.append(string)
        }
        free(propertyList)
        return properties
    }

}


