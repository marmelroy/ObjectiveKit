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
    
    private typealias RuntimeCopyingGetter<Type> = (AnyClass?, UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<Type?>!

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
        return self.runtimeStrings(with: { class_copyIvarList($0, $1) }, transform: ivar_getName)
    }

    /// Get all selectors implemented by the class.
    ///
    /// - Returns: An array of selectors.
    public var selectors: [Selector]  {
        return self.runtimeEntities(with: { class_copyMethodList($0, $1) }, transform: method_getName)
    }

    /// Get all protocols implemented by the class.
    ///
    /// - Returns: An array of protocol names.
    public var protocols: [String] {
        return self.runtimeStrings(
            with: { UnsafeMutablePointer(mutating: class_copyProtocolList($0, $1)) },
            transform: protocol_getName
        )
    }

    /// Get all properties implemented by the class.
    ///
    /// - Returns: An array of property names.
    public var properties: [String] {
        return self.runtimeStrings(with: { class_copyPropertyList($0, $1) }, transform: property_getName)
    }
    
    // MARK: Private
    
    private func runtimeEntities<Type, Result>(
        with copyingGetter: RuntimeCopyingGetter<Type>,
        transform: (Type) -> Result?
    )
        -> [Result]
    {
        var cCount: CUnsignedInt = 0
        
        let entities = copyingGetter(self.internalClass, &cCount)
        let count = Int(exactly: cCount) ?? 0
        
        defer { entities?.deallocate(capacity: count) }
        
        return UnsafeMutableBufferPointer(start: entities, count: count)
            .flatMap(identity)
            .flatMap(transform)
    }
    
    private func runtimeStrings<Type>(
        with copyingGetter: RuntimeCopyingGetter<Type>,
        transform: (Type!) -> UnsafePointer<Int8>!
    )
        -> [String]
    {
        return self.runtimeEntities(with: copyingGetter) {
            pure(transform($0)).map(String.init(cString:))
        }
    }
}
