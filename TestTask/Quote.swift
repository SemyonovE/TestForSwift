//
//  Quote.swift
//  TestTask
//
//  Created by Евгений Семёнов on 03/10/2018.
//  Copyright © 2018 Евгений Семёнов. All rights reserved.
//

import Foundation

class Quote: Decodable {
    var id: Int
    var description: String
    var time: Date
    var rating: Int

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case time
        case rating
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
            .replacingOccurrences(of: "&quot;", with:"\"")
            .replacingOccurrences(of: "<br>", with:"\n")
            .replacingOccurrences(of: "&lt;", with:"<")
            .replacingOccurrences(of: "&gt;", with:">")
        time = try container.decode(Date.self, forKey: .time)
        rating = try container.decode(Int.self, forKey: .rating)
    }
}
