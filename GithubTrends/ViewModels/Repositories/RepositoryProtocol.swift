//
//  RepositoryProtocol.swift
//  GithubTrends
//
//  Created by Vladimir Orlov on 09.11.2020.
//

import Foundation

public protocol RepositoryProtocol {
    func fetchItems(for timePeriod: TimePeriod,
                    completion: @escaping ([RepositoryModel]) -> Void)
}
