//
//  AddItemView.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 27.02.2024.
//  Copyright © 2024 Vladislav Chapaev. All rights reserved.
//

import SwiftUI

struct AddItemView: View {

	var model: Model

    var body: some View {
		HStack(alignment: .center) {
			VStack(alignment: .leading) {
				if model.selected {
					Text(model.title)
						.fontWeight(.bold)
				} else {
					Text(model.title)
				}

			}
			Spacer()
			if model.selected {
				Image(systemName: "checkmark")
			}
		}
    }

	struct Model: Identifiable {

		let id: UUID = .init()

		let title: String
		var selected: Bool
	}
}

#Preview {
	AddItemView(model: .init(title: "Some Name", selected: true))
}
