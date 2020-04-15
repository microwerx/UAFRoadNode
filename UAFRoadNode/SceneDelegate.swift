//
//  SceneDelegate.swift
//
//  Created by Nami Kim  on 3/27/20
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        var layer_attr = ["name": "UFO Sightings", "creation_date": "12-30-1956", "crypto": "sfegwfewe", "crypto_key": "ewefwevew2334546574rg43ed2d", "md5_hash": "regwerg3434565344t5reg4ef"]
        if DBManager.shared.createDatabase() {
            DBManager.shared.insertTestRow()
            DBManager.shared.addLayerType(attr: layer_attr)
            DBManager.shared.execTestQuery()
            DBManager.shared.selectLayersQuery()
    
        }
        else {
            print("Failed to create database")
        }
    }
    
    let field_layers_id = "id"
    let field_layers_name = "name"
    let field_layers_creationDate = "creation_date"
    let field_layers_crypto = "crypto"
    let field_layers_cryptoKey = "crypto_key"
    let field_layers_md5Hash = "md5_hash"
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

