class Agent {
  int agentID;
  String agentName;
  int rating;
  bool showLocation;
  List<double> position;
  List<double> deliveryPosition;

  Agent(this.agentID, this.agentName, this.showLocation ,this.rating, this.position, this.deliveryPosition);
}