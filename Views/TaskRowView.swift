import SwiftUI
import SwiftData

struct TaskRowView: View {
    @Bindable var item: TodoItem

    var body: some View {
        HStack(spacing: 14) {
            // Priority color strip
            if item.priority != .none {
                RoundedRectangle(cornerRadius: 3)
                    .fill(item.priority.color)
                    .frame(width: 4, height: 36)
            }

            // Checkbox
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    item.isCompleted.toggle()
                }
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(item.isCompleted ? .green : .secondary)
                    .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.plain)

            // Title + notes
            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .font(.body)
                    .strikethrough(item.isCompleted, color: .secondary)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)
                    .animation(.easeInOut, value: item.isCompleted)

                if !item.notes.isEmpty {
                    Text(item.notes)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
            }

            Spacer()

            // Date
            Text(item.createdAt, style: .date)
                .font(.caption2)
                .foregroundStyle(.quaternary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TodoItem.self, configurations: config)
    let item = TodoItem(title: "Comprar mantimentos", notes: "Leite, ovos, pão", priority: .medium)
    container.mainContext.insert(item)
    return TaskRowView(item: item)
        .modelContainer(container)
        .padding()
}
