import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
  final Map data;
  final String time;
  final DocumentReference ref;

  ViewNote(this.data, this.time, this.ref);

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  late String title;
  late String des;

  bool edit = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    title = widget.data['title'];
    des = widget.data['description'];
    return SafeArea(
      child: Scaffold(
        //
        floatingActionButton: edit
            ? FloatingActionButton(
                onPressed: save,
                child: Icon(
                  Icons.save_rounded,
                  color: Colors.white60,
                ),
                backgroundColor: Colors.grey[700],
              )
            : null,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey[700],
                        ),
                      ),
                    ),
                    //
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              edit = !edit;
                            });
                          },
                          child: Icon(
                            Icons.edit,
                            size: 22.0,
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.grey[700],
                            ),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                        ),
                        //
                        SizedBox(
                          width: 8.0,
                        ),

                        ElevatedButton(
                          onPressed: delete,
                          child: Icon(
                            Icons.delete_forever,
                            size: 22.0,
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.red[300],
                            ),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //
                SizedBox(
                  height: 20.0,
                ),
                //
                Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: "Title",
                        ),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "lato",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        initialValue: widget.data['title'],
                        enabled: edit,
                        onChanged: (_val) {
                          title = _val;
                        },
                        validator: (_val){
                          if(_val!.isEmpty) {
                            return "Can't be empty";
                          }else{
                            return null;
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          widget.time,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: "lato",
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                     TextFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: "Note Description",
                        ),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "lato",
                          color: Colors.grey,
                        ),
                        initialValue: widget.data['description'],
                        enabled: edit,
                        onChanged: (_val) {
                          des = _val;
                        },
                        maxLines: 20,
                       validator: (_val){
                         if(_val!.isEmpty) {
                           return "Can't be empty";
                         }else{
                           return null;
                         }
                       },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void delete() async {
    //delete from db
    await widget.ref.delete();
    Navigator.pop(context);
  }
  
  void save() async {
    if(key.currentState!.validate()) {
    //
    await widget.ref.update(
      {'title' : title, 'description' : des},
    );
    Navigator.of(context).pop();
   }
  }
}
