//
//  ViewController.swift
//  Course4Task1
//
//

import UIKit
import Kingfisher
import LocalAuthentication

//Sets view with authorization
class ViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.autocorrectionType = .no
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    let queryService = QueryService()
    let keychainService = KeychainService()
    var user: UserInfo?
    
    
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            let url = URL(string: "https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png")
            logoImageView.kf.setImage(with: url)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            print("No username or password received")
            return
        }
        
        guard username.count > 0, password.count > 0 else {
            print("No username or password received")
            return
        }
        
        let credentials = UserCredentials(account: username, password: password)
        
        authorizationRequest(credentials: credentials)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let passwordWasSavedEarlier = keychainService.readPassword(server: KeychainService.server)
        if passwordWasSavedEarlier != nil {
            authenticateUser()
            print("password found in keychain")
        } else {
            print("no password found")
        }
    }
    
    func authenticateUser() { //(completionHandler: @escaping (Result<Bool,Error>) -> Void) {
        
        if #available(iOS 8.0, *, *) {
            let authenticationContext = LAContext()
            setupAuthenticationContext(context: authenticationContext)
            
            let reason = "Fast and safe authentication in your app"
            var authError: NSError?
            
            if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [unowned self] success, evaluateError in
                    if success {
                        print("authentication success")
                        guard let credentials = self.keychainService.readPassword(server: KeychainService.server) else { return }
                        
                        self.queryService.makeAuthorizationRequest(credentials: credentials, completion: { [weak self] userInfo, errorMessage in
                            
                            if let userInfo = userInfo {
                                DispatchQueue.main.async {
                                    self?.user = userInfo
                                    self?.startToSearchViewSegue()
                                }
                                
                            } else {
                                print("no userinfo")
                            }
                            
                            
                            if !errorMessage.isEmpty {
                                print("Authorization error: " + errorMessage)
                                
                            }
                            
                            }
                        )
                        
                    } else {
                        
                        if let error = evaluateError {
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                
                if let error = authError {
                    print(error.localizedDescription)
                }
            }
        } else {
        }
    }
    
    func setupAuthenticationContext(context: LAContext) {
        context.localizedReason = "Use for fast and safe authentication in your app"
        context.localizedCancelTitle = "Cancel"
        context.localizedFallbackTitle = "Enter password"
        
        context.touchIDAuthenticationAllowableReuseDuration = 600
    }
    
    func startToSearchViewSegue() {
        guard let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "searchVC") as? SearchViewController else { return }
        guard let user = user else { return }
        destinationController.username = user.login
        destinationController.avatarURL = user.avatarUrl
        self.navigationController?.pushViewController(destinationController, animated: true)
    }
    
    private func authorizationRequest(credentials: UserCredentials) {
        queryService.makeAuthorizationRequest(credentials: credentials) { [weak self] userInfo, errorMessage in
            
            if let userInfo = userInfo {
                self?.user = userInfo
                
                guard let result = self?.keychainService.saveCredentials(credentials: credentials) else { return }
                
                if result {
                    print("password successfully saved")
                } else {
                    print("can't save password")
                }
                
                self?.startToSearchViewSegue()
            }
            
            if !errorMessage.isEmpty {
                print("Authorization error: " + errorMessage)
            }
        }
    }


}

