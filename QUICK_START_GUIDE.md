# 🧭 Guia Rápido de Teste & Execução Integrada

Este guia foi criado para auxiliar na inicialização rápida do ecossistema completo: **API Backend + Aplicativo Mobile Flutter**.

---

## ⚡ Passo 1: Iniciar a API Backend

Em um terminal:

```bash
# 1. Navegue até a pasta da API
cd School-manager-api

# 2. Certifique-se de que as dependências estão instaladas
npm install

# 3. Certifique-se de que o arquivo .env existe com as variáveis necessárias:
# PORT=3000
# DATABASE_URL=...
# JWT_SECRET=...

# 4. Inicie o servidor
npm start
```

O servidor informará que está escutando na porta `3000` (ex: `http://localhost:3000`).

---

## 📱 Passo 2: Executar o App Mobile

Abra um **segundo terminal**:

```bash
# 1. Navegue até a pasta do app
cd school_manager_mobile

# 2. Obtenha os pacotes
flutter pub get

# 3. Inicie o app
flutter run
```

---

## 🧪 Passo 3: Roteiro Rápido de Teste dos Dois Perfis

### 🔹 Testando o Perfil de Professor:
1. Na tela de login, clique em **"Cadastre-se"**.
2. Selecione a opção **"Professor"**.
3. Cadastre um novo professor (Ex: `prof.ana@escola.com` / `senha123`).
4. Faça login com essa conta.
5. Na aba **Turmas**, clique em **"+"** e crie a turma `"Turma 301 - Matemática"`.
6. Na turma criada, clique em **"Nova Atividade nesta Turma"** e publique:
   - Título: `"Lista de Exercícios 01"`
   - Descrição: `"Resolver questões da página 15"`
   - Data de Entrega: mantenha a data sugerida ou informe uma data futura.

---

### 🔹 Testando o Perfil de Estudante:
1. Faça logout no menu **Perfil** > **"Sair da Conta"**.
2. Na tela de login, selecione **"Cadastre-se"** > **"Estudante"**.
3. Crie um aluno (Ex: `lucas.aluno@escola.com` / `senha123`).
4. Faça login como estudante.
5. Na aba **Atividades**, veja as tarefas disponíveis.
6. Clique no botão verde de **"Entregar"** (ícone de upload). A atividade mudará de status para `"Entregue"`.

---

### 🔹 Corrigindo e Atribuindo Nota (Professor):
1. Faça logout e entre novamente com a conta do **Professor**.
2. Vá até a aba **"Correções"** (ou pelo Dashboard em "Entregas para Avaliar").
3. Localize a submissão do aluno e clique em **"Avaliar e Lançar Nota"**.
4. Digite a nota (Ex: `9.5`) e escreva o feedback: `"Excelente dedicação!"`.
5. Salve a avaliação.

---

### 🔹 Conferindo o Boletim (Estudante):
1. Entre novamente com a conta do **Estudante**.
2. Vá até a aba **"Boletim"**.
3. A nota `9.5` estará visível junto ao status `"Avaliado"` e ao feedback recebido do professor!
4. Na aba **"Início (Dashboard)"**, a média geral do aluno será recalculada automaticamente.

---

## 🔧 Solução de Problemas Comuns

| Sintoma | Causa Comum | Solução |
|---|---|---|
| *Não foi possível conectar ao servidor (http://...)* | O emulador ou celular físico não alcança o IP configurado. | No topo da tela de login, clique no ícone de **engrenagem**. No emulador Android utilize `http://10.0.2.2:3000`. Em dispositivo físico, informe o IP da sua máquina na rede Wi-Fi (ex: `http://192.168.1.100:3000`). |
| *Invalid email or password* | Usuário não cadastrado ou papel incorreto selecionado. | Verifique se selecionou o botão correto (**Estudante** ou **Professor**) no seletor da tela de login. |

