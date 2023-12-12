//
//  MyPhotoAppApp.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/17/23.
//

import SwiftUI
import FirebaseCore
import AppTrackingTransparency
import FBSDKCoreKit
import CoreLocation


@main
struct MyPhotoAppApp: App {
    @ObservedObject var router = Router<Views>()
    @State private var showAuthenticationView: Bool = true

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.paths){
                RootScreenView(showAuthenticationView: $showAuthenticationView)
                    .navigationDestination(for: Views.self){ destination in
                        ViewFactory.viewForDestination(destination, showAuthenticationView: $showAuthenticationView)
                    }
            }
                .environmentObject(router)

        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in })
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        FirebaseApp.configure()
        LocationService.shared.requestLocation()
        return true
    }
          
    func application(_ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    

}
