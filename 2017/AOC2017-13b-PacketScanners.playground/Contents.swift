//: Advent of Code 2017 - Day 13 - Part 2
// https://adventofcode.com/2017/day/13

import Foundation
import XCTest

func delaysForUndetectedFirewallTrip(input: String) -> Int {
  let layerStrings = input.components(separatedBy: CharacterSet.newlines)
  var inputLayers = [Layer]()
  for layerString in layerStrings {
    let layer = Layer(input: layerString)
    inputLayers.append(layer)
  }
  var layers = [Layer?](repeating: nil, count: inputLayers.last!.depth+1)
  for layer in inputLayers {
    layers[layer.depth] = layer
  }

  var undetectedTrip = false
  var delays = 0
  while !undetectedTrip {
    undetectedTrip = undetectedFirewallTrip(layers: layers)
    if !undetectedTrip {
      iterateLayers(layers: &layers)
      delays += 1
    }
  }

  return delays
}

func undetectedFirewallTrip(layers: [Layer?]) -> Bool {
  var layers = layers // mutable version
  for i in 0...layers.count-1 {
    if let layer = layers[i] {
      if layer.scannerPosition == 0 {
        return false
      }
    }
    iterateLayers(layers: &layers)
  }

  return true
}

func iterateLayers(layers: inout [Layer?]) {
  for layer in layers {
    if var layer = layer {
      layer.iterate()
      layers[layer.depth] = layer
    }
  }
}

enum Direction {
  case up, down
}

struct Layer {
  let depth: Int
  let range: Int
  let severity: Int
  var scannerPosition = 0
  var scannerDirection = Direction.down

  init(input: String) {
    let components = input.components(separatedBy: ": ")
    depth = Int(components[0])!
    range = Int(components[1])!
    severity = depth*range
  }

  mutating func iterate() {
    switch scannerDirection {
    case .down:
      scannerPosition += 1
      if scannerPosition == range-1 {
        scannerDirection = .up
      }
    case .up:
      scannerPosition -= 1
      if scannerPosition == 0 {
        scannerDirection = .down
      }
    }
  }
}

class Tests : XCTestCase {

  func testInput1() {
    let input = """
0: 3
1: 2
4: 4
6: 4
"""

    let delays = delaysForUndetectedFirewallTrip(input: input)
    XCTAssertEqual(delays, 10)
  }

  func test() {
    let input = """
0: 3
1: 2
2: 6
4: 4
6: 4
8: 10
10: 6
12: 8
14: 5
16: 6
18: 8
20: 8
22: 12
24: 6
26: 9
28: 8
30: 8
32: 10
34: 12
36: 12
38: 8
40: 12
42: 12
44: 14
46: 12
48: 12
50: 12
52: 12
54: 14
56: 14
58: 14
60: 12
62: 14
64: 14
66: 17
68: 14
72: 18
74: 14
76: 20
78: 14
82: 18
86: 14
90: 18
92: 14
"""
    let delays = delaysForUndetectedFirewallTrip(input: input)
    XCTAssertEqual(delays, 3878062) // Run on command line takes 376.173 seconds
  }
}

Tests.defaultTestSuite.run()
