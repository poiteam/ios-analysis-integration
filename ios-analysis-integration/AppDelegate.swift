//
//  AppDelegate.swift
//  ios-analysis-integration
//
//  Created by Emre Kuru on 4.02.2021.
//

import UIKit
import PoilabsAnalysis

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if launchOptions?[UIApplication.LaunchOptionsKey.location] != nil {
            if application.applicationState == UIApplication.State.background {
                PLSuspendedAnalysisManager.sharedInstance()?.startBeaconMonitoring()
            }
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        PLAnalysisSettings.sharedInstance().applicationId = "APPLICATION_ID"
        PLAnalysisSettings.sharedInstance().applicationSecret = "APPLICATION_SECRET_KEY"
        PLAnalysisSettings.sharedInstance().analysisUniqueIdentifier = "UNIQUE_ID"

        PLConfigManager.sharedInstance().getReadyForTracking(completionHandler: { error in
            if error != nil {
                if let anError = error {
                    print("Error Desc \(anError)")
                }
            } else {
                print("Error Nil")
                PLSuspendedAnalysisManager.sharedInstance()?.stopBeaconMonitoring()
                PLStandardAnalysisManager.sharedInstance()?.startBeaconMonitoring()
                PLStandardAnalysisManager.sharedInstance().delegate = self
            }
        })
    }




}

extension AppDelegate: PLAnalysisManagerDelegate {
    func analysisManagerResponse(forBeaconMonitoring response: [AnyHashable : Any]!) {
        print(response)
    }
    func analysisManagerDidFail(withPoiError error: PLError!) {
        print(error)
    }
}
