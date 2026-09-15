# 📱 School Manager Mobile

Um aplicativo mobile moderno, intuitivo e completo para gestão acadêmica escolar, desenvolvido com **Flutter** utilizando **Clean Architecture** e consumo de API REST.

O app atende a dois perfis principais de usuários: **Estudantes** e **Professores**, oferecendo uma experiência visual fluida com suporte nativo a **Light e Dark Theme**, componentes visuais no padrão Material Design 3, microinterações e validações em tempo real.

---

## 📑 Sumário

- [Visão Geral e Funcionalidades](#-visão-geral-e-funcionalidades)
- [Arquitetura do Projeto (Clean Architecture)](#-arquitetura-do-projeto-clean-architecture)
- [Tecnologias e Dependências](#-tecnologias-e-dependências)
- [Configuração do Ambiente e API](#-configuração-do-ambiente-e-api)
- [Instalação e Execução](#-instalação-e-execução)
- [Guia de Uso Passo a Passo](#-guia-de-uso-passo-a-passo)
  - [1. Autenticação e Alternância de Perfis](#1-autenticação-e-alternância-de-perfis)
  - [2. Fluxo do Estudante](#2-fluxo-do-estudante)
  - [3. Fluxo do Professor](#3-fluxo-do-professor)
  - [4. Configuração Dinâmica de URL da API](#4-configuração-dinâmica-de-url-da-api)
  - [5. Gerenciamento de Perfil e Logout](#5-gerenciamento-de-perfil-e-logout)
- [Estrutura de Pastas](#-estrutura-de-pastas)
- [Testes e Análise Estática](#-testes-e-análise-estática)

---

## 🌟 Visão Geral e Funcionalidades

### 🎓 Para Estudantes:
- **Painel Geral (Dashboard):** Indicadores de turmas ativas, atividades pendentes e média geral calculada das avaliações recebidas.
- **Minhas Turmas:** Visualização das turmas em que o aluno está matriculado, com contagem de colegas e atividades.
- **Atividades & Prazos:** Listagem com identificação de status (*Pendente*, *Entregue*, *Avaliado*) e badges de prazo relativo (ex: "Faltam 3 dias", "Prazo expirado").
- **Entrega de Atividades:** Ação direta em um clique para submeter tarefas e mudar o status de `pending` para `submitted`.
- **Boletim Acadêmico:** Histórico de notas e avaliações agrupado por turma, com data de submissão e notas detalhadas.
- **Perfil do Aluno:** Edição do primeiro nome e alteração de senha de acesso com validação da senha atual.

### 👩‍🏫 Para Professores:
- **Painel Geral (Dashboard):** Resumo do total de turmas gerenciadas, total de alunos matriculados e contagem de submissões pendentes de nota.
- **Gestão de Turmas:**
  - Criação rápida de novas turmas através de modal interativo.
  - Visualização expansível com lista de atividades cadastradas.
  - Criação e publicação de novas atividades vinculadas à turma com título, descrição e data de entrega.
- **Central de Correções & Notas:**
  - Identificação de submissões enviadas pelos alunos que estão aguardando correção.
  - Modal de avaliação para atribuição de nota (0 a 10) e feedback pedagógico textual.
- **Perfil do Docente:** Dados da conta, identificação visual e encerramento de sessão.

---

## 🏛️ Arquitetura do Projeto (Clean Architecture)

O projeto segue estritamente a **Clean Architecture**, promovendo desacoplamento, testabilidade e escalabilidade:

```text
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│      (Screens, Tabs, ViewModels/ChangeNotifier, UI)     │
└───────────────────────────▲────────────────────────────┘
                            │
┌───────────────────────────┴────────────────────────────┐
│                      Domain Layer                      │
│        (Entities, Value Objects, Repository Contracts) │
└───────────────────────────▲────────────────────────────┘
                            │
┌───────────────────────────┴────────────────────────────┐
│                       Data Layer                       │
│    (Models/JSON serialization, Repository Impl, API)   │
└───────────────────────────▲────────────────────────────┘
                            │
┌───────────────────────────┴────────────────────────────┐
│                       Core Layer                       │
│   (Service Locator/DI, HTTP Client, Storage, Themes)   │
└────────────────────────────────────────────────────────┘
```

- **Core:** Infraestrutura base, incluindo injeção de dependência simples (`ServiceLocator`), cliente HTTP (`ApiClient`), persistência local criptografada em sessão (`SessionStorage`) e tokens de design (`AppTheme`, `AppColors`).
- **Domain:** A camada central de regras de negócio independente de frameworks. Contém entidades puras (`UserEntity`, `GradeEntity`, `SchoolClassEntity`, `ActivityEntity`) e contratos de repositórios.
- **Data:** Responsável por converter modelos de dados da API REST (`UserModel`, `GradeModel`, etc.) em entidades de domínio e orquestrar as requisições HTTP através do `RemoteDataSource`.
- **Presentation:** Camada visual em Flutter utilizando `ChangeNotifier` e `ListenableBuilder` para gerenciamento de estado reativo, desacoplado das regras de negócio.

---

## 🛠️ Tecnologias e Dependências

- **Flutter SDK:** >= 3.47.0 (compatível com Dart 3.x)
- **Material 3:** Design moderno, tipografia hierárquica e paleta de cores consistente
- **http:** Comunicação com a API REST
- **shared_preferences:** Armazenamento seguro de token JWT, dados do usuário logado e URL customizada
- **intl:** Formatação e localização de datas e prazos

---

## 🌐 Configuração do Ambiente e API

Por padrão, a aplicação conecta automaticamente dependendo do dispositivo:

| Ambiente | Host Padrão | Descrição |
|---|---|---|
| **Web / Desktop / iOS Simulator** | `http://localhost:3000` | Acesso local na mesma máquina |
| **Android Emulator** | `http://10.0.2.2:3000` | Loopback nativo do emulador Android para o host |
| **Dispositivo Físico (USB/Wi-Fi)** | `http://SEU_IP_LOCAL:3000` | Configurável diretamente pela interface do app |

> 💡 **Dica:** Caso utilize um celular físico ou queira alterar o IP do backend sem recompilar o app, clique no ícone de **engrenagem (Configurar Servidor)** no canto superior da tela de login ou na tela de perfil.

---

## 🚀 Instalação e Execução

### 1. Pré-requisitos
Certifique-se de ter o Flutter instalado e configurado no PATH:
```bash
flutter doctor
```

Certifique-se também de que o backend **School-manager-api** está em execução:
```bash
cd ../School-manager-api
npm start
```

### 2. Baixar dependências do app
Dentro do diretório `school_manager_mobile`:
```bash
flutter pub get
```

### 3. Executar o aplicativo
Para listar os dispositivos disponíveis:
```bash
flutter devices
```

Para rodar no dispositivo ou emulador desejado:
```bash
# Executar no dispositivo conectado ou padrão
flutter run

# Ou especificar a plataforma:
flutter run -d chrome       # Para Web
flutter run -d edge         # Para Desktop Windows / Web
flutter run -d <device-id>  # Para Android ou iOS
```

---

## 📖 Guia de Uso Passo a Passo

### 1. Autenticação e Alternância de Perfis
1. Abra o aplicativo.
2. Na tela inicial de **Login**, escolha o perfil desejado no seletor:
   - **Estudante**
   - **Professor**
3. Preencha seu **E-mail** e **Senha** cadastrados na API.
4. Caso ainda não possua conta:
   - Clique em **"Cadastre-se"**.
   - Escolha o tipo de conta (Estudante ou Professor).
   - Preencha Nome, Sobrenome, E-mail e Senha (mínimo de 6 caracteres).
   - Após o cadastro, o app retornará para a tela de login.

---

### 2. Fluxo do Estudante
Ao realizar login como estudante, a barra de navegação inferior apresentará:

1. **Início (Dashboard):**
   - Visualize o cartão com o total de turmas matriculadas.
   - Veja quantas atividades estão pendentes de entrega.
   - Acompanhe a média aritmética das avaliações que já foram corrigidas.
   - Acesse rapidamente a lista de atividades mais urgentes.
2. **Turmas:**
   - Visualize todas as turmas em que você está inscrito.
   - Veja o número de colegas e atividades cadastradas.
3. **Atividades:**
   - Acompanhe a lista de tarefas.
   - Atividades pendentes possuem um botão verde **"Entregar"** (ícone de upload). Ao clicar, a atividade é enviada para correção do professor.
4. **Boletim:**
   - Visualize suas notas organizadas por turma em painéis expansíveis.
   - Confira o feedback emitido pelo professor para cada trabalho.
5. **Perfil:**
   - Altere seu nome ou atualize sua senha quando desejar.

---

### 3. Fluxo do Professor
Ao realizar login como professor, a interface se adapta para o modo docente:

1. **Início (Dashboard):**
   - Acompanhe o número de turmas sob sua responsabilidade.
   - Verifique se há entregas de alunos esperando por nota.
   - Monitore o total de alunos atendidos.
2. **Turmas:**
   - Veja suas turmas cadastradas.
   - Clique em **"+" (Criar Turma)** no topo direito para registrar uma nova turma.
   - Dentro de cada turma, use o botão **"Nova Atividade nesta Turma"** para lançar uma tarefa definindo título, instruções e data de entrega.
3. **Correções:**
   - Acesse a fila de submissões pendentes.
   - Clique em **"Avaliar e Lançar Nota"**.
   - Digite a nota de **0 a 10** e redija um **feedback** construtivo.
   - Ao salvar, a nota é imediatamente lançada e o boletim do aluno é atualizado.
4. **Perfil:**
   - Visualize suas credenciais e gerencie a conexão com o servidor.

---

### 4. Configuração Dinâmica de URL da API
Caso precise testar com uma API rodando na nuvem ou em outro IP da rede local:
1. Clique no ícone de **engrenagem** no AppBar (disponível no Login e no Perfil).
2. Digite a URL (exemplo: `http://192.168.1.15:3000`).
3. Clique em **"Salvar"**. A alteração é salva localmente e aplicada em todas as requisições imediatas.

---

### 5. Gerenciamento de Perfil e Logout
1. Na aba **Perfil**, clique no botão **"Sair da Conta"**.
2. Confirme na caixa de diálogo.
3. A sessão local (token JWT e cache de usuário) será apagada com segurança e você retornará à tela de Login.

---

## 📂 Estrutura de Pastas

```text
school_manager_mobile/
├── lib/
│   ├── main.dart                                # Inicialização e Roteamento de Sessão
│   ├── core/
│   │   ├── constants/
│   │   │   └── api_constants.dart               # Endpoints REST e hosts padrão
│   │   ├── di/
│   │   │   └── service_locator.dart             # Injeção de dependências
│   │   ├── network/
│   │   │   └── api_client.dart                  # Cliente HTTP e tratamento de exceções
│   │   ├── storage/
│   │   │   └── session_storage.dart             # Gerenciamento de SharedPreferences
│   │   ├── theme/
│   │   │   └── app_theme.dart                   # Paleta, fontes e temas Light/Dark
│   │   └── utils/
│   │       └── date_formatter.dart              # Formatador de datas e prazos relativos
│   ├── domain/
│   │   ├── entities/                            # Entidades do Domínio
│   │   │   ├── activity_entity.dart
│   │   │   ├── enrollment_entity.dart
│   │   │   ├── grade_entity.dart
│   │   │   ├── school_class_entity.dart
│   │   │   └── user_entity.dart
│   │   └── repositories/                        # Contratos / Interfaces
│   │       ├── activity_repository.dart
│   │       ├── auth_repository.dart
│   │       ├── grade_repository.dart
│   │       ├── profile_repository.dart
│   │       └── school_class_repository.dart
│   ├── data/
│   │   ├── datasources/
│   │   │   └── remote_data_source.dart          # Integração HTTP com a API
│   │   ├── models/                              # Deserialização e serialização JSON
│   │   │   ├── activity_model.dart
│   │   │   ├── enrollment_model.dart
│   │   │   ├── grade_model.dart
│   │   │   ├── school_class_model.dart
│   │   │   └── user_model.dart
│   │   └── repositories/                        # Implementações dos repositórios
│   │       ├── activity_repository_impl.dart
│   │       ├── auth_repository_impl.dart
│   │       ├── grade_repository_impl.dart
│   │       ├── profile_repository_impl.dart
│   │       └── school_class_repository_impl.dart
│   └── presentation/
│       ├── core/widgets/                        # Componentes UI reutilizáveis
│       │   ├── custom_button.dart
│       │   ├── custom_text_field.dart
│       │   ├── empty_state.dart
│       │   ├── stat_card.dart
│       │   └── status_badge.dart
│       └── features/
│           ├── auth/                            # Telas de Login e Registro
│           │   ├── auth_view_model.dart
│           │   ├── login_screen.dart
│           │   ├── register_screen.dart
│           │   └── server_config_dialog.dart
│           ├── student/                         # Portal do Estudante
│           │   ├── student_activities_tab.dart
│           │   ├── student_classes_tab.dart
│           │   ├── student_dashboard_tab.dart
│           │   ├── student_grades_tab.dart
│           │   ├── student_home_screen.dart
│           │   └── student_view_model.dart
│           ├── teacher/                         # Portal do Professor
│           │   ├── teacher_classes_tab.dart
│           │   ├── teacher_dashboard_tab.dart
│           │   ├── teacher_grading_tab.dart
│           │   ├── teacher_home_screen.dart
│           │   └── teacher_view_model.dart
│           └── profile/                         # Perfil e Configurações
│               └── profile_screen.dart
└── test/
    └── widget_test.dart                         # Testes unitários das entidades de domínio
```

---

## 🧪 Testes e Análise Estática

O projeto mantém **0 warnings e 0 erros** no linter estático do Flutter e conta com suíte de testes automatizados.

### Executar Análise de Código:
```bash
flutter analyze
```
*Resultado esperado: `No issues found!`*

### Executar Testes Automatizados:
```bash
flutter test
```
*Resultado esperado: `All tests passed!`*
