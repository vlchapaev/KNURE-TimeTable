//
//  NetworkService.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 30/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import RxSwift

protocol ReactiveNetworkService {

	func execute(_ request: NetworkRequest) -> Observable<NetworkResponse>
}
