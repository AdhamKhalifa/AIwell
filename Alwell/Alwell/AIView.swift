//
//  AIView.swift
//  Alwell
//
//  Created by Adham Khalifa on 8/11/24.
//

import SwiftUI

struct AIView: View {
    @EnvironmentObject var healthManager: HealthManager

    @State private var userMessage: String = ""
    @State private var chatMessages: [ChatMessage] = [
        ChatMessage(id: UUID(), text: "Welcome to the AI Health Chat! How can I assist you today?", isUser: false)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(chatMessages) { message in
                            ChatBubble(message: message)
                        }
                    }
                    .padding()
                }
                
                HStack {
                    TextField("Type your message...", text: $userMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 30)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                    .padding(.leading, 5)
                }
                .padding()
            }
            .navigationBarTitle("AI Chat", displayMode: .inline)
        }
    }
    
    private func sendMessage() {
        if !userMessage.isEmpty {
            let newMessage = ChatMessage(id: UUID(), text: userMessage, isUser: true)
            chatMessages.append(newMessage)
            userMessage = ""
            
            // Simulate AI response
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let aiResponse = ChatMessage(id: UUID(), text: "Here's some advice based on your query: ...", isUser: false)
                chatMessages.append(aiResponse)
            }
        }
    }
}

struct ChatMessage: Identifiable {
    let id: UUID
    let text: String
    let isUser: Bool
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .frame(maxWidth: 250, alignment: .trailing)
            } else {
                Text(message.text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .frame(maxWidth: 250, alignment: .leading)
                Spacer()
            }
        }
    }
}

struct AIView_Previews: PreviewProvider {
    static var previews: some View {
        AIView()
    }
}
