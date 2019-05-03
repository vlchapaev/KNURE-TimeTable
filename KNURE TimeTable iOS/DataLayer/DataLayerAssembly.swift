//
//  DataLayerAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation
import Swinject

class DataLayerAssembly: Assembly {
	func configure(_ container: Container) {
		container.register(ItemRepository.self) { resolver in
			KNUREItemRepository(coreDataSource: resolver.resolve(CoreDataSource.self)!,
								remoteSource: resolver.resolve(RemoteSource.self)!)
		}

		container.register(LessonRepository.self) { resolver in
			KNURELessonRepository(coreDataSource: resolver.resolve(CoreDataSource.self)!,
								  remoteSource: resolver.resolve(RemoteSource.self)!)
		}
	}
}
