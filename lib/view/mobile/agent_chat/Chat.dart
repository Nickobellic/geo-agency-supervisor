import 'dart:async';
import 'package:geo_agency_mobile/utils/MapCenterBounds.dart' as get_center;
import 'package:geo_agency_mobile/view_model/agent_locations/agent_locations_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';


class ChatToAgentMobile extends HookConsumerWidget {
// Consider making TaskRepository() a singleton by using a factory
  late String agentName;
  ChatToAgentMobile(this.agentName);

  bool _isLoading = false;


  final myController = TextEditingController();
  final FocusNode _focusNode = FocusNode();


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var messages = useState<List<String>>([]);
  
    return Consumer(builder: (context, ref, child) {
      child: return Scaffold(  
      body: Scaffold(
      appBar: AppBar(
        title: Text('$agentName'),
      ),
      body: Column (
        children: <Widget> [
          Expanded(
          child: ListView.builder(
              
              itemCount: messages.value.length,
              itemBuilder: (context, index) {
                
                return ListTile(
                  title: Text(messages.value[index]),
                );
              },
            )),
      Container(
        
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.all(15),

        child: TextField(
          focusNode: _focusNode,
          controller: myController,
          decoration: InputDecoration(
            hintText: "Enter your message.."
          ),
        ),
      ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          var tempMsg = messages.value;
          tempMsg.add(myController.text);
          messages.value = tempMsg;
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.send),
      ),
      
    )
    );
    },)
    
    ;
  }


}
