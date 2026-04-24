import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product.dart';
import '../../state/provider/product_provider.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  bool _isSaving = false;

  bool get _isEditMode => widget.product != null;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.product?.title ?? '');
    _priceController = TextEditingController(
        text: widget.product != null
            ? widget.product!.price.toString()
            : '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _categoryController =
        TextEditingController(text: widget.product?.category ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final provider = context.read<ProductProvider>();
    final price = double.parse(_priceController.text.trim());

    if (_isEditMode) {
      await provider.updateProduct(widget.product!.copyWith(
        title: _titleController.text.trim(),
        price: price,
        description: _descriptionController.text.trim(),
        category: _categoryController.text.trim(),
      ));
    } else {
      await provider.addProduct(Product(
        id: 0,
        title: _titleController.text.trim(),
        price: price,
        description: _descriptionController.text.trim(),
        category: _categoryController.text.trim(),
        image: '',
      ));
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Editar Produto' : 'Novo Produto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField(
                controller: _titleController,
                label: 'Nome do produto',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _priceController,
                label: 'Preço',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o preço';
                  final parsed = double.tryParse(v.trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Informe um preço válido maior que zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _categoryController,
                label: 'Categoria',
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Informe a categoria'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _descriptionController,
                label: 'Descrição',
                maxLines: 4,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Informe a descrição'
                    : null,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _isSaving ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _isEditMode ? 'Salvar alterações' : 'Adicionar',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: const Color(0xFF0D2137).withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF5A7080)),
      ),
    );
  }
}
