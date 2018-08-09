//
//  ViewController+ARSCNViewDelegate.swift
//  DesignCodeARKit
//
//  Created by Tim Gorer on 8/7/18.
//  Copyright © 2018 Tim Gorer. All rights reserved.
//

import SceneKit
import ARKit

extension ViewController : ARSCNViewDelegate {
    
    // notifies us when a camera detects an object, then will tag an anchor to it. An anchor gives position, orientation, and dim of an object that is tracked. Anchor is used to place virtual objects on the scene. An anchor is then assigned a node.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        // let planeAnchor = anchor as! ARPlaneAnchor
        
        // make a new plane node
        //let planeNode = createPlane(planeAnchor: planeAnchor)
        
        // make plane node child node of node which represents the flat surface
        //node.addChildNode(planeNode)
        //print("adding child node to this planeNode: ", planeNode)
        
        // if focus square already exists don't make a new one
        guard focusSquare == nil else { return }
        let focusSquareLocal = FocusSquare()
        sceneView.scene.rootNode.addChildNode(focusSquareLocal)
        focusSquare = focusSquareLocal
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        print("horizontal surface updated.")
        
        // let planeAnchor = anchor as! ARPlaneAnchor
        
         // to update dimensions of plane anchor, remove it from scene, then add it back.
        // node.enumerateChildNodes { (childNode, _) in
        //    childNode.removeFromParentNode()
        // }
        
        // let planeNode = createPlane(planeAnchor: planeAnchor)
        //node.addChildNode(planeNode)
    }
    
    // removes duplicate anchors for the same surface
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        print("Horizontal surface removed.")
        
        // node.enumerateChildNodes { (childNode, _) in
        //    childNode.removeFromParentNode()
        // }
    }
    
    // this is to instruct delegate to update accordingly once per frame, at system's current time.
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let focusSquareLocal = focusSquare else { return }
        
        // determines intersection between screen center and surface detected.
        let hitTest = sceneView.hitTest(screenCenter, types: .existingPlane)
        let hitTestResult = hitTest.first
        
        // retrieve position of the surface.
        guard let worldTransform = hitTestResult?.worldTransform else { return }
        let worldTransformColumn3 = worldTransform.columns.3
        
        // assign position to the focus square so it gets updated as camera moves.
        focusSquareLocal.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
        
        DispatchQueue.main.async {
            self.updateFocusSquare()
        }
    }
    
    // inputs a plane anchor and outputs an SCNNode
    func createPlane(planeAnchor: ARPlaneAnchor) -> SCNNode {
        // set geometry for the node, which is a plane
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        plane.firstMaterial?.diffuse.contents = UIImage(named: "grid")
        
        // make plane image cover both sides of plane
        plane.firstMaterial?.isDoubleSided = true
        
        // Creates and returns a node object with the specified image (geometry) attached.
        let planeNode = SCNNode(geometry: plane)
        
        // we need to place the plane node at center of detected surface
        planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        planeNode.eulerAngles.x = GLKMathDegreesToRadians(-90) // rotate 90 degrees clockwise
        
        return planeNode
    }
}
