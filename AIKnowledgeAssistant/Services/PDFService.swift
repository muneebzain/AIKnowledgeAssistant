//
//  PDFService.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 02/03/2026.
//

import Foundation
import PDFKit

final class PDFService {
    static func extractText(from url: URL) -> String? {
        guard let document = PDFDocument(url: url) else { return nil }

        var fullText = ""
        for i in 0..<document.pageCount {
            guard let page = document.page(at: i),
                  let pageText = page.string else { continue }
            fullText += pageText + "\n"
        }

        let trimmed = fullText.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
