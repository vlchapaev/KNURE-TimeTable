//
//  AddItemsViewController.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import UIKit

protocol AddItemsViewControllerInput {
	func configure(type: Item.Kind)
}

protocol AddItemsViewControllerOutput {
	func didFinish(_ controller: AddItemsViewController)
}

final class AddItemsViewController: UIViewController, AddItemsInteractorOutput {

	var interactor: AddItemsInteractorInput?
	var output: AddItemsViewControllerOutput?

	private var viewModel: AddItemsViewModel
	private let mainView: AddItemsView

	init() {
		mainView = AddItemsView()
		viewModel = AddItemsViewModel()

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		view = mainView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Groups"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.searchController = mainView.searchController

//		interactor?.obtainItems(type: viewModel.selectedType).map { $0 }
//			.bind(to: viewModel.items).disposed(by: bag)
//
//		let searchQuery = mainView.searchController.searchBar.rx.text.orEmpty.distinctUntilChanged()
//
//		Observable.combineLatest(viewModel.items.asObservable(), searchQuery)
//			.map { (items, query) -> [AddItemsViewModel.Model] in
//				return items.filter { $0.text.hasPrefix(query) || $0.text.contains(query) }
//			}
//			.bind(to: mainView.tableView.rx.items(cellIdentifier: AddItemsViewModel.cellId)) {
//				$2.textLabel?.text = $1.text
//				$2.accessoryType = $1.selected ? .checkmark : .none
//				$2.selectionStyle = $1.selected ? .none : .default
//			}
//			.disposed(by: bag)
	}
}

extension AddItemsViewController: AddItemsViewControllerInput {
	func configure(type: Item.Kind) {
		viewModel.selectedType = type
	}
}
