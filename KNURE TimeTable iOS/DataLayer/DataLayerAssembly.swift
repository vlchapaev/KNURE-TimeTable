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
		container.register(ItemRepository.self) {
			KNUREItemRepository(promisedCoreDataService: $0.resolve(PromisedCoreDataService.self)!,
								reactiveCoreDataService: $0.resolve(ReactiveCoreDataService.self)!,
								promisedNetworkingService: $0.resolve(PromisedNetworkService.self)!,
								timetableParser: $0.resolve(TimetableParser.self)!)
		}

		container.register(LessonRepository.self) {
			KNURELessonRepository(promisedCoreDataService: $0.resolve(PromisedCoreDataService.self)!,
								  reactiveCoreDataService: $0.resolve(ReactiveCoreDataService.self)!,
								  promisedNetworkingService: $0.resolve(PromisedNetworkService.self)!,
								  timetableParser: $0.resolve(TimetableParser.self)!)
		}
	}
}
