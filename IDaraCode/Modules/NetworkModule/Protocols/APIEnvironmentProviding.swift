//
//  APIEnvironmentProviding.swift
//  iOSNativeProject
//
//  Created by Christian Martinez on 17/06/25.
//

import Foundation

public protocol APIEnvironmentProviding {
    var baseURL: String { get }
    var environmentName: String { get }
}
