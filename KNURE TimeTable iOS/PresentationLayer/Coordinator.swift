//
//  Coordinator.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

/// <#Description#>
protocol Coordinator {

	/// <#Description#>
	var classType: AnyClass { get }

	/// <#Description#>
	func start()
}

extension Coordinator {
	var classType: AnyClass {
		// swiftlint:disable:next force_cast
		return type(of: self) as! AnyClass
	}
}
