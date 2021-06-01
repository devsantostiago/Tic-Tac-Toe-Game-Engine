import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Tic_Tac_Toe_EngineTests.allTests),
    ]
}
#endif
