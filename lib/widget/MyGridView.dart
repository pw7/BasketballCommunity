import 'package:flutter/material.dart';
import 'package:flutter_application/model/essay.dart';
import 'package:flutter_application/view/pages/basketball_essay/essay_detail_page.dart';

class MyGridView extends StatelessWidget {
  final List<Essay> essay;

  MyGridView(this.essay);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1.3),
        itemBuilder: (context, index) {
          return InkWell(
              child: Container(
                height: 100,
                padding: EdgeInsets.all(0),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            child: Image.network(
                              essay[index].essay_cover,
                              width: 110,
                              fit: BoxFit.cover,
                            ))),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          essay[index].essay_title,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        decoration: BoxDecoration(
                          color: Color(0x72000000),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                //print(essay[index].essay_content);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EssayDetailPage(
                        essay[index].essay_title, essay[index].essay_content)));
              });
        },
        itemCount: essay.length,
      ),
    );
  }
}
