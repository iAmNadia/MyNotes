//
//  BaseBackendOperation.swift
//  Notes
//
//  Created by Надежда Морозова on 31/07/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

enum NetworkError {
    case unreachable
    case unexpected
    case wrong
}

class BaseBackendOperation: AsyncOperation {
    
    override init() {
        super.init()
    }
}
