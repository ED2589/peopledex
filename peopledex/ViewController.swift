//
//  ViewController.swift
//  peopledex
//
//  Created by Blake Brown on 2018-08-25.
//  Copyright © 2018 Blake Brown. All rights reserved.
//

import UIKit
import SceneKit
import CoreLocation
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var statusTextView: UITextView!
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    
    var status: String! {
        didSet {
            setStatusText()
        }
    }

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Start location services
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        // Set the initial status
        status = "Getting user location..."
        
        // Set a padding in the text view
//        statusTextView.textContainerInset = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 10.0, right: 0.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func setStatusText() {
        let distance = 50
        var text = "Status: \(status!)\n"
        text += "Distance: \(String(format: "%.2f m", distance))"
        statusTextView.text = text
    }
    
   
}

//extension String {
//    func image() -> UIImage? {
//        let size = CGSize(width: 100, height: 100)
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        UIColor.clear.set()
//        let rect = CGRect(origin: CGPoint(), size: size)
//        UIRectFill(CGRect(origin: CGPoint(), size: size))
//        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 90)])
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
//}
