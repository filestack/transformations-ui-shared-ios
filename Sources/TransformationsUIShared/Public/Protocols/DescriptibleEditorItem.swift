//
//  DescriptibleEditorItem.swift
//  TransformationsUI
//
//  Created by Ruben Nine on 14/11/2019.
//  Copyright © 2019 Filestack. All rights reserved.
//

import UIKit

public protocol DescriptibleEditorItem: NSObject {
    var uuid: Int { get }
    var title: String { get }
    var icon: UIImage? { get }
}

extension DescriptibleEditorItem {
    public var icon: UIImage? { return nil }

    public var uuid: Int {
        var hasher = Hasher()
        hasher.combine(title)
        hasher.combine(icon)

        return hasher.finalize()
    }
}
