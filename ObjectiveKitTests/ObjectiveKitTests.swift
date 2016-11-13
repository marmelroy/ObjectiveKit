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


    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    dynamic func testSelector() {
        print("test selector")
    }

    dynamic func swizzledSelector(){
        print("swizzled selector")
    }

    func testAddClosure() {
        let objectiveView = ObjectiveClass<UIView>()
        objectiveView.addMethodToClass(closureName, implementation: {
            print("hello world")
        })
        let view = UIView()
        view.performMethod(closureName)
    }

    func testAddSelector() {
        let objectiveView = ObjectiveClass<UIView>()
        objectiveView.addSelectorToClass(#selector(testSelector), from: self)
        let view = UIView()
        view.perform(#selector(testSelector))
    }

    func testIntrospection() {
        let objectiveView = ObjectiveClass<MKMapView>()
        let selectors = objectiveView.allSelectors()
        print("==SELECTORS== \(selectors)")
        let protocols = objectiveView.allProtocols()
        print("==PROTOCOLS== \(protocols)")
        let properties = objectiveView.allProperties()
        print("==PROPERTIES== \(properties)")
    }

    func testExchange() {
        let objectiveView = ObjectiveClass<Subview>()
        objectiveView.exchangeSelector(#selector(Subview.testSelector), with: #selector(Subview.swizzledSelector))
        let subview = Subview()
        subview.perform(#selector(Subview.testSelector))
        
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
