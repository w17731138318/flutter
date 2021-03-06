import 'package:controller/pages/about/about.dart';
import 'package:controller/pages/home/home.dart';
import 'package:controller/pages/setting/setting.dart';
import 'package:controller/provider/app_config_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppConfigModel())],
      child: Consumer<AppConfigModel>(
        builder: (context, appConfigModel, _) {
          return appConfigModel.darkMode == 2
              ? MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: '展厅管理',
                  theme: ThemeData(
                    primaryColor: Provider.of<AppConfigModel>(context, listen: false).themeMode,
                  ),
                  darkTheme: ThemeData.dark(),
                  home: MainPage(title: '展厅管理'),
                )
              : MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: '展厅管理',
                  theme: appConfigModel.darkMode == 1
                      ? ThemeData.dark()
                      : ThemeData(
                          primaryColor: Provider.of<AppConfigModel>(context, listen: false).themeMode,
                        ),
                  home: MainPage(title: '展厅管理'),
                );
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _btnIndex = 1;
  List<Widget> pages = [HomePage(), SettingPage(), AboutPage()];
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: ClipOval(
            child: Image.asset(
              'images/CircleAvatar.png',
              width: 45.0,
              height: 45.0,
              fit: BoxFit.contain,
            ),
          ),
          onPressed: () {
            setState(() {
              _btnIndex = 1;
            });
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        centerTitle: true,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            tooltip: '修改主题',
            icon: Icon(
              Icons.color_lens,
            ),
            onPressed: () {
              setState(() {
                _btnIndex = 2;
              });
              _scaffoldKey.currentState.openDrawer();
            },
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Provider.of<AppConfigModel>(context, listen: false).themeMode,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('主页')),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('设置')),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('我')),
        ],
      ),
      drawer: buildDrawer(),
    );
  }

  buildDrawer() {
    if (_btnIndex == 1) {
      return buildAboutMeDrawer();
    } else if (_btnIndex == 2) {
      return buildThemeDrawer();
    }
  }

  buildAboutMeDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text('侧边栏'),
            accountEmail: Text('w17731138318@126.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('images/CircleAvatar.png'),
            ),
            margin: EdgeInsets.zero,
          ),
          MediaQuery.removePadding(
            context: context,
            // DrawerHeader consumes top MediaQuery padding.
            removeTop: true,
            child: const ListTile(
              leading: Icon(Icons.home),
              title: Text('主页'),
            ),
          ),
          MediaQuery.removePadding(
            context: context,
            // DrawerHeader consumes top MediaQuery padding.
            removeTop: true,
            child: const ListTile(
              leading: Icon(Icons.info),
              title: Text('我的信息'),
            ),
          ),
        ],
      ),
    );
  }

  buildThemeDrawer() {
    return Drawer(
      child: ListView.builder(
        itemCount: 1 + Provider.of<AppConfigModel>(context, listen: false).themeMap.length,
        itemBuilder: (BuildContext context, int index) {
          /// 前三项留给 夜间模式
          return buildAppConfigModelTileItems(index - 3);
        },
      ),
    );
  }

  buildAppConfigModelTileItems(int index) {
    if (index < -2) {
      return ListTile(
        leading: Icon(
          Icons.brightness_5,
          color: Colors.grey,
        ),
        title: Text('关闭夜间模式'),
        onTap: () {
          Provider.of<AppConfigModel>(context, listen: false).changeMode(0);
        },
      );
    } else if (index < -1 && index > -3) {
      return ListTile(
        leading: Icon(
          Icons.brightness_7,
        ),
        title: Text('开启夜间模式'),
        onTap: () {
          Provider.of<AppConfigModel>(context, listen: false).changeMode(1);
        },
      );
    } else if (index < 0 && index > -2) {
      return ListTile(
        leading: Icon(
          Icons.settings,
        ),
        title: Text('跟随系统'),
        onTap: () {
          Provider.of<AppConfigModel>(context, listen: false).changeMode(2);
        },
      );
    } else {
      /// 主题颜色 列表
      String colorKey = Provider.of<AppConfigModel>(context, listen: false).themeMap.keys.elementAt(index);
      Color color = Provider.of<AppConfigModel>(context, listen: false).themeMap.values.elementAt(index);
      return ListTile(
        leading: Icon(
          Icons.lens,
          color: color,
        ),
        title: Text(colorKey),
        onTap: () {
          Provider.of<AppConfigModel>(context, listen: false).changeThemeMode(colorKey);
        },
      );
    }
  }

  buildColorItems() {
    List<Widget> listTiles = List();
    listTiles.add(ListTile(
      leading: Icon(Icons.wb_sunny),
      title: Container(
        padding: EdgeInsets.only(right: 150),
        child: Switch(
          value: Provider.of<AppConfigModel>(context, listen: false).darkMode == 1,
          onChanged: (bool val) {
            if (val) {
              Provider.of<AppConfigModel>(context, listen: false).changeMode(1);
            } else {
              Provider.of<AppConfigModel>(context, listen: false).changeMode(0);
            }
            setState(() {});
          },
        ),
      ),
    ));
    Provider.of<AppConfigModel>(context, listen: false).themeMap.forEach((colorKey, color) {
      print(colorKey);
      ListTile listTileWidget = ListTile(
        leading: Icon(
          Icons.lens,
          color: color,
        ),
        title: Text(colorKey),
        onTap: () {
          Provider.of<AppConfigModel>(context, listen: false).changeThemeMode(colorKey);
          setState(() {});
        },
      );
      listTiles.add(listTileWidget);
    });
  }
}
