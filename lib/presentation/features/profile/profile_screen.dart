import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/user_entity.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../auth/server_config_dialog.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const ProfileScreen({super.key, required this.onLogout});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserEntity? _user;
  bool _isLoading = true;
  String? _errorMessage;

  final _nameFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isSavingName = false;
  bool _isSavingPassword = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = ServiceLocator.sessionStorage.getUserId();
      final role = ServiceLocator.sessionStorage.getUserRole();
      if (userId == null) {
        throw Exception('Sessão não encontrada');
      }

      final profile = await ServiceLocator.profileRepository.getProfile(
        userId,
        role: role,
      );
      setState(() {
        _user = profile;
        _nameController.text = profile.name;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _updateName() async {
    if (!(_nameFormKey.currentState?.validate() ?? false)) return;
    if (_user == null) return;

    setState(() => _isSavingName = true);
    try {
      if (_user!.isStudent) {
        await ServiceLocator.profileRepository.updateStudentName(
          _user!.id,
          _nameController.text.trim(),
        );
      } else {
        // Professores
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Edição de perfil para professores não suportada na API',
            ),
          ),
        );
        setState(() => _isSavingName = false);
        return;
      }

      await _loadUserProfile();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nome atualizado com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar nome: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSavingName = false);
    }
  }

  Future<void> _updatePassword() async {
    if (!(_passwordFormKey.currentState?.validate() ?? false)) return;
    if (_user == null) return;

    setState(() => _isSavingPassword = true);
    try {
      if (_user!.isStudent) {
        await ServiceLocator.profileRepository.updateStudentPassword(
          _user!.id,
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Alteração de senha para professores não suportada na API',
            ),
          ),
        );
        setState(() => _isSavingPassword = false);
        return;
      }

      _currentPasswordController.clear();
      _newPasswordController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha alterada com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao alterar senha: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSavingPassword = false);
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Logout'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onLogout();
            },
            child: const Text('Sair', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meu Perfil')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!,
                style: const TextStyle(color: AppColors.error),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadUserProfile,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final user = _user!;
    final roleName = user.isTeacher ? 'Professor' : 'Estudante';
    final roleColor = user.isTeacher ? AppColors.secondary : AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Configurações de Servidor',
            onPressed: () => ServerConfigDialog.show(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Cabeçalho do Avatar
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: roleColor.withValues(alpha: 0.15),
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: roleColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.displayName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(
                      roleName,
                      style: TextStyle(
                        color: roleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: roleColor.withValues(alpha: 0.1),
                    side: BorderSide(color: roleColor.withValues(alpha: 0.2)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Card de Edição de Nome
            if (user.isStudent) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _nameFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Alterar Nome',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          controller: _nameController,
                          label: 'Primeiro Nome',
                          validator: (val) {
                            if (val == null || val.trim().length < 3) {
                              return 'O nome deve ter no mínimo 3 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'Salvar Nome',
                          isLoading: _isSavingName,
                          onPressed: _updateName,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Card de Alterar Senha
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _passwordFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Alterar Senha',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          controller: _currentPasswordController,
                          label: 'Senha Atual',
                          isPassword: true,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Informe sua senha atual';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          controller: _newPasswordController,
                          label: 'Nova Senha',
                          isPassword: true,
                          validator: (val) {
                            if (val == null || val.length < 6) {
                              return 'A nova senha deve ter no mínimo 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'Atualizar Senha',
                          isLoading: _isSavingPassword,
                          onPressed: _updatePassword,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Botão de Logout
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: const Text(
                'Sair da Conta',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              onPressed: _confirmLogout,
            ),
          ],
        ),
      ),
    );
  }
}
