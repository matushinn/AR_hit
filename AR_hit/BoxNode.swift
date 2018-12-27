//
//  BoxNode.swift
//  AR_hit
//
//  Created by 大江祥太郎 on 2018/12/27.
//  Copyright © 2018年 shotaro. All rights reserved.
//

import UIKit
import ARKit

class BoxNode: SCNNode {
    required init?(coder aDecoder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        super.init()
        //ジオメトリを作る
        let box = SCNBox(width: 0.1, height: 0.05, length: 0.1, chamferRadius: 0.01)
        //塗り
        box.firstMaterial?.diffuse.contents = UIColor.gray
        //ノードのgeometryプロパティに設定する
        geometry = box
    }
}
