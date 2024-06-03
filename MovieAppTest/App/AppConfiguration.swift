//
//  AppConfiguration.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 01/06/24.
//

import Foundation

final class AppConfiguration {
    private enum ConfigurationKey: String {
           case apiToken = "ApiToken"
           case apiBaseURL = "ApiBaseURL"
           case imgBaseURL = "ImgBaseURL"
           case videoBaseURL = "VideoBaseURL"
           case imgVideoURL = "ImgVideoURL"
       }
    
    private func getValue(for key: ConfigurationKey) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String else {
            fatalError("\(key.rawValue) must not be empty in plist")
        }
        return value
    }
    
    lazy var apiToken: String = {
        return self.getValue(for: .apiToken)
    }()
    
    lazy var apiBaseURL: String = {
        return self.getValue(for: .apiBaseURL)
    }()
    lazy var imgBaseURL: String = {
        return self.getValue(for: .imgBaseURL)
    }()
    
    lazy var videoBaseURL: String = {
        return self.getValue(for: .videoBaseURL)
    }()
    
    lazy var imgVideoURL: String = {
        return self.getValue(for: .imgVideoURL)
    }()
}
