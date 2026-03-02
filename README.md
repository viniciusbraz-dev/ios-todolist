# TodoList — iOS App

App de lista de tarefas nativo para iOS, desenvolvido com SwiftUI e SwiftData.

## Tecnologias

- **Swift 5.9+**
- **SwiftUI** — interface declarativa
- **SwiftData** — persistência de dados local (substituto moderno do Core Data)
- **iOS 17.0+**
- **Xcode 15+**

## Funcionalidades

- Adicionar, editar e deletar tarefas
- Marcar tarefas como concluídas
- Filtrar tarefas pendentes / concluídas
- Definir prioridade (Nenhuma, Baixa, Média, Alta)
- Adicionar notas a cada tarefa
- Swipe para deletar (esquerda) e concluir (direita)
- Tarefas pendentes aparecem primeiro na lista
- Contador de tarefas pendentes no título

## Estrutura do Projeto

```
App_ios_todolist/
├── TodoListApp.swift           # Entry point + configuração do SwiftData
├── Models/
│   └── TodoItem.swift          # Model com @Model macro + enum Priority
└── Views/
    ├── ContentView.swift       # Tela principal com lista e toolbar
    ├── TaskRowView.swift       # Componente de linha individual
    └── AddEditTaskView.swift   # Sheet de criação e edição de tarefas
```

## Como rodar

1. Clone o repositório
   ```bash
   git clone https://github.com/viniciusbraz-dev/ios-todolist.git
   ```

2. Abra o Xcode e crie um novo projeto:
   - **File > New > Project > iOS > App**
   - Product Name: `TodoList`
   - Interface: `SwiftUI` | Storage: `SwiftData` | Language: `Swift`

3. Delete o `Item.swift` gerado automaticamente pelo template

4. Adicione os arquivos do repositório ao projeto:
   - `TodoListApp.swift`
   - `Models/TodoItem.swift`
   - `Views/ContentView.swift`
   - `Views/TaskRowView.swift`
   - `Views/AddEditTaskView.swift`

5. Defina o Deployment Target para **iOS 17.0**

6. Selecione um simulador iPhone e pressione **⌘R**

## Arquitetura

O app segue um padrão simples e direto, aproveitando os recursos modernos do SwiftData:

- `@Model` — define a classe `TodoItem` como entidade persistida automaticamente
- `@Query` — busca e observa mudanças no banco em tempo real, sem boilerplate
- `@Bindable` — permite mutação direta de propriedades do model nas views
- `@Environment(\.modelContext)` — acesso ao contexto para inserir e deletar itens

## Desenvolvido por

Vinicius Braz
