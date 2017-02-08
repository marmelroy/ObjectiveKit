//
//  Optional+Extensions.swift
//  ObjectiveKit
//
//  Created by Oleksa 'trimm' Korin on 2/8/17.
//  Copyright © 2017 Roy Marmelstein. All rights reserved.
//

/// Wraps value in optional
public func pure<T>(_ value: T) -> T? {
    return value
}

/// Returns the value passed as the parameter
public func identity<T>(_ value: T) -> T {
    return value
}
