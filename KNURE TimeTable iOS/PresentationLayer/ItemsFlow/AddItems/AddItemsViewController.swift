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

		mainView.tableView.delegate = self
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		view = mainView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		interactor?.obtainItems().map({ $0 }).bind(to: viewModel.items).disposed(by: bag)
		viewModel.items.bind(to: mainView.tableView.rx.items(cellIdentifier: "TimetableAddItem")) {
			$2.textLabel?.text = $1.fullName
		}
		.disposed(by: bag)
	}
}

extension AddItemsViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		output?.addItemsViewControllerDidFinish(self)
	}
}
