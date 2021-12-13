//
//  GameViewController.swift
//  ConstellationsWalker
//
//  Created by Lucas Pereira on 09/12/21.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // create a new scene
        let scene = SCNScene()
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        // set the scene to the view
        scnView.scene = scene
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 0)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
//        ambientLightNode.light!.color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        scene.rootNode.addChildNode(ambientLightNode)
        
        //Create a Sphere
        let sphereNode = SCNNode()
        sphereNode.geometry = SCNSphere(radius: 0.3)
        sphereNode.position = SCNVector3.init(x: 0, y: 1, z: -4)
        let redMaterial = SCNMaterial()
        redMaterial.diffuse.contents = UIColor.red
        sphereNode.geometry?.materials = [redMaterial]
        scene.rootNode.addChildNode(sphereNode)
        
        //Create sky sphere
        let skyNode = SCNNode()
        skyNode.geometry = SCNSphere(radius: 10)
        
        let starMapMaterial = SCNMaterial()
        starMapMaterial.diffuse.contents = UIImage(named: "starmap_8k.jpg")
        starMapMaterial.isDoubleSided = true
        
//        let constellationsMaterial = SCNMaterial()
//        constellationsMaterial.diffuse.contents = UIImage(named: "starmapAndConstellations_8k.jpg")
//        constellationsMaterial.isDoubleSided = true
        
        skyNode.geometry?.materials = [starMapMaterial]
        scene.rootNode.addChildNode(skyNode)
        
        //Create Equator Line
        let equatorLine = SCNNode()
        equatorLine.geometry = SCNTube(innerRadius: 9.8, outerRadius: 9.9, height: 0.05)
        equatorLine.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(20), y: 0, z: GLKMathDegreesToRadians(20))
        let equatorLineMaterial = SCNMaterial()
        equatorLineMaterial.diffuse.contents = UIColor.yellow
        equatorLineMaterial.isDoubleSided = true
        equatorLine.geometry?.firstMaterial = equatorLineMaterial
        scene.rootNode.addChildNode(equatorLine)
        
        //Create Plane
        let planeNode = SCNNode(geometry: SCNPlane(width: 40, height: 40))
        planeNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: 0, z: 0)
        let tealMaterial = SCNMaterial()
        tealMaterial.diffuse.contents = UIColor.systemTeal
        planeNode.geometry?.materials = [tealMaterial]
        scene.rootNode.addChildNode(planeNode)
        
        // Create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x:0 , y: 2, z: 0)
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        scnView.defaultCameraController.interactionMode = .fly
        scnView.defaultCameraController.inertiaEnabled = true
        scnView.defaultCameraController.maximumVerticalAngle = 89
        scnView.defaultCameraController.minimumVerticalAngle = -89
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
