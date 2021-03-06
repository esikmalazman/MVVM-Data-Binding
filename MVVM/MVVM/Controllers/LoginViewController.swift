import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var topVaultView: UIView!
    @IBOutlet weak var bottomVaultView: UIView!
    @IBOutlet weak var lockView: UIImageView!
    
    private var transitionCordinator = LockAnimator()
    
    var viewModel = UserViewModel()
    var loginSuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = transitionCordinator
        
        /// Bind view model for  accessCode property with UI
        viewModel.accessCode.bind { [weak self] newAccessCode in
            /// Place to binding the object
            /// Every time  AccessCode have new value, label will update automatically
            self?.codeLabel.text = newAccessCode
        }
        
        viewModel.username.bind { newUsername in
            print("Username has changed to : \(newUsername)")
        }
    }
}

// MARK: Actions
extension LoginViewController {
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func authenticate() {
        dismissKeyboard()
        switch viewModel.validate() {
        case .Valid:
            viewModel.login() { errorMessage in
                if let errorMessage = errorMessage {
                    self.displayErrorMessage(errorMessage: errorMessage)
                } else {
                    self.loginSuccess?()
                }
            }
        case .Invalid(let error):
            displayErrorMessage(errorMessage: error)
        }
    }
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == usernameField {
            // TODO: Reset username text from ViewModel
            textField.text = viewModel.username.value
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == usernameField {
            textField.text = viewModel.protectedUsername
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            passwordField.becomeFirstResponder()
        } else {
            authenticate()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField == usernameField {
            viewModel.updateUsername(newString)
        } else if textField == passwordField {
            viewModel.updatePassword(newString)
        }
        return true
    }
}

// MARK: Private Methods
private extension LoginViewController {
    func displayErrorMessage(errorMessage: String) {
        let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

