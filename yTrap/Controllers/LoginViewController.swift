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
    private let kCloseSafariViewControllerNotification = "kCloseSafariViewControllerNotification"
    
    
    
    lazy var loginButton:UIButton = {
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
    
    lazy var logoImageView: UIImageView = {
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
    
    @objc private func updateAfterFirstLogin (notification: NSNotification) {
        self.safariVC?.dismiss(animated: true, completion: nil)
        if let authCode = notification.userInfo?["auth_code"] as? String {
        //self.loginButton(hide: true)
           // self.gatekeeper?.getAuthCode(authCode) { accessToken in
            //            self.user.accessToken = accessToken
            //            self.getUserDataTransition(accessToken: accessToken)
            //        }
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: kCloseSafariViewControllerNotification), object: nil)
        setupView()
        
    
        
       
    }
    
    func setupView() {
    
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

