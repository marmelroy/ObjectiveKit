import Foundation

//typealias ImplementationBlock = @convention(block) () -> Void

/**
 An object that allows you to introspect and modify classes through the ObjC runtime.
 - Migrator: ISHIKAWA Koutarou
 - Migrated from Swift 3 to Swift 5: 2020/06/19
 - Migrate Copyright: © 2020 ISHIKAWA Koutarou. All rights reserved.
 - Original Author: Roy Marmelstein
 - Original Created: 2016/11/11
 - Original Copyright: © 2016 Roy Marmelstein All rights reserved. This software is licensed under the MIT License. Full details can be found in the README.
 */
public class ObjectiveClass <T: NSObject>: ObjectiveKitRuntimeModification {

    public var internalClass: AnyClass


	//MARK: - Lifecycle

    /// Init
    public init() {
        self.internalClass = T.classForCoder()
    }


	//MARK: - Introspection

    /// All instance variables implemented by the class.
    public var ivars: [String] {
        get {
            var count: CUnsignedInt = 0
            var ivars = [String]()
            let ivarList = class_copyIvarList(self.internalClass, &count)
            for i in (0..<Int(count)) {
                let unwrapped: Ivar  = ivarList![i].self
                if let ivar = ivar_getName(unwrapped) {
                    let string = String(cString: ivar)
                    ivars.append(string)
                }
            }
            free(ivarList)
            return ivars
        }
    }

    /// All selectors implemented by the class.
    public var selectors: [Selector]  {
        get {
            var count: CUnsignedInt = 0
            var selectors = [Selector]()
            let methodList = class_copyMethodList(self.internalClass, &count)
            for i in (0..<Int(count)) {
                let unwrapped: Method  = methodList![i].self
				selectors.append(method_getName(unwrapped))
            }
            free(methodList)
            return selectors
        }
    }

    /// All protocols implemented by the class.
    public var protocols: [String] {
        get {
            var count: CUnsignedInt = 0
            var protocols = [String]()
            let protocolList = class_copyProtocolList(self.internalClass, &count)
            for i in (0..<Int(count)) {
                let unwrapped: Protocol  = protocolList![i].self
				let string: String = String.init(cString: protocol_getName(unwrapped))
				protocols.append(string)
            }
            return protocols
        }
    }

    /// All properties implemented by the class.
    public var properties: [String] {
        get {
            var count: CUnsignedInt = 0
            var properties = [String]()
            let propertyList = class_copyPropertyList(self.internalClass, &count)
            for i in (0..<Int(count)) {
                let unwrapped: objc_property_t  = propertyList![i].self
				let string: String = String.init(cString: property_getName(unwrapped))
				properties.append(string)
            }
            free(propertyList)
            return properties
        }
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
