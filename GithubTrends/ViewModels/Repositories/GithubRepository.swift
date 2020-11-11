//
//  GithubRepository.swift
//  GithubTrends
//
//  Created by Vladimir Orlov on 09.11.2020.
//

import Foundation

enum URLType: String {
    case repositories = "repositories"
}

final class GithubRepository: RepositoryProtocol {
    
    private let session = URLSession(configuration: .default)
    private let baseURL = AppConfiguration.baseURL
    private let currentLanguage = "swift"
    
    func url(for timePeriod: TimePeriod) -> URL? {
        let timeString = timePeriod.fromIntToString(value: timePeriod.rawValue)
        let urlString = baseURL + URLType.repositories.rawValue + "?language=" + currentLanguage + "&since=" + timeString
        let url = URL(string: urlString)
        return url
    }
    
    func fetchItems(for timePeriod: TimePeriod,
                    completion: @escaping ([RepositoryModel]) -> Void) {
        guard let url = url(for: timePeriod) else {
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if error == nil {
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    return
                }
                guard let data = data else {
                    return
                }
                if let items = try? JSONDecoder().decode([RepositoryModel].self, from: data) {
//                    print(items)
                    DispatchQueue.main.async {
                        completion(items)
                    }
                }
            }
        }
        task.resume()
    }
}
