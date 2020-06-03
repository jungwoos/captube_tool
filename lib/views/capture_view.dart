import 'dart:convert';

import 'package:captube/locator.dart';
import 'package:captube/routing/route_names.dart';
import 'package:captube/services/navigation_service.dart';
import 'package:captube/viewmodels/episode_list_view_model.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
  
class CaptureView extends StatefulWidget {
  CaptureView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CaptureViewState createState() => _CaptureViewState();
}

class _CaptureViewState extends State<CaptureView> {
  bool _isLoading = false;
  var _data = "";
  //var _data = "Not loaded";
  var _apiURL = 'http://captube.net/api/v1/capture';
  EpisodeListViewModel _elvm;
 
  void _fetchData(String url) async {
//    Map<String, String> headers = {'Content-Type': "application/json"};
//    String json = '{"url": "$url", "language": "eng"}';

    setState(() {
      _isLoading = true;
    });

    print('Calling API...with url: $url');
    var response;
    try{
      response = await post(
        _apiURL,
        body: jsonEncode(
          {
            //'url': 'https://www.youtube.com/watch?v=Czof3Fz4JOw',
            'url': '$url',
            //'language': 'eng',
          }
        ),
        headers: {'Content-Type': "application/json"},
      );
      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
          _data = json.decode(response.body)['id'];
        });
        print("Response: ${response.statusCode}");
        EpisodeListViewModel().navigateToEpisode(_data);
        //Navigator.pushNamed(context, '/detail?id=$_data');
      } else {
        throw Exception('Failed to load data');
      }
    } catch (err) {
      setState(() {
        _isLoading = false;
        _data = '$err';
        print('Caught error: $err');
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController();
    
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          alignment: Alignment.topCenter,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 100.0,),
        
        TextField(
          controller: _controller,
          decoration: InputDecoration(
              labelText: "Video URL",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
          ),
        ),
        SizedBox(height: 20.0,),
        RaisedButton(
          child: Text("Submit"),
            onPressed: () {
              String text = _controller.text.toString();
              _fetchData(text);
                  //if (!text.contains("https://")) {
                  //  text = "https://" + text;
                  //}
                  // text here will always have https://
            },
        ),
        SizedBox(height: 20.0,),
        _isLoading ? CircularProgressIndicator() 
        ://Text(""),
        //:_navigationService.navigateTo(EpisodeDetailsRoute, queryParams: {'id': _data})
          Text("$_data")
              //Text(_isLoading ? "Loading.." : _data),
      ],
    )
    );
  }
}

