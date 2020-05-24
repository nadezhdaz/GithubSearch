//
//  RepositoryShortInfo.swift
//  Course4Task1
//

//

import UIKit

struct RepositoryShortInfo: Codable {
    struct Item: Codable {
        struct Owner: Codable {
            var login: String
            var avatarUrl: URL
        }
        var name: String
        var description: String?
        var htmlUrl: URL
        var owner: Owner
    }
    var totalCount: Int
    var items: [Item]
}
