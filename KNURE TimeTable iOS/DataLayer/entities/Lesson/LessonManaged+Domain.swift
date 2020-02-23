//
//  LessonManaged+Domain.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 08/08/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

extension LessonManaged: Convertable {
	typealias NewType = Lesson

	var newValue: Lesson {
		// TODO: implement
		return Lesson()
	}
}
