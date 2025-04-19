class WorkspaceModel {
  String? name;
  DateTime? createAt;
  String? createdBy;
  List<String>? members;

  WorkspaceModel({this.name, this.createAt, this.createdBy, this.members});
}
