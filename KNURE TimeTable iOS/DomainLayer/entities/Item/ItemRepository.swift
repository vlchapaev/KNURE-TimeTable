//
//  ItemRepository.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import PromiseKit
import RxSwift

protocol ItemRepository {
    func localSelectedItems() -> Observable<[Item]>
    func localSaveItem(item: Item) -> Promise<Void>
    func localDeleteItem(identifier: String) -> Promise<Void>

	func remoteItems(ofType: TimetableItem) -> Promise<NetworkResponse>
}
