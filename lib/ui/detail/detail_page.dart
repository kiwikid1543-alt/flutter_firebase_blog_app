import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/ui/write/write_page.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          iconButton(Icons.delete, () {
            print('삭제아이콘터치함');
          }),
          iconButton(Icons.edit, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return WritePage();
                },
              ),
            );
            print('편집아이콘터치함');
          }),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 500),
        children: [
          Image.network('https://picsum.photos/200/300', fit: BoxFit.cover),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today I learned',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 14),
                Text('김동준', style: TextStyle(fontSize: 16)),
                Text(
                  '2023.04.03',
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
                ),
                SizedBox(height: 14),
                Text('플러터의 그리드뷰를 배웠습니다.' * 10, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget iconButton(IconData icon, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.transparent,
        child: Icon(icon),
      ),
    );
  }
}
