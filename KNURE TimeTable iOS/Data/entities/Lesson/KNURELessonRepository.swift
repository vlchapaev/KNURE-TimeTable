//
//  KNURELessonRepository.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

class KNURELessonRepository: LessonRepository {

	let coreDataSource: CoreDataSource
	let remoteSource: RemoteSource

    init(coreDataSource: CoreDataSource,
		 remoteSource: RemoteSource) {
		self.coreDataSource = coreDataSource
		self.remoteSource = remoteSource
    }

    func remoteLoadTimetable(itemId: String) throws {
		let address = "http://cist.nure.ua/ias/app/tt/"
		guard let url = URL(string: address) else { throw InvalidUrlError() }
		let request = NetworkRequest(url: url)
		remoteSource.execute(request)
    }
}
