//
//  ItemRepository.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Combine

/// Access to timetable items
protocol ItemRepository {

    /// Observe items that is been selected
    ///
    /// - Returns: Observable items list
    func localSelectedItems() -> AnyPublisher<[Item], Never>

    /// Save item in persistent store
    ///
    /// - Parameter items: timetable item
    /// - Returns: Promise with finished operation
	func local(save items: [[String: Any]])

    /// Delete item from persistent store
    ///
    /// - Parameter identifier: item identifier
    /// - Returns: Promise with finished operation
    func local(delete identifier: String)

	/// <#Description#>
	/// - Parameter type: <#type description#>
	func remote(items type: Item.Kind) -> AnyPublisher<[Item], Error>
}
