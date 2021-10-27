//
//  LoginViewModel.swift
//  CoppelTest
//
//  Created by Javier Morales on 26/10/21.
//

import Foundation

protocol LoginViewModelProtocol {
    func loginComplete(result: LoginStatus)
    func promptAlert(title: String?, message: String?)
    func updateLoadingStatus(status: LoadingStatus)
}

class LoginViewModel {
    
    var delegate: LoginViewModelProtocol?
        
    var loadingStatus = Box(LoadingStatus.complete)
        
    func loginRequest(email: String?, password: String?) {
        guard let email = email, email.count > 0 else {
            delegate?.promptAlert(title: "Please input email", message: nil)
            return
        }
        
        guard let password = password, password.count > 0 else {
            delegate?.promptAlert(title: "Please input password", message: nil)
            return
        }
        
        loadingStatus.value = .loading
        self.delegate?.updateLoadingStatus(status: .loading)
        ApiService.loginApiRequest { (requestToken) in            
            let params = [
                "username": email,
                "password": password,
                "request_token": requestToken?.value() ?? ""
            ] as [String : Any]
            
            ApiService.loginGetToken(params: params) { success in
                guard let success = success else {
                    self.delegate?.updateLoadingStatus(status: .complete)
                    self.delegate?.promptAlert(title: "Unknow error", message: "Please try again later")
                    return
                }
                
                self.delegate?.updateLoadingStatus(status: .complete)
                self.loadingStatus.value = .complete
                self.delegate?.loginComplete(result: success)
            }
        }
    }
    
}
