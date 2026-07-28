import XCTest
@testable import AIAvatar

final class AIKnowledgeBaseTests: XCTestCase {
    private let knowledgeBase = AIKnowledgeBase()

    func testAnswersWhatIsAI() {
        let answer = knowledgeBase.answer(for: "What is AI?")
        XCTAssertTrue(answer.lowercased().contains("artificial intelligence"))
    }

    func testAnswersMachineLearningQuestion() {
        let answer = knowledgeBase.answer(for: "Can you explain machine learning?")
        XCTAssertTrue(answer.lowercased().contains("machine learning"))
    }

    func testAnswersLargeLanguageModelQuestion() {
        let answer = knowledgeBase.answer(for: "How do large language models work?")
        XCTAssertTrue(answer.lowercased().contains("language model"))
    }

    func testAnswersNeuralNetworkQuestion() {
        let answer = knowledgeBase.answer(for: "What is a neural network?")
        XCTAssertTrue(answer.lowercased().contains("neural network"))
    }

    func testFallsBackGracefullyOnUnrelatedQuestion() {
        let answer = knowledgeBase.answer(for: "What's the capital of France?")
        XCTAssertFalse(answer.isEmpty)
    }

    func testHandlesEmptyInput() {
        let answer = knowledgeBase.answer(for: "")
        XCTAssertFalse(answer.isEmpty)
    }

    func testIsCaseInsensitive() {
        let lower = knowledgeBase.answer(for: "what is ai")
        let upper = knowledgeBase.answer(for: "WHAT IS AI")
        XCTAssertEqual(lower, upper)
    }
}
