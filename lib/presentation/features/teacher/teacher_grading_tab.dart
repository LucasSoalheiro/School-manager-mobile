import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/grade_entity.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/empty_state.dart';
import '../teacher/teacher_view_model.dart';

class TeacherGradingTab extends StatefulWidget {
  final TeacherViewModel viewModel;

  const TeacherGradingTab({super.key, required this.viewModel});

  @override
  State<TeacherGradingTab> createState() => _TeacherGradingTabState();
}

class _TeacherGradingTabState extends State<TeacherGradingTab> {
  void _openGradingModal(GradeEntity grade) {
    final scoreController = TextEditingController();
    final feedbackController = TextEditingController();
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
                      'Avaliar Submissão',
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
                const SizedBox(height: 8),
                Text(
                  'Aluno: ${grade.studentId}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: scoreController,
                  label: 'Nota (0 a 10)',
                  hint: 'Ex: 9.5',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Informe a nota';
                    }
                    final num = double.tryParse(val.trim());
                    if (num == null || num < 0 || num > 10) {
                      return 'A nota deve ser um valor entre 0 e 10';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: feedbackController,
                  label: 'Feedback do Professor',
                  hint: 'Comentários sobre a resolução...',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Informe um feedback ao aluno';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Salvar Avaliação',
                  isLoading: isSubmitting,
                  onPressed: () async {
                    if (!(formKey.currentState?.validate() ?? false)) return;
                    setModalState(() => isSubmitting = true);
                    final score = double.parse(scoreController.text.trim());
                    final success = await widget.viewModel.submitGrade(
                      grade.id,
                      score,
                      feedbackController.text.trim(),
                    );
                    if (context.mounted) {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Nota lançada com sucesso!'
                                : 'Erro ao lançar nota: ${widget.viewModel.errorMessage}',
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
    if (widget.viewModel.isLoading && widget.viewModel.pendingGrades.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Correções Pendentes')),
      body: RefreshIndicator(
        onRefresh: widget.viewModel.loadData,
        child: widget.viewModel.pendingGrades.isEmpty
            ? Center(
                child: EmptyState(
                  icon: Icons.done_all_rounded,
                  title: 'Nenhuma submissão para corrigir',
                  message: 'Quando os alunos entregarem suas atividades, elas aparecerão aqui para você lançar a nota e o feedback.',
                  buttonText: 'Atualizar Lista',
                  onButtonPressed: widget.viewModel.loadData,
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.viewModel.pendingGrades.length,
                itemBuilder: (context, index) {
                  final grade = widget.viewModel.pendingGrades[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.assignment_turned_in_outlined,
                                  color: AppColors.warning,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Submissão #${grade.id.length > 8 ? grade.id.substring(0, 8) : grade.id}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      'ID do Aluno: ${grade.studentId}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Aguardando',
                                  style: TextStyle(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          CustomButton(
                            text: 'Avaliar e Lançar Nota',
                            onPressed: () => _openGradingModal(grade),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
