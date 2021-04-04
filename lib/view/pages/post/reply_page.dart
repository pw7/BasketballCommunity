import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/list_repository/reply_repository.dart';
import 'package:flutter_application/model/comment.dart';
import 'package:flutter_application/model/reply.dart';
import 'package:flutter_application/widget/ItemBuilder.dart';
import 'package:flutter_application/widget/ListIndicator.dart';
import 'package:flutter_application/widget/MyAppbar.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ReplyPage extends StatefulWidget {
  final Comment comment;

  const ReplyPage({Key key, this.comment}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ReplyPageState();
  }
}

class _ReplyPageState extends State<ReplyPage> {
  ReplyRepository _replyRepository;
  @override
  void initState() {
    super.initState();
    _replyRepository = ReplyRepository(widget.comment.commentId);
  }

  @override
  void dispose() {
    _replyRepository?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar.simpleAppbar('共${widget.comment.replyNum}条回复'),
      body: LoadingMoreList(
        ListConfig<Reply>(
          itemBuilder: (BuildContext context, Reply reply, int index) {
            return ItemBuilder.buildReplyRow(
                context, reply, _replyRepository, index);
          },
          sourceList: _replyRepository,
          indicatorBuilder: _buildIndicator,
        ),
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return buildIndicator(context, status, _replyRepository);
  }
}
