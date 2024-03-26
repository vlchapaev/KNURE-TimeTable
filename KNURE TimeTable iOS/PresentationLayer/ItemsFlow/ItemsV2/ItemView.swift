//
//  ItemView.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 26.02.2024.
//  Copyright © 2024 Vladislav Chapaev. All rights reserved.
//

import SwiftUI

struct ItemView: View {

	var model: Model

    var body: some View {
		HStack(alignment: .center) {
			VStack(alignment: .leading) {
				Text(model.title)
					.fontWeight(.medium)
				Text(model.subtitle)
					.foregroundStyle(.gray)
			}
			Spacer()
			if model.updating {
				ProgressView()
			}
		}
    }

	struct Model: Identifiable {

		var id: String { title + subtitle }

		let title: String
		let subtitle: String
		var updating: Bool = false
	}
}

#Preview {
	ItemView(model: .init(title: "some title", subtitle: "some subtitle"))
}
