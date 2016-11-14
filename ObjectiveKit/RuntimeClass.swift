//
//  RuntimeClass.swift
//  ObjectiveKit
//
//  Created by Roy Marmelstein on 12/11/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

/// A class created at runtime.
public class RuntimeClass: NSObject {

    private var internalClass: AnyClass
    private var registered: Bool = false

    /// Init
    ///
    /// - Parameter superclass: Superclass to inherit from.
    public init(superclass: AnyClass = NSObject.classForCoder()) {
        let name = NSUUID().uuidString
        self.internalClass = objc_allocateClassPair(superclass, name, 0)
    }

    /// Register class. Required before usage. Happens automatically on allocate.
    public func registerClass() {
        if registered == false {
            registered =  true
            objc_registerClassPair(internalClass)
        }
    }

    /// Allocate an instance of a new custom class at runtime.
    ///
    /// - Returns: Custom class object.
    public func allocate() -> NSObject {
        self.registerClass()
        return internalClass.alloc() as! NSObject
    }

}
