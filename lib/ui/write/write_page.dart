import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/ui/write/write_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class WritePage extends ConsumerStatefulWidget {
  WritePage(this.post);
  Post? post;

  @override
  ConsumerState<WritePage> createState() => _WritePageState();
}

class _WritePageState extends ConsumerState<WritePage> {
  // 제목, 작성자, 내용
  late TextEditingController writeController = TextEditingController(
    text: widget.post?.writer ?? '',
  );
  late TextEditingController titleController = TextEditingController(
    text: widget.post?.title ?? '',
  );
  late TextEditingController contentController = TextEditingController(
    text: widget.post?.content ?? '',
  );

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    writeController.dispose();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.read(writeViewModelProvider(widget.post).notifier);
    final writeState = ref.watch(writeViewModelProvider(widget.post));
    if (writeState.isWriteing) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: () async {
                //
                print('완료 터치됨');
                final result = formKey.currentState?.validate() ?? false;
                if (result) {
                  final insertResult = await vm.insert(
                    writer: writeController.text,
                    title: titleController.text,
                    content: contentController.text,
                  );
                  if (insertResult) {
                    Navigator.pop(context);
                  }
                }
              },
              child: Container(
                width: 50,
                height: 50,
                color: Colors.transparent,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '완료',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              TextFormField(
                controller: writeController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(hintText: '작성자'),
                validator: (value) {
                  // trim : 문자열 앞뒤로 공백제거
                  if (value?.trim().isEmpty ?? true) {
                    return '작성자를 입력해주세요';
                  }
                  // 유효성 검사 성공
                  return null;
                },
              ),
              TextFormField(
                controller: titleController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(hintText: '제목'),
                validator: (value) {
                  // trim : 문자열 앞뒤로 공백제거
                  if (value?.trim().isEmpty ?? true) {
                    return '제목을 입력해주세요';
                  }
                  // 유효성 검사 성공
                  return null;
                },
              ),
              SizedBox(
                height: 200,
                child: TextFormField(
                  controller: contentController,
                  maxLines: null, // 반드시 null로 할당 (개행할 때)
                  expands: true, // 반드시 크기를 늘릴려면 설정해줘야 함
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(hintText: '내용'),
                  validator: (value) {
                    // trim : 문자열 앞뒤로 공백제거
                    if (value?.trim().isEmpty ?? true) {
                      return '내용을 입력해주세요';
                    }
                    // 유효성 검사 성공
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    // 1. 이미지 피커 객체 생성
                    ImagePicker imagepicker = ImagePicker();

                    // 2. 이미지 피커 객체의 pickImage라는 메서드 호출
                    XFile? xFile = await imagepicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    print('경로 : ${xFile?.path}');
                    if (xFile != null) {
                      vm.uploadImage(xFile);
                    }
                  },
                  child: writeState.imageUrl == null
                      ? Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey,
                          child: Icon(Icons.image),
                        )
                      : SizedBox(
                          height: 100,
                          child: Image.network(writeState.imageUrl!),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
