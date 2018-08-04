//
//  LoginViewController.swift
//  Festival-App
//
//  Created by Duminica Octavian on 26/02/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit

private struct Constants {
    static let alertTitle = "Login Failed"
    static let alertMessage = "Invalid data!"
    static let okActionTitle = "OK"
}

class LoginViewController: UIViewController {
    
    lazy var presenter: LoginPresenter = {
        return LoginPresenter(view: self)
    }()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationBar()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func onLoginPressed(_ sender: Any) {
        startActivityIndicator()
        presenter.emailChanged(emailTextField.text)
        presenter.passwordChanged(passwordTextField.text)
        presenter.login()
    }
    
    @IBAction func onRegisterPressed(_ sender: Any) {
        navigateToRegisterScreen()
    }
}

extension LoginViewController: LoginView {
    func resetPasswordTextField() {
        passwordTextField.text = ""
    }
    
    func hideNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func displayLoginFailedAlert() {
        let alert = UIAlertController(title: Constants.alertTitle, message: Constants.alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.okActionTitle, style: .default, handler: { [weak self] (action) in
            guard let weakSelf = self else { return }
            weakSelf.visualEffectView.removeFromSuperview()
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func navigateToHomeScreen() {
        performSegue(withIdentifier: Segue.toHomeFromLogin, sender: self)
    }
    
    func navigateToRegisterScreen() {
        performSegue(withIdentifier: Segue.toRegister, sender: self)
    }
    
    func startActivityIndicator() {
        view.addSubview(visualEffectView)
        LoadingView.startLoading()
    }
    
    func stopActivityIndicator() {
        LoadingView.stopLoading()
    }
}
