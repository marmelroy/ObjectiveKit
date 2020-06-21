import Foundation

/**
 - Migrator: ISHIKAWA Koutarou
 - Migrated from Swift 3 to Swift 5: 2020/06/19
 - Migrate Copyright: © 2020 ISHIKAWA Koutarou. All rights reserved.
 - Original Created: 2016/11/14
 - Original Copyright: © 2016 Roy Marmelstein All rights reserved. This software is licensed under the MIT License. Full details can be found in the README.
 */
public protocol ObjectiveKitRuntimeModification {

    var internalClass: AnyClass { get }


	//MARK: - Runtime modification

    /// Add a selector that is implemented on another object to the current class.
    /// - Parameters:
    ///   - selector: Selector.
    ///   - originalClass: Object implementing the selector.
    func addSelector(_ selector: Selector, from originalClass: AnyClass)

    /// Add a custom method to the current class.
    /// - Parameters:
    ///   - identifier: Selector name.
    ///   - implementation: Implementation as a closure.
    func addMethod(_ identifier: String, implementation: @escaping @convention(block) () -> Void)

    /// Exchange selectors implemented in the current class.
    /// - Parameters:
    ///   - aSelector: Selector.
    ///   - otherSelector: Selector.
    func exchangeSelector(_ aSelector: Selector, with otherSelector: Selector)

}
