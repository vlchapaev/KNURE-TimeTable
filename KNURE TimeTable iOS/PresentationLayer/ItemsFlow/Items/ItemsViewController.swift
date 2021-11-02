//
//  ItemsViewController.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import UIKit
import Combine

protocol ItemsViewControllerOutput {

	func controller(_ controller: ItemsViewController, addItems type: Item.Kind)
}

final class ItemsViewController: UIViewController {

	var interactor: ItemsInteractorInput?
	var output: ItemsViewControllerOutput?

	private var subscriptions: [AnyCancellable] = []

	private var viewModel: ItemsViewModel
	private let mainView: ItemsView

	init() {
		viewModel = ItemsViewModel()
		mainView = ItemsView()
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

		title = "Items"
		navigationController?.navigationBar.prefersLargeTitles = true

		mainView.tableView.dataSource = self
		mainView.tableView.delegate = self

		let addButton = UIBarButtonItem(barButtonSystemItem: .add,
										target: self,
										action: #selector(addItems))
		navigationItem.rightBarButtonItem = addButton

		interactor?.observeSelectedItems()
			.catch { error -> Just<[ItemsViewModel.Section]> in
				print(error)
				// TODO: Alert with error
				// TODO: activity indicator
				return Just([])
			}
			.receive(on: DispatchQueue.main)
			.sink {
				self.viewModel.sections = $0
				self.mainView.tableView.reloadData()
			}
			.store(in: &subscriptions)
	}

	@objc
	private func addItems() {
		let controller = UIAlertController(title: "Добавить",
										   message: "Выберите тип для добавления",
										   preferredStyle: .actionSheet)

		[Item.Kind.group, Item.Kind.teacher, Item.Kind.auditory].forEach { item in
			let action = UIAlertAction(title: item.presentationValue, style: .default) { [unowned self] _ in
				self.output?.controller(self, addItems: item)
			}

			controller.addAction(action)
		}
		controller.addAction(UIAlertAction.init(title: "Отменить", style: .cancel))

		present(controller, animated: true)
	}
}

extension ItemsViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.sections.count
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return viewModel.sections[section].name
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.sections[section].models.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ItemsViewModel.cellId, for: indexPath)
		let model = viewModel.sections[indexPath.section].models[indexPath.row]

		cell.textLabel?.text = model.text

		return cell
	}
}

extension ItemsViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let identifier = viewModel.sections[indexPath.section].models[indexPath.row].identifier
		interactor?.updateTimetable(item: identifier)
		tableView.deselectRow(at: indexPath, animated: true)
		// TODO: loading animation
	}

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		true
	}

	func tableView(_ tableView: UITableView,
				   commit editingStyle: UITableViewCell.EditingStyle,
				   forRowAt indexPath: IndexPath) {
		let identifier = viewModel.sections[indexPath.section].models[indexPath.row].identifier
		interactor?.remove(item: identifier)
	}

}
