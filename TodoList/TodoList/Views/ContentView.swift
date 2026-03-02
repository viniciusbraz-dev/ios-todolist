import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: [
        SortDescriptor(\TodoItem.isCompleted, order: .forward),
        SortDescriptor(\TodoItem.createdAt, order: .reverse)
    ])
    private var items: [TodoItem]

    @Environment(\.modelContext) private var modelContext

    @State private var showingAddTask = false
    @State private var itemToEdit: TodoItem?
    @State private var showCompleted = true

    var filteredItems: [TodoItem] {
        showCompleted ? items : items.filter { !$0.isCompleted }
    }

    var pendingCount: Int {
        items.filter { !$0.isCompleted }.count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if filteredItems.isEmpty {
                    EmptyStateView(showCompleted: showCompleted)
                } else {
                    List {
                        ForEach(filteredItems) { item in
                            TaskRowView(item: item)
                                .onTapGesture {
                                    itemToEdit = item
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        delete(item)
                                    } label: {
                                        Label("Deletar", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        toggleComplete(item)
                                    } label: {
                                        Label(
                                            item.isCompleted ? "Reabrir" : "Concluir",
                                            systemImage: item.isCompleted
                                                ? "arrow.uturn.backward.circle"
                                                : "checkmark.circle"
                                        )
                                    }
                                    .tint(item.isCompleted ? .orange : .green)
                                }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .animation(.easeInOut, value: filteredItems.count)
                }
            }
            .navigationTitle(pendingCount > 0 ? "Tarefas (\(pendingCount))" : "Tarefas")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation { showCompleted.toggle() }
                    } label: {
                        Label(
                            showCompleted ? "Ocultar concluídas" : "Mostrar concluídas",
                            systemImage: showCompleted ? "eye.slash" : "eye"
                        )
                        .labelStyle(.iconOnly)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddEditTaskView(itemToEdit: nil)
            }
            .sheet(item: $itemToEdit) { item in
                AddEditTaskView(itemToEdit: item)
            }
        }
    }

    private func delete(_ item: TodoItem) {
        withAnimation {
            modelContext.delete(item)
        }
    }

    private func toggleComplete(_ item: TodoItem) {
        withAnimation {
            item.isCompleted.toggle()
        }
    }
}

// MARK: - Empty State

private struct EmptyStateView: View {
    let showCompleted: Bool

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: showCompleted ? "checkmark.circle.fill" : "tray")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            Text(showCompleted ? "Tudo feito!" : "Nenhuma tarefa pendente")
                .font(.title2.weight(.semibold))
            Text(showCompleted
                 ? "Adicione uma nova tarefa com o botão +."
                 : "Todas as tarefas estão concluídas. Toque no ícone de olho para vê-las.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
