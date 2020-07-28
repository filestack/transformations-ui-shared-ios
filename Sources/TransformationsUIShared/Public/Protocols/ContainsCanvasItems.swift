//
//  ContainsCanvasItems.swift
//  TransformationsUIShared
//
//  Created by Ruben Nine on 24/07/2020.
//  Copyright © 2020 Filestack. All rights reserved.
//

import Foundation
import CoreGraphics

public protocol CanvasItem {}

public protocol ContainsCanvasItems: RenderNode {
    func canvasItem(at point: CGPoint) -> CanvasItem?
    var selectedCanvasItem: CanvasItem? { get set }
}
