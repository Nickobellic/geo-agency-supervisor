import 'dart:ffi';

class Agent {
  int agentID;
  String agentName;
  int rating;
  List<double> position;

  Agent(this.agentID, this.agentName, this.rating, this.position);
}