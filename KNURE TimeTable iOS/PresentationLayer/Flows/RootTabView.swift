//
//  RootTabView.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 08.06.2024.
//  Copyright © 2024 Vladislav Chapaev. All rights reserved.
//

import SwiftUI

struct RootTabView: View {


	var body: some View {
		TabView {
			TimetableView()
				.tabItem { Label("Timetable", systemImage: "calendar") }
			ItemsListView(
				interactor: ItemsListInteractor(
					addedItemsSubscription: AddedItemsSubscription(
						repository: KNUREItemRepository(
							coreDataService: CoreDataServiceImpl(
								persistentContainer: DefaultAppConfig().persistentStoreContainer
							),
							networkService: NetworkServiceImpl(
								configuration: DefaultAppConfig().urlSessionConfiguration
							)
						)
					),
					updateTimetableUseCase: UpdateTimetableUseCase(
						lessonRepository: KNURELessonRepository(
							coreDataService: CoreDataServiceImpl(
								persistentContainer: DefaultAppConfig().persistentStoreContainer
							),
							importService: KNURELessonImportService(
								persistentContainer: DefaultAppConfig().persistentStoreContainer
							),
							networkService: NetworkServiceImpl(
								configuration: DefaultAppConfig().urlSessionConfiguration
							)
						),
						itemRepository: KNUREItemRepository(
							coreDataService: CoreDataServiceImpl(
								persistentContainer: DefaultAppConfig().persistentStoreContainer
							),
							networkService: NetworkServiceImpl(
								configuration: DefaultAppConfig().urlSessionConfiguration
							)
						)
					)
				)
			)
			SettingsView()
		}
	}
}
