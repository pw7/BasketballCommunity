class Essay {
  String code;
  String msg;
  int essay_id;
  String essay_title;
  String essay_cover;
  String essay_content;
  String essay_type;

  Essay(
      {this.code,
      this.msg,
      this.essay_id,
      this.essay_title,
      this.essay_cover,
      this.essay_content,
      this.essay_type});

  factory Essay.fromJson(Map<String, dynamic> json) {
    return Essay(
      code: json["code"],
      msg: json["msg"],
      essay_id: json["essay_id"],
      essay_title: json["essay_title"],
      essay_cover: json["essay_cover"],
      essay_content: json["essay_content"],
      essay_type: json["essay_type"],
    );
  }

  @override
  String toString() {
    return '{essay_id: $essay_id, essay_type: $essay_type, essay_cover: $essay_cover, essay_content: $essay_content, essay_title: $essay_title}';
  }
}
