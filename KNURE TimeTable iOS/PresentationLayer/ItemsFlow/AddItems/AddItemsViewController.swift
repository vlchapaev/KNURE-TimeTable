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

		interactor?.obtainItems(type: viewModel.selectedType)
			.receive(subscriber: mainView.tableView)
//			.bind(to: viewModel.items).disposed(by: bag)
//
//		let searchQuery = mainView.searchController.searchBar.rx.text.orEmpty.distinctUntilChanged()
//		let searchQuery = mainView.searchController.searchBar.publisher(for: \.text).didChange()
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

//		mainView.tableView.sub
	}
}

extension AddItemsViewController: AddItemsViewControllerInput {
	func configure(type: Item.Kind) {
		viewModel.selectedType = type
	}
}


//extension UITableView {
//
//	/// A table view specific `Subscriber` that receives `[[Element]]` input and updates a sectioned table view.
//	/// - Parameter cellIdentifier: The Cell ID to use for dequeueing table cells.
//	/// - Parameter cellType: The required cell type for table rows.
//	/// - Parameter cellConfig: A closure that receives an initialized cell and a collection element
//	///     and configures the cell for displaying in its containing table view.
//	public func sectionsSubscriber<CellType, Items>(cellIdentifier: String, cellType: CellType.Type, cellConfig: @escaping TableViewItemsController<Items>.CellConfig<Items.Element.Element, CellType>)
//		-> AnySubscriber<Items, Never> where CellType: UITableViewCell,
//		Items: RandomAccessCollection,
//		Items.Element: RandomAccessCollection,
//		Items.Element: Equatable {
//
//			return sectionsSubscriber(.init(cellIdentifier: cellIdentifier, cellType: cellType, cellConfig: cellConfig))
//	}
//
//	/// A table view specific `Subscriber` that receives `[[Element]]` input and updates a sectioned table view.
//	/// - Parameter source: A configured `TableViewItemsController<Items>` instance.
//	public func sectionsSubscriber<Items>(_ source: TableViewItemsController<Items>)
//		-> AnySubscriber<Items, Never> where
//		Items: RandomAccessCollection,
//		Items.Element: RandomAccessCollection,
//		Items.Element: Equatable {
//
//			source.tableView = self
//			dataSource = source
//
//			return AnySubscriber<Items, Never>(receiveSubscription: { subscription in
//				subscription.request(.unlimited)
//			}, receiveValue: { [weak self] items -> Subscribers.Demand in
//				guard let self = self else { return .none }
//
//				if self.dataSource == nil {
//					self.dataSource = source
//				}
//
//				source.updateCollection(items)
//				return .unlimited
//			}) { _ in }
//	}
//
//	/// A table view specific `Subscriber` that receives `[Element]` input and updates a single section table view.
//	/// - Parameter cellIdentifier: The Cell ID to use for dequeueing table cells.
//	/// - Parameter cellType: The required cell type for table rows.
//	/// - Parameter cellConfig: A closure that receives an initialized cell and a collection element
//	///     and configures the cell for displaying in its containing table view.
//	public func rowsSubscriber<CellType, Items>(cellIdentifier: String, cellType: CellType.Type, cellConfig: @escaping TableViewItemsController<[Items]>.CellConfig<Items.Element, CellType>)
//		-> AnySubscriber<Items, Never> where CellType: UITableViewCell,
//		Items: RandomAccessCollection,
//		Items: Equatable {
//
//			return rowsSubscriber(.init(cellIdentifier: cellIdentifier, cellType: cellType, cellConfig: cellConfig))
//	}
//
//	/// A table view specific `Subscriber` that receives `[Element]` input and updates a single section table view.
//	/// - Parameter source: A configured `TableViewItemsController<Items>` instance.
//	public func rowsSubscriber<Items>(_ source: TableViewItemsController<[Items]>)
//		-> AnySubscriber<Items, Never> where
//		Items: RandomAccessCollection,
//		Items: Equatable {
//
//			source.tableView = self
//			dataSource = source
//
//			return AnySubscriber<Items, Never>(receiveSubscription: { subscription in
//				subscription.request(.unlimited)
//			}, receiveValue: { [weak self] items -> Subscribers.Demand in
//				guard let self = self else { return .none }
//
//				if self.dataSource == nil {
//					self.dataSource = source
//				}
//
//				source.updateCollection([items])
//				return .unlimited
//			}) { _ in }
//	}
//}
