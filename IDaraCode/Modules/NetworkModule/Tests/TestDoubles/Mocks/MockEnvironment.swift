//
//  MockEnvironment.swift
//  iOSNativeProject
//
//  Created by Christian Martinez on 18/06/25.
//

import Foundation
@testable import iOSNativeProject

struct MockEnvironment: APIEnvironmentProviding {
    let baseURL: String
    let environmentName: String = "TEST"
}
