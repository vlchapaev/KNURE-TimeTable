//
//  KNURELessonRepository.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import RxSwift
import CoreData

class KNURELessonRepository: LessonRepository {

	private let coreDataService: CoreDataService
	private let reactiveCoreDataService: ReactiveCoreDataService
	private let reactiveNetworkingService: ReactiveNetworkService
	private let importService: ImportService

	init(coreDataService: CoreDataService,
		 reactiveCoreDataService: ReactiveCoreDataService,
		 reactiveNetworkingService: ReactiveNetworkService,
		 importService: ImportService) {
		self.coreDataService = coreDataService
		self.reactiveCoreDataService = reactiveCoreDataService
		self.reactiveNetworkingService = reactiveNetworkingService
		self.importService = importService
    }

	func localTimetable(identifier: String) -> Observable<[Lesson]> {
		let request = NSFetchRequest<LessonManaged>(entityName: "LessonManaged")
		request.predicate = NSPredicate(format: "itemIdentifier = %@", identifier)
		return reactiveCoreDataService.observe(request).map {
			$0.map { $0.newValue }
		}
	}

//	func localLesson(identifier: String) -> Promise<Lesson> {
//		let request = NSFetchRequest<LessonManaged>(entityName: "LessonManaged")
//		request.predicate = NSPredicate(format: "subjectIdentifier = %@", identifier)
//		return coreDataService.fetch(request).firstValue.map { $0.domainValue }
//	}
//
//	func localExport(identifier: String, range: Void) -> Promise<Void> {
//		// TODO: implement
//		return Promise()
//	}
//
//    func remoteLoadTimetable(identifier: String) -> Promise<Void> {
//		let address = "http://cist.nure.ua/ias/app/tt/P_API_EVENT_JSON/timetable_id=\(identifier)"
//		guard let url = URL(string: address) else {
//			return Promise(error: DataLayerError.invalidUrlError)
//		}
//
//		return Promise { seal in
//			let request = NetworkRequest(url: url)
//			reactiveNetworkingService.execute(request)
//				.done { [weak self] response in
//
//					try self?.importService.importData(response.data,
//													  transform: { $0["identifier"] = identifier },
//													  completion: { seal.fulfill(()) })
//
//				}.catch {
//					seal.reject($0)
//			}
//		}
//    }
}
