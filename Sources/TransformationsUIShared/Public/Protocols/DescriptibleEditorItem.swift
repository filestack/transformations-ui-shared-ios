//
//  DescriptibleEditorItem.swift
//  TransformationsUIShared
//
//  Created by Ruben Nine on 14/11/2019.
//  Copyright © 2019 Filestack. All rights reserved.
//

import UIKit

public protocol DescriptibleEditorItem: NSObject {
    var uuid: UUID { get }
    var title: String { get }
    var icon: UIImage? { get }
}

extension DescriptibleEditorItem {
    public var icon: UIImage? { nil }
}
