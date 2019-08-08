//
//  KNURELessonRepository.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import PromiseKit

class KNURELessonRepository: LessonRepository {

	private let promisedCoreDataService: PromisedCoreDataService
	private let reactiveCoreDataService: ReactiveCoreDataService
	private let promisedNetworkingService: PromisedNetworkService
	private let importService: ImportService

	init(promisedCoreDataService: PromisedCoreDataService,
		 reactiveCoreDataService: ReactiveCoreDataService,
		 promisedNetworkingService: PromisedNetworkService,
		 importService: ImportService) {
		self.promisedCoreDataService = promisedCoreDataService
		self.reactiveCoreDataService = reactiveCoreDataService
		self.promisedNetworkingService = promisedNetworkingService
		self.importService = importService
    }

    func remoteLoadTimetable(identifier: String) -> Promise<Void> {
		let address = "http://cist.nure.ua/ias/app/tt/"
		guard let url = URL(string: address) else {
			return Promise(error: Networking.invalidUrlError)
		}

		return Promise { seal in
			let request = NetworkRequest(url: url)
			promisedNetworkingService.execute(request)
				.done { [weak self] response in
					guard let self = self else {
						seal.reject(ApplicationLayer.nilSelfError)
						return
					}

					try self.importService.importData(response.data,
													  transform: { $0["identifier"] = identifier },
													  completion: { seal.fulfill(()) })

				}.catch {
					seal.reject($0)
			}
		}
    }
}
