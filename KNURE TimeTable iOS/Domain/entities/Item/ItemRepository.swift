//
//  ItemRepository.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

protocol ItemRepository {
    func localSelectedItems() -> [Item]
    func localSaveItem(item: Item)
    func localRemoveItem(identifier: String)

    func remoteItems()
}
