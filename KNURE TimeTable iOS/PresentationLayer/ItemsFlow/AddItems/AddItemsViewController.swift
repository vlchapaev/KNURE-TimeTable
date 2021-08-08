//
//  AddItemsViewController.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import UIKit
import Combine

protocol AddItemsViewControllerInput {
	func configure(type: Item.Kind)
}

protocol AddItemsViewControllerOutput {
	func didFinish(_ controller: AddItemsViewController)
}

final class AddItemsViewController: UIViewController {

	var interactor: AddItemsInteractorInput?
	var output: AddItemsViewControllerOutput?

	private var viewModel: AddItemsViewModel
	private let mainView: AddItemsView

	private var subscriptions: [AnyCancellable] = []

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

		mainView.tableView.dataSource = self

		let searchPublisher = mainView.searchController.searchBar.publisher(for: \.text).didChange()

		interactor?.obtainItems(type: viewModel.selectedType)
			.catch { error -> Just<[AddItemsViewModel.Model]> in
				print(error)
				// TODO: Alert with error
				// TODO: activity indicator
				return Just([])
			}
			.receive(on: DispatchQueue.main)
			.sink {
				self.viewModel.models = $0
				self.mainView.tableView.reloadSections(.init(integer: 0), with: .automatic)
			}
			.store(in: &subscriptions)

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

extension AddItemsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.models.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemsViewModel.cellId, for: indexPath)
		let model = viewModel.models[indexPath.row]

		cell.textLabel?.text = model.text
		cell.accessoryType = model.selected ? .checkmark : .none
		cell.selectionStyle = model.selected ? .none : .default

		return cell
	}
}

extension AddItemsViewController: AddItemsViewControllerInput {
	func configure(type: Item.Kind) {
		viewModel.selectedType = type
	}
}
