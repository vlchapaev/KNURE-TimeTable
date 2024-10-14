//
//  ItemCell.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 26.02.2024.
//  Copyright © 2024 Vladislav Chapaev. All rights reserved.
//

import SwiftUI

struct ItemCell: View {

	var model: Model

    var body: some View {
		HStack(alignment: .center) {
			VStack(alignment: .leading) {
				Text(model.title)
					.fontWeight(.medium)
					.padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
				Text(model.subtitle)
					.foregroundStyle(.gray)
					.padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
			}
			Spacer()
			if model.updating {
				ProgressView()
					.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
			}
		}
    }

	struct Model: Identifiable {

		var id: String { title + subtitle }

		let title: String
		let subtitle: String
		var updating: Bool = true
	}
}

#Preview {
	ItemCell(model: .init(title: "some title", subtitle: "some subtitle"))
}
