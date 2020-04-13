//
//  ObjectiveKitTests.swift
//  ObjectiveKitTests
//
//  Created by Roy Marmelstein on 11/11/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import XCTest
@testable import ObjectiveKit

@objc protocol CustomProtocol { }

class Subview: UIView, CustomProtocol {
    @objc var customVar = "something"
    @objc let customLet = "something"

    @objc func customSelector() {
        print("test selector")
    }
}

class ObjectiveKitTests: XCTestCase {
    let closureName = "random"

    dynamic func testSelector() {
        print("test selector")
    }

    func testAddClosure() {
        let methodExpectation = expectation(description: "Method was called")
        let objectiveView = ObjectiveClass<UIView>()
        objectiveView.addMethod(closureName, implementation: { _ in
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
        objectiveView.addSelector(#selector(testSelector), from: self.classForCoder)
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
        let objectiveView = ObjectiveClass<Subview>()
        let ivars = objectiveView.ivars
        XCTAssertEqual(ivars, ["customVar", "customLet"])
        let selectors = objectiveView.selectors
        XCTAssertEqual(selectors.last, NSSelectorFromString("customSelector"))
        let protocols = objectiveView.protocols
        XCTAssertEqual(protocols, ["ObjectiveKitTests.CustomProtocol"])
        let properties = objectiveView.properties
        XCTAssertEqual(properties, ["customVar", "customLet"])
    }
}
