class News {
  int code; //状态编码
  String id; //新闻id
  String msg; //状态信息
  String ctime; //时间
  String title; //标题
  String description; //描述
  String source; //来源
  String picUrl; //封面图片
  String url; //url

  News(
      {this.code,
      this.id,
      this.msg,
      this.ctime,
      this.title,
      this.description,
      this.source,
      this.picUrl,
      this.url});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        code: json['code'],
        id: json['id'],
        msg: json['msg'],
        ctime: json['ctime'],
        title: json['title'],
        description: json['description'],
        source: json['source'],
        picUrl: json['picUrl'],
        url: json['url']);
  }
}
