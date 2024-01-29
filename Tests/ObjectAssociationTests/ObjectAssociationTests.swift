import XCTest
@testable import ObjectAssociation
import ObjectAssociationRuntime


final class ObjectAssociationTests: XCTestCase {

    var classItem: ClassItem!

    override func setUp() {
        classItem = ClassItem()
    }

    func testValueType() {
        XCTAssertNil(
            classItem.valueType
        )

        classItem.valueType = "hello"
        XCTAssertEqual(
            classItem.valueType,
            "hello"
        )
        XCTAssertEqual(
            classItem.valueType,
            "hello"
        )
        XCTAssertEqual(
            classItem.valueType,
            "hello"
        )
        XCTAssertEqual(
            classItem.valueType,
            "hello"
        )
        XCTAssertEqual(
            classItem.valueType,
            "hello"
        )

        classItem.valueType = "modified"
        XCTAssertEqual(
            classItem.valueType,
            "modified"
        )

        classItem.valueType = nil
        XCTAssertNil(
            classItem.valueType
        )
    }

    func testReferenceType() {
        XCTAssertNil(
            classItem.referenceType
        )

        let id1 = UUID()
        classItem.referenceType = .init(id: id1)
        XCTAssertEqual(
            classItem.referenceType?.id,
            id1
        )
        XCTAssertEqual(
            classItem.referenceType?.id,
            id1
        )
        XCTAssertEqual(
            classItem.referenceType?.id,
            id1
        )
        XCTAssertEqual(
            classItem.referenceType?.id,
            id1
        )
        XCTAssertEqual(
            classItem.referenceType?.id,
            id1
        )

        let id2 = UUID()
        classItem.referenceType = .init(id: id2)
        XCTAssertEqual(
            classItem.referenceType?.id,
            id2
        )

        removeAssociatedObjects(classItem)
        XCTAssertNil(
            classItem.referenceType
        )

        classItem.referenceType = nil
        XCTAssertNil(
            classItem.referenceType
        )
    }
}

