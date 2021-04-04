import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/list_repository/user_repository.dart';
import 'package:flutter_application/model/user.dart';
import 'package:flutter_application/state/global.dart';
import 'package:flutter_application/widget/ItemBuilder.dart';
import 'package:flutter_application/widget/ListIndicator.dart';
import 'package:loading_more_list/loading_more_list.dart';

class CommonUserPage extends StatefulWidget {
  final String str;

  const CommonUserPage({Key key, this.str}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CommonUserPageState();
  }
}

class _CommonUserPageState extends State<CommonUserPage> {
  UserRepository _userRepository;
  @override
  void initState() {
    super.initState();
    _userRepository = UserRepository(Global.profile.user.userId, 4, widget.str);
  }

  @override
  void dispose() {
    _userRepository?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _userRepository.refresh,
        child: LoadingMoreList(
          ListConfig<User>(
            itemBuilder: (BuildContext context, User user, int index) {
              return ItemBuilder.buildUserRow(context, user, 1);
            },
            sourceList: _userRepository,
            indicatorBuilder: _buildIndicator,
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return buildIndicator(context, status, _userRepository);
  }
}
