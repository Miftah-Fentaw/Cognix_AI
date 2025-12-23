import 'package:flutter/material.dart';

class InputBar extends StatefulWidget {
  final Function(String) onSend;

  const InputBar({super.key, required this.onSend});

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File upload coming soon')),
                );
              },
            ),
            Expanded(
              child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: 5000,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[900],
                    height: 1.4,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Paste your notes or ask anything...',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                    counterText: '',
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              
          
            ),
      
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                widget.onSend(controller.text);
                controller.clear();
              },
            ),
            ]
      ) 
        )
    );
  }
}
