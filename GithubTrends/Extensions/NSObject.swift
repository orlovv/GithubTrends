//
//  NSObject.swift
//  GithubTrends
//
//  Created by Vladimir Orlov on 09.11.2020.
//

import Foundation

extension NSObject {
    public class var nameOfClass: String {
        NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
