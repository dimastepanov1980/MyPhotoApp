//
//  MyPhotoAppApp.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/17/23.
//

import SwiftUI
import Firebase

@main

 // MARK: Версия без AppDelegate выдент предопреждение "App Delegate does not conform to UIApplicationDelegate protocol."
/*
struct MyPhotoAppApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                AuthScreenView(with: AuthScreenViewModel())
            }
        }
    }
}
*/

// MARK: Версия с AppDelegate работает без предупрежденя "App Delegate does not conform to UIApplicationDelegate protocol."

struct MyPhotoAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
                MainScreenView(with: MainScreenViewModel())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
