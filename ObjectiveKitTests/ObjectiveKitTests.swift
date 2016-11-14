//
//  ObjectiveKitTests.swift
//  ObjectiveKitTests
//
//  Created by Roy Marmelstein on 11/11/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import XCTest
import MapKit
@testable import ObjectiveKit

@objc class Subview: UIView {

    dynamic func testSelector() {
        print("test selector")
    }

    dynamic func swizzledSelector(){
        print("swizzled selector")
    }

}

@objc class ObjectiveKitTests: XCTestCase {

    let closureName = "random"

    dynamic func testSelector() {
        print("test selector")
    }

    func testAddClosure() {
        let methodExpectation = expectation(description: "Method was called")
        let objectiveView = ObjectiveClass<UIView>()
        objectiveView.addMethodToClass(closureName, implementation: {
            methodExpectation.fulfill()
        })
        let view = UIView()
        view.performMethod(closureName)
        waitForExpectations(timeout: 0.1, handler:nil)
    }

    func testAddSelector() {
        let view = UIView()
        XCTAssertFalse(view.responds(to: #selector(testSelector)))
        let objectiveView = ObjectiveClass<UIView>()
        objectiveView.addSelectorToClass(#selector(testSelector), fromClass: self.classForCoder)
        XCTAssert(view.responds(to: #selector(testSelector)))
    }

    func testRuntimeClass() {
        let runtimeClass = RuntimeClass()
        runtimeClass.addIvar("test", type: .Float)
        let runtimeObject = runtimeClass.allocate()
        runtimeObject.setValue(4.0, forKey: "test")
        XCTAssert(runtimeObject.value(forKey: "test") as? Float == 4.0)
    }

    func testIntrospection() {
        let objectiveView = ObjectiveClass<MKMapView>()
        let ivars = objectiveView.allIvars()
        XCTAssert(ivars.contains("_camera"))
        let selectors = objectiveView.allSelectors()
        XCTAssert(selectors.contains(NSSelectorFromString("layoutSubviews")))
        let protocols = objectiveView.allProtocols()
        XCTAssert(protocols.contains("MKAnnotationManagerDelegate"))
        let properties = objectiveView.allProperties()
        XCTAssert(properties.contains("mapRegion"))
    }


}
