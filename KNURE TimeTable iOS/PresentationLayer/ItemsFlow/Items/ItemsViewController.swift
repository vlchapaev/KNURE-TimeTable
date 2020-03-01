//
//  ItemsViewController.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol ItemsViewControllerOutput {

	func controller(_ controller: ItemsViewController, addItems type: TimetableItem)
}

final class ItemsViewController: UIViewController {

	var interactor: ItemsInteractorInput?
	var output: ItemsViewControllerOutput?

	private var viewModel: ItemsViewModel
	private let mainView: ItemsView
	private let bag = DisposeBag()

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

		let addButton = UIBarButtonItem(barButtonSystemItem: .add,
										target: self,
										action: #selector(addItems))
		navigationItem.rightBarButtonItem = addButton

		interactor?.obtainItems().map { $0 }.bind(to: viewModel.sections).disposed(by: bag)
		let datasource = RxTableViewSectionedReloadDataSource<ItemsViewModel.Section>(
			configureCell: { _, tableView, indexPath, item in
				let cell = tableView.dequeueReusableCell(withIdentifier: ItemsViewModel.cellId, for: indexPath)
				cell.textLabel?.text = item.fullName ?? item.shortName
				cell.detailTextLabel?.text = "some"
				return cell
		})

		datasource.titleForHeaderInSection = { datasource, index in
			return datasource.sectionModels[index].name
		}

		viewModel.sections.bind(to: mainView.tableView.rx.items(dataSource: datasource)).disposed(by: bag)
	}

	@objc
	func addItems() {
		output?.controller(self, addItems: .group)
	}
}
