//
//  Moya.swift
//  TestTask
//
//  Created by Евгений Семёнов on 03/10/2018.
//  Copyright © 2018 Евгений Семёнов. All rights reserved.
//

import Moya

enum MyService {
    case quotes
}

extension MyService: TargetType {
    var baseURL: URL { return URL(string: "http://quotes.zennex.ru/api/v3/bash")! }
    var path: String { return "/quotes" }
    var method: Moya.Method { return .get }
    var parameters: [String: String] { return ["sort": "time"] }
    var task: Task {
        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }
    var sampleData: Data { return Data() }
    var headers: [String: String]? { return ["Content-type": "application/json"] }
}
