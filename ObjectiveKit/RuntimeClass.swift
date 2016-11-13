//
//  RuntimeClass.swift
//  ObjectiveKit
//
//  Created by Roy Marmelstein on 12/11/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

public class RuntimeClass: NSObject {

    private var internalClass: AnyClass

    var registered: Bool = false

    init(superclass: AnyClass = NSObject.classForCoder()) {
        let name = NSUUID().uuidString
        self.internalClass = objc_allocateClassPair(superclass, name, 0)
    }

    func registerClass() {
        if registered == false {
            registered =  true
            objc_registerClassPair(internalClass)
        }
    }

    func allocate() -> NSObject {
        self.registerClass()
        return internalClass.alloc() as! NSObject
    }


}
