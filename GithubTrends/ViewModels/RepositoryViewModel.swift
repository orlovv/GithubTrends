//
//  RepositoryViewModel.swift
//  GithubTrends
//
//  Created by Vladimir Orlov on 09.11.2020.
//

import Foundation

class RepositoryViewModel: RepositoryViewModelProtocol {
    var newReposLoaded: Observable<Bool> = Observable(true)
    
    let userDefaults = UserDefaults.standard
    let udKey: String = "lastChosen"
    var items: [RepositoryModel]?
    var repository: RepositoryProtocol!
    var lastChosen: TimePeriod {
        willSet  {
            self.userDefaults.set(newValue.rawValue, forKey: self.udKey)
        }
    }
    
    required init(itemsRepo: RepositoryProtocol) {
        repository = itemsRepo
        let valueFromUD = userDefaults.integer(forKey: udKey)
        lastChosen = TimePeriod(rawValue: valueFromUD) ?? .daily
    }
    
    func getRepo(for index: Int) -> RepositoryModel? {
        return items?[index]
    }
    
    func loadRepos() {
        repository.fetchItems(for: lastChosen) { (newItems) in
            self.items = newItems
            self.newReposLoaded.value = true
        }
    }
    
    
    func getTimePeriods() -> [String] {
        return TimePeriod.allCases.map { $0.fromIntToString(value: $0.rawValue) }
    }
    
    func getLastChosenTimePeriod() -> Int {
        return lastChosen.rawValue
    }
    
    func getRepoCount() -> Int {
        return items?.count ?? 0
    }
    
    func timePeriodDidChange(to value: Int) {
        lastChosen = TimePeriod(rawValue: value) ?? .weekly
        loadRepos()
    }
    
    
}
