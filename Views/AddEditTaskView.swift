import SwiftUI
import SwiftData

struct AddEditTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let itemToEdit: TodoItem?

    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var priority: Priority = .none

    private var isEditMode: Bool { itemToEdit != nil }
    private var isFormValid: Bool { !title.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section("Tarefa") {
                    TextField("Título", text: $title)

                    TextField("Notas (opcional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Prioridade") {
                    Picker("Prioridade", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { p in
                            Text(p.label).tag(p)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                if isEditMode {
                    Section("Status") {
                        Toggle(isOn: Binding(
                            get: { itemToEdit?.isCompleted ?? false },
                            set: { itemToEdit?.isCompleted = $0 }
                        )) {
                            Label(
                                itemToEdit?.isCompleted == true ? "Concluída" : "Pendente",
                                systemImage: itemToEdit?.isCompleted == true
                                    ? "checkmark.circle.fill"
                                    : "circle"
                            )
                        }
                        .tint(.green)
                    }
                }
            }
            .navigationTitle(isEditMode ? "Editar Tarefa" : "Nova Tarefa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditMode ? "Salvar" : "Adicionar") {
                        saveTask()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isFormValid)
                }
            }
            .onAppear {
                if let item = itemToEdit {
                    title = item.title
                    notes = item.notes
                    priority = item.priority
                }
            }
        }
    }

    private func saveTask() {
        guard isFormValid else { return }
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)

        if let item = itemToEdit {
            item.title = trimmedTitle
            item.notes = notes
            item.priority = priority
        } else {
            let newItem = TodoItem(title: trimmedTitle, notes: notes, priority: priority)
            modelContext.insert(newItem)
        }

        dismiss()
    }
}

#Preview("Adicionar") {
    AddEditTaskView(itemToEdit: nil)
        .modelContainer(for: TodoItem.self, inMemory: true)
}

#Preview("Editar") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TodoItem.self, configurations: config)
    let item = TodoItem(title: "Ler um livro", notes: "Começar pelo capítulo 3", priority: .low)
    container.mainContext.insert(item)
    return AddEditTaskView(itemToEdit: item)
        .modelContainer(container)
}
