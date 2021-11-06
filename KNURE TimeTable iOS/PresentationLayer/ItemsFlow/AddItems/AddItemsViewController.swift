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

		title = viewModel.selectedType.presentationValue
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.searchController = mainView.searchController

		mainView.tableView.dataSource = self
		mainView.tableView.delegate = self

		subscribeOnSearchBar()
		subscribeOnTableView()
	}
}

extension AddItemsViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.sections.count
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return viewModel.sections[section].title
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

extension AddItemsViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let model = viewModel.sections[indexPath.section].models[indexPath.row]
		interactor?.save(item: model, type: viewModel.selectedType)
		output?.didFinish(self)
		tableView.deselectRow(at: indexPath, animated: true)

		// TODO: remove
		self.navigationController?.popToRootViewController(animated: true)
	}
}

private extension AddItemsViewController {

	func subscribeOnSearchBar() {
		NotificationCenter.default
			.publisher(for: UISearchTextField.textDidChangeNotification,
					   object: self.mainView.searchController.searchBar.searchTextField)
			.compactMap { ($0.object as? UISearchTextField)?.text }
			.debounce(for: .milliseconds(250), scheduler: RunLoop.main)
			.removeDuplicates()
			.sink(receiveValue: filter)
			.store(in: &viewModel.subscriptions)
	}

	func subscribeOnTableView() {
		interactor?.obtain(items: viewModel.selectedType)
			.catch { error -> Just<[AddItemsViewModel.Section]> in
				print(error)
				// TODO: Alert with error
				// TODO: activity indicator
				return Just([])
			}
			.receive(on: RunLoop.main)
			.sink(receiveValue: update)
			.store(in: &viewModel.subscriptions)
	}

	func filter(query: String) {
		guard !query.isEmpty else {
			viewModel.sections = viewModel.sourceSections
			mainView.tableView.reloadData()
			return
		}

		viewModel.sections = viewModel.sourceSections
			.reduce(into: [AddItemsViewModel.Section]()) { resultItem, currentItem in
				let models: [AddItemsViewModel.Model] = currentItem.models.filter { $0.text.contains(query) }
				if !models.isEmpty {
					let section = AddItemsViewModel.Section(title: currentItem.title, models: models)
					resultItem.append(section)
				}
			}
			.sorted(by: <)
		mainView.tableView.reloadData()
	}

	func update(viewModel: [AddItemsViewModel.Section]) {
		self.viewModel.sections = viewModel.sorted(by: <)
		self.viewModel.sourceSections = self.viewModel.sections
		mainView.tableView.reloadData()
	}
}

extension AddItemsViewController: AddItemsViewControllerInput {
	func configure(type: Item.Kind) {
		viewModel.selectedType = type
	}
}
