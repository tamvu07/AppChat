//
//  AppDelegate.swift
//  AppChat
//
//  Created by Vu Minh Tam on 7/19/21.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions)
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        return true
    }

    
    // MARK: config facebook

    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
      
      ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
      
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
      guard let url = URLContexts.first?.url else { return }
      ApplicationDelegate.shared.application( UIApplication.shared, open: url, sourceApplication: nil, annotation: [UIApplication.OpenURLOptionsKey.annotation] )
      }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if let error = error {
                print("Failed to sign in with Google: \(error)")
            }
            return
        }
        
        guard let user = user else {
            return
        }
        
        print("Did sign in with Google: \(user)")
        guard let email = user.profile.email,
              let firstName = user.profile.givenName,
              let lastName = user.profile.familyName else {
            return
        }
        
        UserDefaults.standard.setValue(email, forKey: "email")
        
        DatabaseManager.shared.userExists(with: email, completion: { exists in
            
            let chatUser = ChatAppUser(firstName: firstName,
                                       lastName: lastName,
                                       emailAddress: email)
            if !exists {
                DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                    if success {
                        // upload image
                        
                        if user.profile.hasImage {
                            guard let url = user.profile.imageURL(withDimension: 200) else {
                                return
                            }
                            
                            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                                guard let data = data else {
                                    return
                                }
                                let fileName = chatUser.profilePictureFileName
                                StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, success: { downloadUrl in
                                    UserDefaults.standard.setValue(downloadUrl, forKey: "Profile_picture_url")
                                    print(downloadUrl)
                                }, failured: { error in
                                    print("Storage manager error: \(error)")
                                })
                            }).resume()
                        }
                    }
                })
            }
        })
        
        guard let authentication = user.authentication else {
            print("Missing auth object off of google user")
            return
            
        }
          let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                         accessToken: authentication.accessToken)
        
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
            
            guard self != nil else {
                return
            }
            
            guard authResult != nil, error == nil else {
                print("Failed to log in with google credential")
                return
            }
            print("Successfully signed in with Google credential")
            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
        })
    }
 
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google uer was disconnected")
    }
    
}
