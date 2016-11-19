//
//  RuntimeClass.swift
//  ObjectiveKit
//
//  Created by Roy Marmelstein on 12/11/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

/// A class created at runtime.
public class RuntimeClass: NSObject, ObjectiveKitRuntimeModification {

    public var internalClass: AnyClass

    private var registered: Bool = false

    // MARK: Lifecycle

    /// Init
    ///
    /// - Parameter superclass: Superclass to inherit from.
    public init(superclass: AnyClass = NSObject.classForCoder()) {
        let name = NSUUID().uuidString
        self.internalClass = objc_allocateClassPair(superclass, name, 0)
    }

    // MARK: Dynamic class creation

    /// Add ivar to the newly created class. You can only add ivars before a class is registered.
    ///
    /// - Parameters:
    ///   - name: Ivar name.
    ///   - type: Ivar type.
    public func addIvar(_ name: String, type: ObjectiveType) {
        assert(registered == false, "You can only add ivars before a class is registered")
        let rawEncoding = type.encoding()
        var size: Int = 0
        var alignment: Int = 0
        NSGetSizeAndAlignment(rawEncoding, &size, &alignment)
        class_addIvar(self.internalClass, name, size, UInt8(alignment), rawEncoding)
    }


    /// Register class. Required before usage. Happens automatically on allocate.
    public func register() {
        guard registered == false else { return }
        registered =  true
        objc_registerClassPair(internalClass)
    }

    /// Allocate an instance of a new custom class at runtime.
    ///
    /// - Returns: Custom class object.
    public func allocate() -> NSObject {
        self.register()
        return internalClass.alloc() as! NSObject
    }

}


/// Objective Type
///
/// - NSString: NSString
/// - NSObject: NSObject
/// - Float: Float
/// - Int: Int
/// - Double: Double
/// - Void: Void
public enum ObjectiveType: Int {
    case NSString
    case NSObject
    case Float
    case Int
    case Double
    case Void

    func encoding() -> String {
        switch self {
        case .NSString: return "@"
        case .NSObject: return "@"
        case .Float: return "f"
        case .Int: return "i"
        case .Double: return "d"
        case .Void: return "v"
        }
    }

}

