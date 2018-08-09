//
//  ViewController+ObjectAddition.swift
//  DesignCodeARKit
//
//  Created by Tim Gorer on 8/7/18.
//  Copyright © 2018 Tim Gorer. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

extension ViewController {
    
    fileprivate func getModel(named name : String) ->SCNNode? {
        let scene = SCNScene(named: "art.scnassets/\(name)/\(name).scn")
        guard let model = scene?.rootNode.childNode(withName: "SketchUp", recursively: false) else { return nil }
        model.name = name
        
        var scale : CGFloat
        
        switch name {
        case "iPhoneX":          scale = 0.025
        case "iPhone6s":         scale = 0.025
        case "iPhone7":          scale = 0.0001
        case "iPhone8":          scale = 0.000008
        case "iPhone8Plus":      scale = 0.000008
        case "iPad4":            scale = 0.00054
        case "MacbookPro13":     scale = 0.0022
        case "iMacPro":          scale = 0.0245
        case "AppleWatch":       scale = 0.0000038
        default:                 scale = 1
        }
        
        model.scale = SCNVector3(scale, scale, scale)
        return model
    }
    
    @IBAction func addObjectButtonTapped(_ sender: Any) {
        print("add object button tapped.")
        
        guard focusSquare != nil else { return }
        
        let modelName = "iPhoneX"
        guard let model = getModel(named: modelName) else {
            print("Unable to load \(modelName) from file")
            return
        }
        
        let hitTest = sceneView.hitTest(screenCenter, types: .existingPlaneUsingExtent)
        guard let worldTransformColumn3 = hitTest.first?.worldTransform.columns.3 else { return }
        model.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
        
        sceneView.scene.rootNode.addChildNode(model)
        print(")\(modelName) added successfully.")
        
        modelsInTheScene.append(model)
        print("Currently have \(modelsInTheScene.count) models in the scene")
    }
}
