//
//  EthereumValueTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 13.02.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Web3

class EthereumValueTests: QuickSpec {

    var encoder: JSONEncoder = JSONEncoder()
    var decoder: JSONDecoder = JSONDecoder()

    override func spec() {
        describe("ethereum call params") {
            context("int values") {

                it("should encode successfully") {
                    let value: EthereumValue = 10
                    let value2: EthereumValue = .int(100)
                    let valueEdge0: EthereumValue = 0
                    let valueEdge1: EthereumValue = 1

                    let encoded = try? self.encoder.encode([value, value2, valueEdge0, valueEdge1])

                    expect(encoded).toNot(beNil())
                    expect(encoded?.makeBytes().makeString()) == "[10,100,0,1]"
                }

                it("should decode successfully") {
                    let encoded = "[10,100,0,1]"

                    let decoded = try? self.decoder.decode(EthereumValue.self, from: Data(encoded.makeBytes()))

                    expect(decoded).toNot(beNil())
                    expect(decoded?.array?.count) == 4
                    expect(decoded?.array?[safe: 0]?.int) == 10
                    expect(decoded?.array?[safe: 1]?.int) == 100

                    expect(decoded?.array?[safe: 2]?.bool).to(beNil())
                    expect(decoded?.array?[safe: 3]?.bool).to(beNil())
                    expect(decoded?.array?[safe: 2]?.int) == 0
                    expect(decoded?.array?[safe: 3]?.int) == 1
                }
            }

            context("bool values") {

                it("should encode successfully") {
                    let value: EthereumValue = true
                    let value2: EthereumValue = .bool(false)

                    let encoded = try? self.encoder.encode([value, value2])

                    expect(encoded).toNot(beNil())
                    expect(encoded?.makeBytes().makeString()) == "[true,false]"
                }

                it("should decode successfully") {
                    let encoded = "[true,false]"

                    let decoded = try? self.decoder.decode(EthereumValue.self, from: Data(encoded.makeBytes()))

                    expect(decoded).toNot(beNil())
                    expect(decoded?.array?.count) == 2
                    expect(decoded?.array?[safe: 0]?.bool) == true
                    expect(decoded?.array?[safe: 1]?.bool) == false

                    expect(decoded?.array?[safe: 0]?.int).to(beNil())
                    expect(decoded?.array?[safe: 0]?.array).to(beNil())
                    expect(decoded?.array?[safe: 0]?.string).to(beNil())
                }
            }

            context("nil values") {

                it("should encode successfully") {
                    let value = EthereumValue(valueType: .nil)

                    let encoded = try? self.encoder.encode([value, value])

                    expect(encoded).toNot(beNil())
                    expect(encoded?.makeBytes().makeString()) == "[null,null]"
                }

                it("should decode successfully") {
                    let encoded = "[null,null]"

                    let decoded = try? self.decoder.decode(EthereumValue.self, from: Data(encoded.makeBytes()))

                    expect(decoded?.array?.count) == 2
                    // TODO: Add nil checking...
                }
            }
        }
    }
}

fileprivate extension Collection {

    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
