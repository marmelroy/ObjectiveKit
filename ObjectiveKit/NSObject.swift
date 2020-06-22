import Foundation

/**
 - Migrator: ISHIKAWA Koutarou
 - Migrated from Swift 3 to Swift 5: 2020/06/19
 - Migrate Copyright: © 2020 ISHIKAWA Koutarou. All rights reserved.
 - Original Created: 2016/11/14
 - Original Copyright: © 2016 Roy Marmelstein All rights reserved. This software is licensed under the MIT License. Full details can be found in the README.
 */
public extension NSObject {
	
	/// A convenience method to perform selectors by identifier strings.
	/// - Parameter identifier: Selector name.
	func performMethod(_ identifier: String) {
		perform(NSSelectorFromString(identifier))
	}
}
