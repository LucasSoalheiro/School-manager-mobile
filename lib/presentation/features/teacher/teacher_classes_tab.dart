import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/school_class_entity.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/empty_state.dart';
import '../teacher/teacher_view_model.dart';

class TeacherClassesTab extends StatefulWidget {
  final TeacherViewModel viewModel;

  const TeacherClassesTab({super.key, required this.viewModel});

  @override
  State<TeacherClassesTab> createState() => _TeacherClassesTabState();
}

class _TeacherClassesTabState extends State<TeacherClassesTab> {
  void _openCreateClassModal() {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Criar Nova Turma',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: nameController,
                  label: 'Nome da Turma',
                  hint: 'Ex: Turma 101 - Informática',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Informe o nome da turma';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Criar Turma',
                  isLoading: isSubmitting,
                  onPressed: () async {
                    if (!(formKey.currentState?.validate() ?? false)) return;
                    setModalState(() => isSubmitting = true);
                    final success = await widget.viewModel.createClass(
                      nameController.text.trim(),
                    );
                    if (context.mounted) {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Turma criada com sucesso!'
                                : 'Erro ao criar turma: ${widget.viewModel.errorMessage}',
                          ),
                          backgroundColor: success
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openCreateActivityModal(SchoolClassEntity schoolClass) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final deliveryDateController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isSubmitting = false;

    // Data padrão para daqui a 7 dias
    final defaultDate = DateTime.now().add(const Duration(days: 7));
    deliveryDateController.text = defaultDate.toUtc().toIso8601String();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Nova Atividade - ${schoolClass.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: titleController,
                  label: 'Título',
                  hint: 'Ex: Trabalho Bimestral',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Informe o título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: descriptionController,
                  label: 'Descrição',
                  hint: 'Instruções da atividade...',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Informe as instruções';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: deliveryDateController,
                  label: 'Data de Entrega (ISO UTC)',
                  hint: 'YYYY-MM-DDTHH:MM:SS.000Z',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Informe a data de entrega';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Publicar Atividade',
                  isLoading: isSubmitting,
                  onPressed: () async {
                    if (!(formKey.currentState?.validate() ?? false)) return;
                    setModalState(() => isSubmitting = true);
                    final success = await widget.viewModel.createActivity(
                      schoolClass.id,
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      deliveryDate: deliveryDateController.text.trim(),
                    );
                    if (context.mounted) {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Atividade criada com sucesso!'
                                : 'Erro ao criar atividade: ${widget.viewModel.errorMessage}',
                          ),
                          backgroundColor: success
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.viewModel.isLoading && widget.viewModel.classes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Turmas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Criar Turma',
            onPressed: _openCreateClassModal,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: widget.viewModel.loadData,
        child: widget.viewModel.classes.isEmpty
            ? Center(
                child: EmptyState(
                  icon: Icons.meeting_room_outlined,
                  title: 'Nenhuma turma encontrada',
                  message: 'Crie uma nova turma clicando no botão abaixo ou no cabeçalho.',
                  buttonText: 'Criar Turma',
                  onButtonPressed: _openCreateClassModal,
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.viewModel.classes.length,
                itemBuilder: (context, index) {
                  final schoolClass = widget.viewModel.classes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.class_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        schoolClass.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        '${schoolClass.students.length} alunos • ${schoolClass.activities.length} atividades',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          fontSize: 13,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.add_task_rounded,
                                  size: 18,
                                ),
                                label: const Text('Nova Atividade nesta Turma'),
                                onPressed: () =>
                                    _openCreateActivityModal(schoolClass),
                              ),
                              const SizedBox(height: 10),
                              if (schoolClass.activities.isNotEmpty) ...[
                                const Text(
                                  'Atividades:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                ...schoolClass.activities.map(
                                  (a) => ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(
                                      Icons.description_outlined,
                                      size: 20,
                                    ),
                                    title: Text(a.title),
                                    subtitle: Text(
                                      a.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
