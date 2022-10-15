//
//  SceneElements.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 10/14/22.
//

import Foundation

import SpriteKit

struct Parcel {
    var node: SKSpriteNode
    var board: SKSpriteNode
    var tree: SKSpriteNode?
    var soils: [Soil] = []
    var currentSoil: Soil? {
        if soils[0].isFull != false {
            return soils[0]
        } else if soils[1].isFull != false  {
            return soils[1]
        }
        return nil
    }
}

struct Soil {
    var node: SKSpriteNode
    var flowers: [SKSpriteNode] = []
    var numFlowers: Int { flowers.count }
    var lastFlower : SKSpriteNode? {
        if flowers.count != 0 { return flowers.last }
        return nil
    }
    var isFull: Bool { numFlowers == 4 }
    var alignment: SoilAlignment
}

enum SoilAlignment{
    case horizontal, vertical
}
