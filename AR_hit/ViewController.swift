//
//  ViewController.swift
//  AR_hit
//
//  Created by 大江祥太郎 on 2018/12/27.
//  Copyright © 2018年 shotaro. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        //ワイヤーフレーム表示
        sceneView.debugOptions = .showWireframe
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        //平面の検出を有効化する
        configuration.planeDetection = [.horizontal]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    //シーンビューsceneViewをタップした
    @IBAction func tapSceneView(_ sender: UITapGestureRecognizer) {
        //検知平面とのヒットテスト
        //タップした2D座標
        let tapLoc = sender.location(in:sceneView)
        //検知平面とタップ座標のヒットテスト
        let results = sceneView.hitTest(tapLoc, types: .existingPlaneUsingExtent)
        //検知表面をタップしていたら最前面のヒットデータをresultに入れる
        guard let result = results.first else {
            return
        }
        
        //ヒットテストの結果からAR空間のワールド座標を取り出す
        let pos = result.worldTransform.columns.3
        //箱ノードを作る
        let boxNode = BoxNode()
        //ノードの高さを求める
        let height = boxNode.boundingBox.max.y - boxNode.boundingBox.min.y
        //水平面と箱の底を合わせる
        let y = pos.y + Float(height/2.0)
        //位置決めする
        boxNode.position = SCNVector3(pos.x,y,pos.z)
        //シーンに箱ノードを追加する
        sceneView.scene.rootNode.addChildNode(boxNode)
        
    }
    
    // MARK: - ARSCNViewDelegate
    //ノードが追加された
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //平面アンカーでないときは中断する
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        //アンカーが示す位置に平面ノードを追加する
        node.addChildNode(PlaneNode(anchor:planeAnchor))
    }
    
    //ノードが更新された
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        //平面アンカーではないときは中断する
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        //planenodeでないときは中断する
        guard let planeNode = node.childNodes.first as? PlaneNode else {
            return
        }
        
        //ノードの位置とサイズを更新する
        planeNode.update(anchor:planeAnchor)
    }
    
    
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
}
