//
//  UserViewModel.swift
//  MVVM
//
//  Created by Ikmal Azman on 09/05/2022.
//  Copyright © 2022 Eric Cerney. All rights reserved.
//

import Foundation

enum UserValidationState {
    case Valid
    case Invalid(String)
}

/// View Model Handle
/// 1. Presentation Logic
/// 2. App Logic
class UserViewModel {
    
    private let minUsernameLength = 4
    private let minPasswordLength = 5
    private let codeRefreshTimer = 5.0
    
    /// When the User data model is struct, when new value for username/password set it will create new copy of user
    private var user = User() {
        didSet {
            /// Assign new value when struct create new  copy with updated value
            username.value = user.username
        }
    }
    
    //    var username : String {
    //        return user.username
    //    }
    
    ///  Example using binding box (data binding)
    ///  Allow to listen to store property, and allow view immediately update if new value being set
    var username : BindingBox<String> = BindingBox("")
    
    /// Example using computed property,
    /// Allow  only access it value, view need to ask every time its value when it change
    var password : String {
        return user.password
    }
    
    var protectedUsername : String {
        let characters = username.value
        
        if characters.count >= minUsernameLength {
            var displayName = [Character]()
            for (index, character) in characters.enumerated() {
                if index > characters.count - minUsernameLength {
                    displayName.append(character)
                } else {
                    displayName.append("*")
                }
            }
            return String(displayName)
        }
        return username.value
    }
    
    //    var accessCode : String? {
    //        didSet {
    //            print("Access Code : \(accessCode)")
    //        }
    //    }
    
    /// Convert access code to be binding box with type optional string and give nil for its initial value (empty box)
    var accessCode : BindingBox<String?> = BindingBox(nil)
    
    /// Create init to start generate access code when get initialise
    init(user : User = User()) {
        self.user = user
        startGenerateAccessCodeTimer()
    }
}

extension UserViewModel {
    func updateUsername(_ username : String) {
        user.username = username
    }
    
    func updatePassword(_ password  : String) {
        user.password = password
    }
    
    func validate() -> UserValidationState {
        if user.username.isEmpty || user.password.isEmpty {
            return .Invalid("Username and password are required.")
        }
        
        if user.username.count < minUsernameLength {
            return .Invalid("Username needs to be at least \(minUsernameLength) characters long.")
        }
        
        if user.password.count < minPasswordLength {
            return .Invalid("Password needs to be at least \(minPasswordLength) characters long.")
        }
        
        return .Valid
    }
    
    func login(completion: (_ errorString: String?) -> Void) {
        LoginService.loginWithUsername(username: user.username, password: user.password) { success in
            if success {
                completion(nil)
            } else {
                completion("Invalid credentials.")
            }
        }
    }
}


extension UserViewModel {
    //    func startGenerateAccessCodeTimer() {
    //        /// Generate access code from call the service
    //        accessCode = LoginService.generateAccessCode()
    //
    //        /// Active current method again after 5 seconds
    //        dispatchAfter(seconds: codeRefreshTimer) { [weak self] in
    //            self?.startGenerateAccessCodeTimer()
    //        }
    //    }
    
    func startGenerateAccessCodeTimer() {
        /// Generate access code from call the service
        /// Setting binding box value with login service
        accessCode.value = LoginService.generateAccessCode()
        
        /// Active current method again after 5 seconds
        dispatchAfter(seconds: codeRefreshTimer) { [weak self] in
            self?.startGenerateAccessCodeTimer()
        }
    }
}
