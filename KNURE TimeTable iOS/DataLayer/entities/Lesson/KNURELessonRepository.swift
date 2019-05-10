//
//  KNURELessonRepository.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import PromiseKit

class KNURELessonRepository: LessonRepository {

	let coreDataSource: CoreDataSource
	let remoteSource: RemoteSource
	let timetableParser: TimetableParser

    init(coreDataSource: CoreDataSource,
		 remoteSource: RemoteSource,
		 timetableParser: TimetableParser) {
		self.coreDataSource = coreDataSource
		self.remoteSource = remoteSource
		self.timetableParser = timetableParser
    }

    func remoteLoadTimetable(itemId: String) -> Promise<Void> {
		let address = "http://cist.nure.ua/ias/app/tt/"
		guard let url = URL(string: address) else {
			return Promise(error: InvalidUrlError())
		}

		return Promise(resolver: { seal in
			let request = NetworkRequest(url: url)
			remoteSource.execute(request)
				.done { [weak self] response in
					guard let self = self else {
						seal.reject(ApplicationLayerError.nilSelfError)
						return
					}

					try self.timetableParser.parseItemList(data: response.data!) {
						seal.fulfill(())
					}
				}.catch {
					seal.reject($0)
			}
		})
    }
}
