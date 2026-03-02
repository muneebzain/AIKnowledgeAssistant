import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage

    private var isUser: Bool { message.role == .user }

    var body: some View {
        HStack {
            if isUser { Spacer(minLength: 40) }

            Text(message.text)
                .padding(12)
                .background(isUser ? Color.blue.opacity(0.15) : Color.gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)

            if !isUser { Spacer(minLength: 40) }
        }
    }
}
