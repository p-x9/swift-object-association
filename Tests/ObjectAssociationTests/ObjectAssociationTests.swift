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

        // short string
        // `NSTaggedPointerString` (macOS)
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

        // long string
        // `__NSCFString` (macOS)
        classItem.valueType = "modified hello"
        XCTAssertEqual(
            classItem.valueType,
            "modified hello"
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

    func testWeakReferenceType() {
        XCTAssertNil(
            classItem.weakReferenceType
        )

        let id1 = UUID()
        let item1: ClassItem? = .init(id: id1)

        classItem.weakReferenceType = item1
        XCTAssertEqual(
            classItem.weakReferenceType?.id,
            id1
        )
        XCTAssertEqual(
            classItem.weakReferenceType?.id,
            id1
        )
        XCTAssertEqual(
            classItem.weakReferenceType?.id,
            id1
        )
        XCTAssertEqual(
            classItem.weakReferenceType?.id,
            id1
        )
        XCTAssertEqual(
            classItem.weakReferenceType?.id,
            id1
        )

        let id2 = UUID()
        var item2: ClassItem?  = .init(id: id2)

        classItem.weakReferenceType = item2
        XCTAssertEqual(
            classItem.weakReferenceType?.id,
            id2
        )
        XCTAssertEqual(
            item1?.id,
            id1
        )


        item2 = nil
        XCTAssertNil(
            classItem.weakReferenceType
        )
    }
}

