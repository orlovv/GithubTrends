//
//  Utils.swift
//  GithubTrends
//
//  Created by Vladimir Orlov on 09.11.2020.
//

import Foundation

struct AppConfiguration {
    static var baseURL: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "AppConfig",
                                                  ofType: "plist") else {
                fatalError("Couldn't find file 'AppConfig.plist'.")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "BASE_URL") as? String else {
                fatalError("Couldn't find key in 'AppConfig.plist' file.")
            }
            return value
        }
    }
}
