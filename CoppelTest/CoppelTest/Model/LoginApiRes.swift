//
//  LoginStatus.swift
//  CoppelTest
//
//  Created by Javier Morales on 26/10/21.
//

import Foundation

enum LoginStatus  {
    case success(token: String)
    case fail(message: String)
    
    func value() -> String {
        switch self {
        case .success(let token):
            return token
        case .fail(let message):
            return message
        }
    }
}

enum LoadingStatus {
    case loading
    case complete
}

