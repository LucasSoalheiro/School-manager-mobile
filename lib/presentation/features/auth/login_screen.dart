import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'auth_view_model.dart';
import 'register_screen.dart';
import 'server_config_dialog.dart';

class LoginScreen extends StatefulWidget {
  final AuthViewModel authViewModel;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.authViewModel,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await widget.authViewModel.login(
        _emailController.text,
        _passwordController.text,
      );
      if (success && mounted) {
        widget.onLoginSuccess();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Configurar URL da API',
            onPressed: () => ServerConfigDialog.show(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / Ícone
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        size: 42,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Título e Subtítulo
                  Text(
                    'School Manager',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Acesse seu portal acadêmico',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Seletor de Perfil (Estudante ou Professor)
                  ListenableBuilder(
                    listenable: widget.authViewModel,
                    builder: (context, _) {
                      final selected = widget.authViewModel.selectedRole;
                      return SegmentedButton<String>(
                        segments: const [
                          ButtonSegment<String>(
                            value: 'student',
                            label: Text('Estudante'),
                            icon: Icon(Icons.person_outline_rounded),
                          ),
                          ButtonSegment<String>(
                            value: 'teacher',
                            label: Text('Professor'),
                            icon: Icon(Icons.cast_for_education_rounded),
                          ),
                        ],
                        selected: {selected},
                        onSelectionChanged: (Set<String> newSelection) {
                          widget.authViewModel.setSelectedRole(newSelection.first);
                        },
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Mensagem de Erro
                  ListenableBuilder(
                    listenable: widget.authViewModel,
                    builder: (context, _) {
                      if (widget.authViewModel.errorMessage == null) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.authViewModel.errorMessage!,
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Campo de Email
                  CustomTextField(
                    controller: _emailController,
                    label: 'E-mail',
                    hint: 'seu.email@exemplo.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Informe seu e-mail';
                      }
                      if (!val.contains('@') || !val.contains('.')) {
                        return 'Informe um e-mail válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo de Senha
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Senha',
                    hint: 'Sua senha de acesso',
                    prefixIcon: Icons.lock_outline_rounded,
                    isPassword: true,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Informe sua senha';
                      }
                      if (val.length < 6) {
                        return 'A senha deve conter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Botão de Login
                  ListenableBuilder(
                    listenable: widget.authViewModel,
                    builder: (context, _) {
                      return CustomButton(
                        text: widget.authViewModel.selectedRole == 'student'
                            ? 'Entrar como Estudante'
                            : 'Entrar como Professor',
                        isLoading: widget.authViewModel.isLoading,
                        onPressed: _submit,
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Cadastro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não possui uma conta? ',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.authViewModel.clearError();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(
                                authViewModel: widget.authViewModel,
                                onRegisterSuccess: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Conta criada com sucesso! Faça login para continuar.'),
                                      backgroundColor: AppColors.success,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Cadastre-se',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
