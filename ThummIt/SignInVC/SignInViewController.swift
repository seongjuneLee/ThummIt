//
//  SignInViewController.swift
//  ThummIt
//
//  Created by 이성준 on 2021/01/31.
//

import Foundation
import SwiftUI
import Parse
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import FBSDKLoginKit
import FBSDKCoreKit
import AuthenticationServices

class SignInViewController: UIViewController {
    @IBOutlet weak var kakaoSignInView: UIView!
    @IBOutlet weak var emailSignInView: UIView!
    @IBOutlet weak var facebookSignInView: UIView!
    @IBOutlet weak var appleSignInView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        self.setUpSignInViewcornerRadius()
        
    }
    
    func setUpSignInViewcornerRadius() {
        self.kakaoSignInView.layer.cornerRadius = 5
        self.facebookSignInView.layer.cornerRadius = 5
        self.emailSignInView.layer.cornerRadius = 5
        self.appleSignInView.layer.cornerRadius = 5
        
        self.kakaoSignInView.layer.borderWidth = 0.5
        self.facebookSignInView.layer.borderWidth = 0.5
        self.emailSignInView.layer.borderWidth = 0.5
        self.appleSignInView.layer.borderWidth = 0.5

        self.kakaoSignInView.layer.borderColor = UIColor.black.cgColor
        self.facebookSignInView.layer.borderColor = UIColor.black.cgColor
        self.emailSignInView.layer.borderColor = UIColor.black.cgColor
        self.appleSignInView.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func privacyPolicyTButtonapped(_ sender: Any) {
        
        let reach = Reachability.forInternetConnection()
        let netStatus = reach?.currentReachabilityStatus()
        if netStatus==NetworkStatus.NotReachable {
            self.view.makeToast(NSLocalizedString("Internet is not connected. please check and try again.", comment: ""), duration: 4.0, position: CSToastPositionCenter)
            return
        }

        let language = NSLocale.preferredLanguages.first
        let request : NSURLRequest
        if language == "en" {
            request = NSURLRequest.init(url: URL.init(string: "http://thummiteng.o-r.kr/")!)
        } else {
            request = NSURLRequest.init(url: URL.init(string: "http://thummitkr.o-r.kr/")!)
        }
        let webVC = UIViewController.init()
        let wkWebView = WKWebView.init(frame: self.view.frame)
        wkWebView.load(request as URLRequest)
        webVC.view.addSubview(wkWebView)
        self.present(webVC, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let reach = Reachability.forInternetConnection()
        let netStatus = reach?.currentReachabilityStatus()
        if netStatus==NetworkStatus.NotReachable {
            self.view.makeToast(NSLocalizedString("Internet is not connected. please check and try again.", comment: ""), duration: 4.0, position: CSToastPositionCenter)
            return
        }

        let main = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let logInVC = main.instantiateViewController(identifier: "LogInViewController")
        self.navigationController?.pushViewController(logInVC, animated: true)
        
    }
    
    @IBAction func kakaoButtonTapped(_ sender: UIButton) {
        
        if AuthApi.isKakaoTalkLoginAvailable() {
            KOSession.shared()?.close()
            
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                
                if let error = error {
                    print("error heree : %@",error)
                } else {
                    //do something
                    _ = oauthToken
                    UserApi.shared.me() {(user, error) in
                        if let error = error {
                            print(error)
                        } else {
                            print("me() success.")
                            
                            //do something
                            _ = user
                            
                            let userID = String(user!.id)
                            let username = user?.properties?["nickname"]
                            let email = user?.kakaoAccount?.email
                            
                            self.view.makeToastActivity(CSToastPositionCenter)
                            UserManager.sharedInstance().signUp(withThirdPartyID: userID, withType: "kakao", username: username!, withEmail: email!) { (success) in
                                DispatchQueue.main.async {
                                    self.view.hideAllToasts()
                                    if (success){
                                        self.dismiss(animated: true, completion: nil)
                                    } else {
                                        self.view.makeToast(NSLocalizedString("Error occured. Visit customer center if this error is repeated.", comment: ""), duration: 5, position: CSToastPositionCenter)
                                        
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        } else {

            AuthApi.shared.loginWithKakaoAccount(completion:  {(oauthToken, error) in

                if let error = error {
                    print("error heree : %@",error)
                } else {
                    //do something
                    _ = oauthToken
                    UserApi.shared.me() {(user, error) in
                        if let error = error {
                            print(error)
                        } else {
                            print("me() success.")

                            //do something
                            _ = user

                            let userID = String(user!.id)
                            let username = user?.properties?["nickname"]
                            let email = user?.kakaoAccount?.email

                            self.view.makeToastActivity(CSToastPositionCenter)
                            UserManager.sharedInstance().signUp(withThirdPartyID: userID, withType: "kakao", username: username!, withEmail: email!) { (success) in
                                DispatchQueue.main.async {
                                    self.view.hideAllToasts()
                                    if (success){
                                        self.dismiss(animated: true, completion: nil)
                                    } else {
                                        self.view.makeToast(NSLocalizedString("Error occured. Visit customer center if this error is repeated.", comment: ""), duration: 5, position: CSToastPositionCenter)

                                    }
                                }
                            }

                        }
                    }
                }
            })
        }
    }
    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        
        // Swift override func viewDidLoad() { super.viewDidLoad() if let token = AccessToken.current, !token.isExpired { // User is logged in, do work such as go to next view controller. } }

        if ((AccessToken.current?.hasGranted(permission: "public_profile")) == true) {
            
            FBSDKCoreKit.Profile.loadCurrentProfile { (profile, error) in
                if profile != nil {
                    
                    let username = profile?.name ?? ""
                    let email = profile?.email ?? ""
                    let userID = profile?.userID ?? ""
                    
                    UserManager.sharedInstance().signUp(withThirdPartyID: userID, withType: "facebook", username: username, withEmail: email) { (success) in

                        if success {
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            self.view.makeToast(NSLocalizedString("Error occured. Visit customer center if this error is repeated.", comment: ""), duration: 5, position: CSToastPositionCenter)
                        }
                    }
                    
                }
            }
            
        } else {
            
            let loginManager = LoginManager.init()
            loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
                if result != nil {
                    FBSDKCoreKit.Profile.loadCurrentProfile { (profile, error) in
                        if profile != nil {
                            
                            let username = profile?.name ?? ""
                            let email = profile?.email ?? ""
                            let userID = profile?.userID ?? ""
                            
                            UserManager.sharedInstance().signUp(withThirdPartyID: userID, withType: "facebook", username: username, withEmail: email) { (success) in
                                if success {
                                    self.dismiss(animated: true, completion: nil)
                                } else {
                                    self.view.makeToast(NSLocalizedString("Error occured. Visit customer center if this error is repeated.", comment: ""), duration: 5, position: CSToastPositionCenter)
                                }
                            }
                        }
                    }
                }
            }
            
        }

        
    }
        
    @IBAction func appleButtonTapped(_ sender: UIButton) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        
        let reach = Reachability.forInternetConnection()
        let netStatus = reach?.currentReachabilityStatus()
        if netStatus==NetworkStatus.NotReachable {
            self.view.makeToast(NSLocalizedString("Internet is not connected. please check and try again.", comment: ""), duration: 4.0, position: CSToastPositionCenter)
            return
        }
        let main = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let signInEmailVC = main.instantiateViewController(identifier: "SignInEmailViewController")
        self.navigationController?.pushViewController(signInEmailVC, animated: true)
        
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension SignInViewController : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    
                // 계정 정보 가져오기
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                let name = (fullName?.givenName ?? "") + (fullName?.familyName ?? "")
            
                UserManager.sharedInstance().signUp(withThirdPartyID: userIdentifier , withType: "apple", username: name, withEmail: email ?? "") { (success) in
                    DispatchQueue.main.async {
                        self.view.hideAllToasts()
                    }

                    if success {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.view.makeToast(NSLocalizedString("Error occured. Visit customer center if this error is repeated.", comment: ""), duration: 5, position: CSToastPositionCenter)
                    }
                }
            default:
                break
            }
        
        }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.view.makeToast(NSLocalizedString("Error occured. Visit customer center if this error is repeated.", comment: ""), duration: 5, position: CSToastPositionCenter)
    }
    
}
