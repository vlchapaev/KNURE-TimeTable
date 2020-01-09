//
//  AddItemsViewController.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddItemsViewControllerInput {
	func configure(type: TimetableItem)
}

protocol AddItemsViewControllerOutput {
	func addItemsViewControllerDidFinish(_ controller: AddItemsViewController)
}

final class AddItemsViewController: UIViewController, AddItemsInteractorOutput {

	var interactor: AddItemsInteractorInput?
	var output: AddItemsViewControllerOutput?

	private var viewModel: AddItemsViewModel
	private let mainView: AddItemsView
	private let bag = DisposeBag()

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

		interactor?.obtainItems(type: viewModel.selectedType).map({ $0 }).bind(to: viewModel.items).disposed(by: bag)
		viewModel.items.bind(to: mainView.tableView.rx.items(cellIdentifier: AddItemsViewModel.cellId)) {
			$2.textLabel?.text = $1.shortName
		}
		.disposed(by: bag)
	}
}

extension AddItemsViewController: AddItemsViewControllerInput {
	func configure(type: TimetableItem) {
		viewModel.selectedType = type
	}
}
