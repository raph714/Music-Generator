//
//  Weight.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 3/29/20.
//  Copyright © 2020 defranco. All rights reserved.
//

import Foundation

protocol Weight {
}

extension Weight {
	static func random<T>(for dict: [AnyHashable: Int]) -> T {
        //sum the values
        let sum = dict.values.reduce(0) { result, next -> Int in
            return result + next
        }

        let random = Int.random(in: 1...sum)

        var currentCount = 0
        for (key, value) in dict {
            currentCount += value

            if currentCount >= random {
                return key as! T
            }
        }

        fatalError()
    }
}
