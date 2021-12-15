import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:i_steamo/models/Repo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  initState() {
    super.initState();
    //fetchData();
    getRepoData();
  }

  final RefreshController rfController =
      RefreshController(initialRefresh: true);
  int currentPage = 1;
  int totalPages;
  Future<All> futureRepo;
  List<Repo> repos = [];

  Future<bool> getRepoData({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
    }
    try {
      final Uri uri = Uri.parse(
          "https://api.github.com/users/JakeWharton/repos?page=$currentPage&per_page=15");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        if (isRefresh) {
          repos = repoFromJson(response.body);
        } else {
          repos.addAll(repoFromJson(response.body));
        }
        currentPage++;
        print(repos);

        setState(() {});

        return true;
      } else {
        return false;
      }
    } catch (SocketException) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Connect to Internet")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Jake's Git"),
        ),
        body: SmartRefresher(
            controller: rfController,
            enablePullUp: true,
            onRefresh: () async {
              final result = getRepoData(isRefresh: true);
              if (result != null) {
                rfController.refreshCompleted();
              } else {
                rfController.refreshFailed();
              }
            },
            onLoading: () async {
              final result = getRepoData();
              if (result != null) {
                rfController.loadComplete();
              } else {
                rfController.loadFailed();
              }
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                final repo = repos[index];
                return ListTile(
                  leading: Icon(Icons.book),
                  title: Text(repo.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Text(repo.description ?? ""),
                      Row(
                        children: [
                          Icon(
                            Icons.settings_ethernet,
                            size: 16,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(repo.language ?? ""),
                          SizedBox(
                            width: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.bug_report_outlined,
                                size: 16,
                              ),
                              SizedBox(width: 5),
                              Text(repo.openIssuesCount.toString() ?? "")
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.face,
                                size: 16,
                              ),
                              SizedBox(width: 5),
                              Text(repo.watchersCount.toString() ?? "")
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
              //  separatorBuilder: (context, index) => Divider(),
              itemCount: repos.length,
            )));
  }
}
