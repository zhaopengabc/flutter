import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: HomePage()));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  double _appBarHeight = 56; // the height of app bar is actually 56

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  floating: true,
                  snap: true,
                  pinned: true,
                  bottom: PreferredSize(
                    preferredSize: Size(0, _appBarHeight),
                    child: TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(child: Text("1")),
                        Tab(child: Text("2")),
                        Tab(child: Text("3")),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                FlutterLogo(size: 300, colors: Colors.blue), // use MyScreen1()
                FlutterLogo(size: 300, colors: Colors.orange), // use MyScreen2()
                FlutterLogo(size: 300, colors: Colors.red), // use MyScreen3()
              ],
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            height: MediaQuery.of(context).padding.top + _appBarHeight,
            child: AppBar(
              iconTheme: IconThemeData(color: Colors.red),
              automaticallyImplyLeading: true,
              elevation: 0,
              title: Text("My Title"),
              centerTitle: true,
            ),
          ),
        ],
      ),
    );
  }
}
