import 'dart:convert';

class All {
  List<Repo> repos;
  All({this.repos});

  factory All.fromJson(List<dynamic> json) {
    // ignore: deprecated_member_use
    List<Repo> repos = new List<Repo>();
    repos = json.map((e) => Repo.fromJson(e)).toList();
    return All(repos: repos);
  }
}

List<Repo> repoFromJson(String str) =>
    List<Repo>.from(json.decode(str).map((x) => Repo.fromJson(x)));

String repoToJson(List<Repo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Repo {
  Repo({
    this.name,
    this.description,
    this.watchersCount,
    this.language,
    this.openIssuesCount,
  });

  String name;
  String description;
  int watchersCount;
  String language;

  int openIssuesCount;

  factory Repo.fromJson(Map<String, dynamic> json) => Repo(
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        watchersCount: json["watchers_count"] ?? "",
        language: json["language"] ?? "",
        openIssuesCount: json["open_issues_count"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "watchers_count": watchersCount,
        "language": language,
        "open_issues_count": openIssuesCount,
      };
}
