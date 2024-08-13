import SwiftUI

struct AIView: View {
    @EnvironmentObject var healthManager: HealthManager
    @StateObject private var aiManager = AIManager()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    @State private var userMessage: String = ""
    @State private var chatMessages: [ChatMessage] = [
        ChatMessage(id: UUID(), text: "Welcome to the AI Health Chat! How can I assist you today?", isUser: false)
    ]
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(chatMessages) { message in
                            ChatBubble(message: message, colorScheme: colorScheme)
                        }
                        
                        // Show loading indicator when waiting for AI response
                        if isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .dark ? .white : .blue))
                                    .scaleEffect(1.5)
                                    .padding()
                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
                
                HStack {
                    TextField("Type your message...", text: $userMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 30)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 24))
                            .foregroundColor(colorScheme == .dark ? .white : .blue)
                    }
                    .padding(.leading, 5)
                }
                .padding()
            }
            .navigationBarTitle("AI Chat", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(colorScheme == .dark ? .white : .blue)
            })
        }
    }
    
    private func sendMessage() {
        if !userMessage.isEmpty {
            let newMessage = ChatMessage(id: UUID(), text: userMessage, isUser: true)
            chatMessages.append(newMessage)
            userMessage = ""
            isLoading = true
            
            let userContext = aiManager.getUserContext()
            let healthContext = aiManager.getHealthContext(healthManager: healthManager)
            let fullContext = userContext + "\n\n" + healthContext
            
            aiManager.sendMessage(newMessage.text, withContext: fullContext) { response in
                let aiResponse = ChatMessage(id: UUID(), text: response, isUser: false)
                chatMessages.append(aiResponse)
                isLoading = false
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
    let colorScheme: ColorScheme
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(colorScheme == .dark ? Color.gray.opacity(0.7) : Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .frame(maxWidth: 250, alignment: .trailing)
            } else {
                Text(message.text)
                    .padding()
                    .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(maxWidth: 250, alignment: .leading)
                Spacer()
            }
        }
    }
}

struct AIView_Previews: PreviewProvider {
    static var previews: some View {
        AIView()
            .environmentObject(HealthManager())
            .environment(\.colorScheme, .light)  
    }
}
