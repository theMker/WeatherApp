import Foundation

/// A lightweight, offline knowledge base that answers general questions about AI.
///
/// Matching is keyword-based: each topic lists the words/phrases most likely to
/// appear in a question about it, and the topic with the highest overlap with
/// the user's question wins. No network access or API key is required.
public struct AIKnowledgeBase {

    private struct Topic {
        let keywords: [String]
        let answer: String
    }

    private let topics: [Topic]
    private let fallbackAnswers: [String]

    public init() {
        topics = AIKnowledgeBase.defaultTopics
        fallbackAnswers = AIKnowledgeBase.defaultFallbackAnswers
    }

    /// Returns the best-matching answer for a free-form question.
    public func answer(for question: String) -> String {
        let words = Self.normalize(question)
        guard !words.isEmpty else {
            return fallbackAnswers[0]
        }

        var bestScore = 0
        var bestAnswer: String?

        for topic in topics {
            let score = Self.score(words: words, against: topic.keywords)
            if score > bestScore {
                bestScore = score
                bestAnswer = topic.answer
            }
        }

        if let bestAnswer, bestScore > 0 {
            return bestAnswer
        }

        let index = abs(question.hashValue) % fallbackAnswers.count
        return fallbackAnswers[index]
    }

    private static func normalize(_ text: String) -> Set<String> {
        let lowered = text.lowercased()
        let separators = CharacterSet.alphanumerics.inverted
        let words = lowered.components(separatedBy: separators).filter { !$0.isEmpty }
        return Set(words)
    }

    private static func score(words: Set<String>, against keywords: [String]) -> Int {
        var score = 0
        for keyword in keywords {
            if keyword.contains(" ") {
                // multi-word keyword: check as substring for phrase matches
                if words.contains(where: { $0 == keyword }) { score += 1 }
            } else if words.contains(keyword) {
                score += 1
            }
        }
        return score
    }

    private static let defaultFallbackAnswers: [String] = [
        "I'm not sure about that one yet. Try asking me about AI basics, machine learning, neural networks, or how large language models work.",
        "That's outside what I currently know how to answer. I'm best at general AI concepts — try rephrasing, or ask me something like \"what is machine learning?\"",
        "I don't have a good answer for that. I can help with questions about AI, ML, neural networks, LLMs, and related topics."
    ]

    private static let defaultTopics: [Topic] = [
        Topic(
            keywords: ["ai", "artificial", "intelligence"],
            answer: """
            Artificial intelligence (AI) is the field of building systems that perform tasks \
            normally requiring human intelligence — understanding language, recognizing images, \
            making decisions, and learning from data. Modern AI mostly relies on machine learning, \
            where systems improve at a task by learning patterns from examples rather than following \
            hand-written rules.
            """
        ),
        Topic(
            keywords: ["machine", "learning", "ml"],
            answer: """
            Machine learning (ML) is a branch of AI where a program learns to perform a task by \
            finding patterns in data, instead of being explicitly programmed with rules. You give \
            it examples (like emails labeled "spam" or "not spam"), and it learns a model that can \
            make predictions on new, unseen examples.
            """
        ),
        Topic(
            keywords: ["neural", "network", "networks", "neuron", "neurons"],
            answer: """
            A neural network is a machine learning model loosely inspired by the brain. It's made \
            of layers of simple units ("neurons") connected together; each connection has a weight \
            that's adjusted during training. By stacking many layers, neural networks can learn \
            very complex patterns, which is why they power most modern AI systems.
            """
        ),
        Topic(
            keywords: ["deep", "learning"],
            answer: """
            Deep learning is machine learning using neural networks with many layers ("deep" \
            networks). It's especially good at learning directly from raw data like pixels, audio, \
            or text, and is the technology behind image recognition, speech recognition, and large \
            language models.
            """
        ),
        Topic(
            keywords: ["nlp", "natural", "language", "processing"],
            answer: """
            Natural language processing (NLP) is the area of AI focused on understanding and \
            generating human language — things like translation, sentiment analysis, chatbots, and \
            summarization. Today's NLP is largely powered by large language models trained on huge \
            amounts of text.
            """
        ),
        Topic(
            keywords: ["llm", "llms", "large", "gpt", "claude", "chatbot", "chatbots"],
            answer: """
            A large language model (LLM) is a neural network trained on massive amounts of text to \
            predict the next word in a sequence. That simple training objective, at huge scale, \
            lets LLMs like GPT and Claude answer questions, write text, summarize, translate, and \
            hold conversations, even though they were never explicitly programmed to do any of that.
            """
        ),
        Topic(
            keywords: ["prompt", "prompting", "engineering"],
            answer: """
            Prompt engineering is the practice of crafting the input you give an AI model to get \
            better results — being specific about the task, giving examples, specifying a format, \
            or asking the model to reason step by step. Good prompts reduce ambiguity, which \
            usually improves the quality and reliability of the model's response.
            """
        ),
        Topic(
            keywords: ["train", "training", "trained", "dataset", "data"],
            answer: """
            Training is the process of showing a machine learning model many examples and adjusting \
            its internal parameters so its predictions get closer to the correct answers over time. \
            For large language models, training typically involves reading huge collections of text \
            and learning statistical patterns in language.
            """
        ),
        Topic(
            keywords: ["agi", "general"],
            answer: """
            Artificial general intelligence (AGI) refers to a hypothetical AI system that can \
            understand and learn any intellectual task a human can, matching or exceeding human \
            flexibility across domains — as opposed to today's "narrow" AI, which excels at \
            specific tasks it was designed or trained for. AGI does not exist yet, and experts \
            disagree on when, or whether, it will.
            """
        ),
        Topic(
            keywords: ["hallucination", "hallucinate", "hallucinations", "wrong", "mistake", "accurate", "accuracy"],
            answer: """
            An AI "hallucination" is when a model confidently states something false or made up — \
            for example, citing a source that doesn't exist. It happens because language models \
            generate plausible-sounding text based on patterns, not because they look facts up in a \
            database, so they can produce fluent but incorrect answers, especially on obscure or \
            fast-changing topics.
            """
        ),
        Topic(
            keywords: ["bias", "biased", "fair", "fairness", "ethic", "ethics", "ethical"],
            answer: """
            AI bias happens when a model's outputs unfairly favor or disadvantage certain groups, \
            usually because the data it was trained on reflects historical or societal biases. AI \
            ethics is the broader field studying how to build and deploy AI responsibly — covering \
            fairness, privacy, transparency, safety, and accountability.
            """
        ),
        Topic(
            keywords: ["job", "jobs", "replace", "replacing", "automation", "unemployment"],
            answer: """
            AI is automating specific tasks rather than entire jobs overnight — it tends to change \
            how work is done (e.g. drafting, summarizing, coding assistance) more than eliminate \
            roles wholesale. Historically, automation has also created new kinds of jobs, though the \
            transition can be disruptive, and which effect dominates varies a lot by industry.
            """
        ),
        Topic(
            keywords: ["safe", "safety", "danger", "dangerous", "risk", "risks", "control"],
            answer: """
            AI safety is the field focused on making sure AI systems behave as intended, don't cause \
            unintended harm, and remain under meaningful human control as they become more capable. \
            Current concerns include misuse, bias, privacy, misinformation, and, for more advanced \
            future systems, the challenge of reliably aligning their behavior with human values.
            """
        ),
        Topic(
            keywords: ["difference", "versus", "vs", "compare"],
            answer: """
            AI is the broad goal of making machines act intelligently. Machine learning is the \
            main modern approach to AI, where systems learn from data. Deep learning is a subset of \
            machine learning that uses many-layered neural networks. So: AI ⊃ machine learning ⊃ \
            deep learning, each one a more specific technique within the one before it.
            """
        ),
        Topic(
            keywords: ["computer", "vision", "image", "images", "recognition"],
            answer: """
            Computer vision is the area of AI that lets machines interpret visual information — \
            identifying objects in photos, recognizing faces, reading text in images, or guiding \
            self-driving cars. It's typically powered by deep neural networks trained on large sets \
            of labeled images.
            """
        ),
        Topic(
            keywords: ["reinforcement"],
            answer: """
            Reinforcement learning is a training approach where an AI agent learns by trial and \
            error, taking actions in an environment and receiving rewards or penalties. Over many \
            attempts it learns a strategy ("policy") that maximizes reward — it's how systems like \
            game-playing AIs (and part of how chatbots are fine-tuned) are trained.
            """
        ),
        Topic(
            keywords: ["you", "yourself", "who", "avatar"],
            answer: """
            I'm an avatar built to answer general questions about artificial intelligence — things \
            like what AI and machine learning are, how neural networks and large language models \
            work, and common concerns like bias, safety, and hallucinations. Ask me anything in that \
            space!
            """
        )
    ]
}
