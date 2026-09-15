import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'auth_view_model.dart';

class RegisterScreen extends StatefulWidget {
  final AuthViewModel authViewModel;
  final VoidCallback onRegisterSuccess;

  const RegisterScreen({
    super.key,
    required this.authViewModel,
    required this.onRegisterSuccess,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await widget.authViewModel.register(
        name: _nameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (success && mounted) {
        widget.onRegisterSuccess();
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Junte-se ao School Manager',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Preencha seus dados para criar seu acesso',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 24),

                // Seletor de Perfil
                ListenableBuilder(
                  listenable: widget.authViewModel,
                  builder: (context, _) {
                    final selected = widget.authViewModel.selectedRole;
                    return SegmentedButton<String>(
                      segments: const [
                        ButtonSegment<String>(
                          value: 'student',
                          label: Text('Sou Estudante'),
                          icon: Icon(Icons.person_outline_rounded),
                        ),
                        ButtonSegment<String>(
                          value: 'teacher',
                          label: Text('Sou Professor'),
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
                const SizedBox(height: 20),

                // Erro se houver
                ListenableBuilder(
                  listenable: widget.authViewModel,
                  builder: (context, _) {
                    if (widget.authViewModel.errorMessage == null) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
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

                // Nome e Sobrenome
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _nameController,
                        label: 'Nome',
                        hint: 'João',
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (val) {
                          if (val == null || val.trim().length < 3) {
                            return 'Mínimo de 3 letras';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: _lastNameController,
                        label: 'Sobrenome',
                        hint: 'Silva',
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Obrigatório';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Email
                CustomTextField(
                  controller: _emailController,
                  label: 'E-mail institucional ou pessoal',
                  hint: 'joao.silva@exemplo.com',
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

                // Senha
                CustomTextField(
                  controller: _passwordController,
                  label: 'Senha',
                  hint: 'Mínimo 6 caracteres',
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  validator: (val) {
                    if (val == null || val.trim().length < 6) {
                      return 'A senha deve ter no mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirmar Senha
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirmar Senha',
                  hint: 'Repita sua senha',
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  validator: (val) {
                    if (val != _passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Botão de Cadastro
                ListenableBuilder(
                  listenable: widget.authViewModel,
                  builder: (context, _) {
                    return CustomButton(
                      text: 'Criar Minha Conta',
                      isLoading: widget.authViewModel.isLoading,
                      onPressed: _submit,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
