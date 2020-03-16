import 'package:aoe2/components/custom_list_tile.dart';
import 'package:aoe2/constants.dart';
import 'package:aoe2/models/leaderboards.dart';
import 'package:aoe2/models/networking.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:flutter/cupertino.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _nh = NetworkHelper();
  final _tec = TextEditingController();
  Leaderboards _lbs;
  int _lbId = k1v1RM;
  int _count = 0;
  int _total = 0;
  bool _endList = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getLeaderboards();
  }

  @override
  void dispose() {
    super.dispose();
    _tec.dispose();
  }

  Future<void> _getLeaderboards() async {
    setState(() {
      _isLoading = true;
    });
    _tec.clear();
    _count = 0;
    _lbs = await _nh.getLeaderboards(_lbId, _count);
    if (_lbs.isLoaded) {
      _lbId = _lbs.leaderboardId;
      _count = _lbs.count + 1;
      _total = _lbs.total;
      _endList = _lbs.count < kNumberPerBatch;
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getLeaderboardsByName() async {
    setState(() {
      _isLoading = true;
    });
    _count = 0;
    _lbs = await _nh.getLeaderboardsByName(_lbId, _total, _tec.text);
    if (_lbs.isLoaded) {
      _lbId = _lbs.leaderboardId;
      _endList = true;
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadMore() async {
    if (_endList) {
      return;
    }

    Leaderboards lbsNext = await _nh.getLeaderboards(_lbId, _count);
    if (lbsNext.isLoaded) {
      _count += kNumberPerBatch;
      _endList = lbsNext.count < kNumberPerBatch;
      _lbs.leaderboard.addAll(lbsNext.leaderboard);
    }
    setState(() {});
  }

  void _showNameSearchDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Search name', style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Reset',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                onPressed: () {
                  _getLeaderboards();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                onPressed: () {
                  if (_tec.text.length > 2) {
                    _getLeaderboardsByName();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
            content: SingleChildScrollView(
              child: TextField(
                controller: _tec,
                autofocus: true,
                decoration: InputDecoration(
                  border: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: Color(kRedColor)),
                  ),
                  focusedBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: Color(kRedColor)),
                  ),
                  hintText: 'Name of the player',
                  helperText: 'Please enter at least 3 characters',
                  suffixIcon: IconButton(
                    color: Color(kRedColor),
                    icon: Icon(Icons.clear),
                    onPressed: () => _tec.clear(),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                cursorColor: Color(kRedColor),
              ),
            ),
          );
        });
  }

  Widget _getListItemWidget(Leaderboard lb) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(kRedColor),
          ),
        ),
      ),
      height: 60,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Text(
                    '${lb.rank}',
                    style: kTrajanLeading,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${lb.name}',
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: kTrajanTitle,
                        ),
                        Text(
                          '${lb.games} Games - ${lb.wins} Wins - ${lb.losses} Losses',
                          style: kTrajanSubtitle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${lb.rating}',
              style: kTrajanLeading,
            ),
          ],
        ),
      ),
    );
  }

  void _onTapDrawerTile(int lbId) {
    _lbId = lbId;
    Navigator.pop(context);
    if (_tec.text != "") {
      _getLeaderboardsByName();
    } else {
      _getLeaderboards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Image(
            image: AssetImage('assets/images/appbar-bg.jpg'),
            fit: BoxFit.cover,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                getLeaderboardTitle(_lbId),
                style: kTrajanTitle,
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _showNameSearchDialog,
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(''),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/aoe2.jpg'))),
              ),
              CustomListTile(
                'Unranked',
                () => _onTapDrawerTile(kUNRANKED),
              ),
              CustomListTile(
                '1vs1 Death Match',
                () => _onTapDrawerTile(k1V1DM),
              ),
              CustomListTile(
                'Team Death Match',
                () => _onTapDrawerTile(kTDM),
              ),
              CustomListTile(
                '1vs1 Random Map',
                () => _onTapDrawerTile(k1v1RM),
              ),
              CustomListTile(
                'Team Random Map',
                () => _onTapDrawerTile(kTRM),
              ),
            ],
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : SafeArea(
                child: _lbs.isLoaded
                    ? LazyLoadScrollView(
                        onEndOfPage: () => _loadMore(),
                        child: ListView.builder(
                          itemCount: _endList
                              ? _lbs.leaderboard.length
                              : _lbs.leaderboard.length + 1,
                          itemBuilder: (context, position) {
                            if (position == _lbs.leaderboard.length) {
                              return CupertinoActivityIndicator();
                            } else {
                              return _getListItemWidget(
                                  _lbs.leaderboard[position]);
                            }
                          },
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.error_outline,
                            color: Color(kRedColor),
                            size: 24,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'There was an error fetching data',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 32),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FlatButton(
                            color: Color(kRedColor),
                            child: Text(
                              "TRY AGAIN",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 5,
                                  fontSize: 15),
                            ),
                            onPressed: () {
                              _getLeaderboards();
                            },
                          ),
                        ],
                      ),
              ),
      ),
    );
  }
}
