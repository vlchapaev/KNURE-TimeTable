//
//  LessonRepository.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import PromiseKit

protocol LessonRepository {
    func remoteLoadTimetable(itemId: String) -> Promise<Void>
}
