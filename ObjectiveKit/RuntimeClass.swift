import Foundation

/**
 A class created at runtime.
 - Migrator: ISHIKAWA Koutarou
 - Migrated from Swift 3 to Swift 5: 2020/06/19
 - Migrate Copyright: © 2020 ISHIKAWA Koutarou. All rights reserved.
 - Original Created: 2016/11/12
 - Original Copyright: © 2016 Roy Marmelstein All rights reserved. This software is licensed under the MIT License. Full details can be found in the README.
 */
public class RuntimeClass: NSObject, ObjectiveKitRuntimeModification {

    public var internalClass: AnyClass

    private var registered: Bool = false


	//MARK: - Lifecycle

    /// Init
    /// - Parameter superclass: Superclass to inherit from.
    public init(superclass: AnyClass = NSObject.classForCoder()) {
        let name = NSUUID().uuidString
		self.internalClass = objc_allocateClassPair(superclass, name, 0)!
    }


	//MARK: - Dynamic class creation

    /// Add ivar to the newly created class. You can only add ivars before a class is registered.
    /// - Parameters:
    ///   - name: Ivar name.
    ///   - type: Ivar type.
    public func addIvar(_ name: String, type: ObjectiveType) {
		assert(self.registered == false, "You can only add ivars before a class is registered")
        let rawEncoding = type.encoding()
        var size: Int = 0
        var alignment: Int = 0
        NSGetSizeAndAlignment(rawEncoding, &size, &alignment)
        class_addIvar(self.internalClass, name, size, UInt8(alignment), rawEncoding)
    }


    /// Register class. Required before usage. Happens automatically on allocate.
    public func register() {
        if self.registered == false {
            self.registered =  true
            objc_registerClassPair(self.internalClass)
        }
    }

    /// Allocate an instance of a new custom class at runtime.
    /// - Returns: Custom class object.
    public func allocate() -> NSObject {
        self.register()
        return self.internalClass.alloc() as! NSObject
    }


	//MARK: - ObjectiveKitRuntimeModification (Runtime modification)

	public func addSelector(_ selector: Selector, from originalClass: AnyClass) {
		guard let method: Method = class_getInstanceMethod(originalClass, selector), let typeEncoding: UnsafePointer<Int8> = method_getTypeEncoding(method) else {
			return
		}
		let implementation: IMP = method_getImplementation(method)
		let string: String = String.init(cString: typeEncoding)
		class_addMethod(self.internalClass, selector, implementation, string)
	}

	public func addMethod(_ identifier: String, implementation: @escaping @convention(block) () -> Void) {
		let blockObject: AnyObject = unsafeBitCast(implementation, to: AnyObject.self)
		let implementation: IMP = imp_implementationWithBlock(blockObject)
		let selector: Selector = NSSelectorFromString(identifier)
		let encoding: String = "v@:f"
		class_addMethod(self.internalClass, selector, implementation, encoding)
	}

	public func exchangeSelector(_ aSelector: Selector, with otherSelector: Selector) {
		let method: Method? = class_getInstanceMethod(self.internalClass, aSelector)
		let otherMethod: Method? = class_getInstanceMethod(self.internalClass, otherSelector)
		method_exchangeImplementations(method!, otherMethod!)
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
