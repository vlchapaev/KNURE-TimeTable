//
//  AddItemsView.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import UIKit

final class AddItemsView: UIView {

	let tableView: UITableView
	let searchController: UISearchController

	init() {
		tableView = UITableView(frame: .zero, style: .plain)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: AddItemsViewModel.cellId)
		searchController = UISearchController(searchResultsController: nil)
		searchController.dimsBackgroundDuringPresentation = false
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.searchBar.searchBarStyle = .minimal

		super.init(frame: .zero)

		addSubview(tableView)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		tableView.frame = bounds
	}
}
