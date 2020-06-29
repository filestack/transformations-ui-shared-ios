//
//  Math+Clamp.swift
//  TransformationsUI
//
//  Created by Mihály Papp on 10/07/2018.
//  Copyright © 2018 Mihály Papp. All rights reserved.
//

import Foundation

func clamp<T>(_ element: T, min minimum: T, max maximum: T) -> T where T: Comparable {
    return min(maximum, max(element, minimum))
}
