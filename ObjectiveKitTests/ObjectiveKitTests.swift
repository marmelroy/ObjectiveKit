import XCTest
import MapKit
@testable import ObjectiveKit

/**
 - Migrator: ISHIKAWA Koutarou
 - Migrated from Swift 3 to Swift 5: 2020/06/19
 - Migrate Copyright: © 2020 ISHIKAWA Koutarou. All rights reserved.
 - Original Created: 2016/11/11
 - Original Copyright: © 2016 Roy Marmelstein All rights reserved. This software is licensed under the MIT License. Full details can be found in the README.
 */
@objc class Subview: UIView {

    dynamic func testSelector() {
        print("test selector")
    }

    dynamic func swizzledSelector(){
        print("swizzled selector")
    }

}

/**
 - Migrator: ISHIKAWA Koutarou
 - Migrated from Swift 3 to Swift 5: 2020/06/19
 - Migrate Copyright: © 2020 ISHIKAWA Koutarou. All rights reserved.
 - Original Created: 2016/11/11
 - Original Copyright: © 2016 Roy Marmelstein All rights reserved. This software is licensed under the MIT License. Full details can be found in the README.
 */
@objc class ObjectiveKitTests: XCTestCase {

    let closureName = "random"

    dynamic func testSelector() {
        print("test selector")
    }

    func testAddClosure() {
        let methodExpectation = expectation(description: "Method was called")

		let objectiveView: ObjectiveClass<UIView> = ObjectiveClass<UIView>()
        objectiveView.addMethod(self.closureName, implementation: {
            methodExpectation.fulfill()
        })

		let view: UIView = UIView()
        view.performMethod(self.closureName)
        waitForExpectations(timeout: 0.1, handler:nil)
    }

    func testAddSelector() {
        let view: UIView = UIView()

		XCTAssertFalse(view.responds(to: #selector(self.testSelector)))

		let objectiveView: ObjectiveClass<UIView> = ObjectiveClass<UIView>()
        objectiveView.addSelector(#selector(self.testSelector), from: self.classForCoder)

		XCTAssert(view.responds(to: #selector(self.testSelector)))
    }

    func testRuntimeClass() {
        let runtimeClass: RuntimeClass = RuntimeClass()
        runtimeClass.addIvar("test", type: ObjectiveType.Float)

		let runtimeObject: NSObject = runtimeClass.allocate()
        runtimeObject.setValue(4.0, forKey: "test")

		XCTAssert(runtimeObject.value(forKey: "test") as? Float == 4.0)
    }

    func testIntrospection() {
        let objectiveView: ObjectiveClass<MKMapView> = ObjectiveClass<MKMapView>()

		let ivars: Array<String> = objectiveView.ivars
        XCTAssert(ivars.contains("_camera"))

		let selectors: Array<Selector> = objectiveView.selectors
        XCTAssert(selectors.contains(NSSelectorFromString("layoutSubviews")))

		let protocols: Array<String> = objectiveView.protocols
        XCTAssert(protocols.contains("MKAnnotationManagerDelegate"))

		let properties: Array<String> = objectiveView.properties
        XCTAssert(properties.contains("mapRegion"))
    }
}
