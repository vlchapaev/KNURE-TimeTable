//
//  ItemsViewController.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import UIKit

protocol ItemsViewControllerOutput {

	func controller(_ controller: ItemsViewController, addItems type: TimetableItem)
}

final class ItemsViewController: UIViewController, ItemsInteractorOutput {

	var interactor: ItemsInteractorInput?
	var output: ItemsViewControllerOutput?

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let addButton = UIBarButtonItem(barButtonSystemItem: .add,
										target: self,
										action: #selector(addItems))
		navigationItem.rightBarButtonItem = addButton

		// Do any additional setup after loading the view.
	}

	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/

	@objc
	func addItems() {
		output?.controller(self, addItems: .group)
	}
}
