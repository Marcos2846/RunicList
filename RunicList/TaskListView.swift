import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskItem.createdAt, order: .reverse) private var tasks: [TaskItem]
    
    @State private var newTaskTitle = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Main Content
                ScrollView {
                    if tasks.isEmpty {
                        ContentUnavailableView(
                            "Sin Tareas",
                            systemImage: "tray",
                            description: Text("Añade una nueva tarea para comenzar tu día.")
                        )
                        .padding(.top, 60)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(tasks) { task in
                                TaskRowView(task: task)
                                    // Swipe to delete capability
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            deleteTask(task)
                                        } label: {
                                            Label("Eliminar", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding()
                        .padding(.bottom, 80) // Space for the floating input
                    }
                }
                .background(Color(uiColor: .systemGroupedBackground))
                
                // Floating Input Area
                VStack {
                    Spacer()
                    HStack {
                        TextField("Nueva tarea...", text: $newTaskTitle)
                            .focused($isInputFocused)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                            .submitLabel(.done)
                            .onSubmit {
                                addTask()
                            }
                        
                        Button(action: addTask) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(newTaskTitle.isEmpty ? .gray : .accentColor)
                        }
                        .disabled(newTaskTitle.isEmpty)
                        .animation(.easeInOut, value: newTaskTitle.isEmpty)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                }
            }
            .navigationTitle("Runic List")

        }
    }
    
    private func addTask() {
        guard !newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            let newTask = TaskItem(title: newTaskTitle)
            modelContext.insert(newTask)
            newTaskTitle = ""
        }
    }
    
    private func deleteTask(_ task: TaskItem) {
        withAnimation(.easeInOut) {
            modelContext.delete(task)
        }
    }
}

// Subview for each Task to keep the main view clean
struct TaskRowView: View {
    @Bindable var task: TaskItem
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    task.isCompleted.toggle()
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(task.isCompleted ? .green : .gray.opacity(0.5))
            }
            .buttonStyle(PlainButtonStyle())
            
            TextField("Nombre de la tarea", text: $task.title)
                .font(.body)
                .strikethrough(task.isCompleted)
                .foregroundColor(task.isCompleted ? .secondary : .primary)
                .disabled(task.isCompleted)
                .submitLabel(.done)
            
            Spacer()
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
        .opacity(task.isCompleted ? 0.6 : 1.0)
    }
}

#Preview {
    TaskListView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}
