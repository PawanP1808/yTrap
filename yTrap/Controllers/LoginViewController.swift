//
//  LoginViewController.swift
//  yTrap
//
//  Created by Pawan on 2020-01-09.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController, SFSafariViewControllerDelegate {
    
    private var safariVC: SFSafariViewController?
    
    private lazy var loginButton:UIButton = {
        let button = UIButton() 
        button.backgroundColor = Constants.Design.Color.Spotify.Green
        button.setTitle(Constants.Content.loginBtnTxt, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.titleLabel?.font = Constants.Design.Font.buttonTxt
        button.addTarget(self, action: #selector(handleLoginAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var logoImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = Constants.Design.Image.logo
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    @objc func handleLoginAction(){
        print("login pressed")
        self.safariVC = SFSafariViewController(url: Constants.API.Spotify.loginUrl!)
        self.safariVC?.delegate = self
        guard let safariViewController = self.safariVC else { return }
        self.present(safariViewController, animated: true, completion: nil)
    }
    
    @objc private func login (notification: NSNotification) {
        self.safariVC?.dismiss(animated: true, completion: nil)
        if let userInfo = notification.userInfo as? [String:String],
            let authCode = userInfo["auth_code"] {
            AuthAPI().getAuthCode(authToken: authCode) { accessToken,refreshToken,expireTime in
                AuthDataStore().storeAccessInfo(accessToken: accessToken, refreshToken: refreshToken, expireHour: expireTime)
                self.getUserInfo(token: accessToken)
            }
        }
    }
    
    private func getUserInfo(token:String){
        SpotifyAPI().getUserData(authToken: token){ success,userData in
            guard  success else { return }
            let user = User(withData: userData!)
            AuthDataStore().storeUserData(forUser: user)
            self.transitionToRooms()
            //TODO: ADD USER TO FIREBASE FOR STATS
        }
    }
    
    private func transitionToRooms(){
        let roomViewController = RoomViewController()
        let navigationController = UINavigationController(rootViewController: roomViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor: Constants.Design.Color.Primary.white]
        navigationController.navigationBar.barStyle = .default
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.login), name: NSNotification.Name(rawValue: Constants.Content.kCloseSafariViewControllerNotification), object: nil)
        setupView()
        let userData = AuthDataStore().getUserData()
        if userData != nil {
            self.transitionToRooms()
        }
    }
    
    private func setupView() {
        view.backgroundColor = Constants.Design.Color.Primary.black
        view.addSubview(loginButton)
        view.addSubview(logoImageView)
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 100).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        logoImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: loginButton.topAnchor,constant: -100).isActive = true
    }
    
    //MARK-- SAFARI VC DELEGATES
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

