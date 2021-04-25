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

		interactor?.obtain(items: viewModel.selectedType)
			.catch { error -> Just<[AddItemsViewModel.Section]> in
				print(error)
				// TODO: Alert with error
				// TODO: activity indicator
				return Just([])
			}
			.receive(on: DispatchQueue.main)
			.sink {
				self.viewModel.sections = $0.sorted(by: <)
				self.mainView.tableView.reloadData()
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

	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.sections.count
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return viewModel.sections[section].title
	}

	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return viewModel.sections
			.compactMap { $0.title }
			.map { String($0.prefix(1)) }
			.reduce(into: [String]()) {
				if !$0.contains($1) {
					$0.append($1)
				}
			}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.sections[section].models.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemsViewModel.cellId, for: indexPath)
		let model = viewModel.sections[indexPath.section].models[indexPath.row]

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
