//
//  ItemsView.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import UIKit

final class ItemsView: UIView {

	let tableView: UITableView

	init() {

		tableView = UITableView(frame: .zero, style: .insetGrouped)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: ItemsViewModel.cellId)
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 44

		super.init(frame: .zero)

		addSubview(tableView)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		tableView.frame = bounds
	}
}
