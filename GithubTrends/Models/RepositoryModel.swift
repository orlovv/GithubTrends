//
//  RepositoryModel.swift
//  GithubTrends
//
//  Created by Vladimir Orlov on 09.11.2020.
//

import Foundation

public struct RepositoryModel {
    let username: String?
    let avatar: String?
    let repoName: String?
    let repoDesc: String?
    let url: String?
    
//    init(username: String, repoName: String, desc: String) {
//        self.username = username
//        self.repoName = repoName
//        self.repoDesc = desc
//    }
}

extension RepositoryModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case username = "author"
        case avatar
        case repoName = "name"
        case repoDesc = "description"
        case url
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.username = try? container.decode(String.self, forKey: .username)
        self.avatar = try? container.decode(String.self, forKey: .avatar)
        self.repoName = try? container.decode(String.self, forKey: .repoName)
        self.repoDesc = try? container.decode(String.self, forKey: .repoDesc)
        self.url = try? container.decode(String.self, forKey: .url)
    }
}
