import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final TextEditingController ectrl = new TextEditingController();


  void _handle(String text) {
    ectrl.clear();

    Firestore.instance
        .collection('avengers')
        .document()
        .setData({'name': '$text'});
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ready to chat',
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(

          title: Center(
            child: Text(
              'here you go',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add_circle), onPressed: null)
          ],
        ),
        body: StreamBuilder(
            stream: Firestore.instance.collection('avengers').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('loading...');
              return Column(children: <Widget>[
                Flexible(
                  child: ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.documents[index];
                        return Container(
                          child: ListTile(
                            
                            leading: IconButton(icon: Icon(Icons.bookmark_border,color: Colors.black38,), onPressed: null),
                            title: Text(ds['name'],style: TextStyle(fontStyle: FontStyle.italic),),
                            onLongPress: () {
                              Firestore.instance
                                  .collection('avengers')
                                  .document(
                                  snapshot.data.documents[index].documentID)
                                  .delete();
                            },
                          ),
                        );
                      }),
                ),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey,width: 3.0),borderRadius: BorderRadius.all(Radius.circular(25.0),)),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.insert_emoticon), onPressed: null),
                      Flexible(
                        
                        child: TextField(
                          decoration: InputDecoration.collapsed(
                              hintText: ' type a message'),
                          controller: ectrl,
                          onSubmitted: (String text) {
                            ectrl.clear();

                            Firestore.instance
                                .collection('avengers')
                                .document()
                                .setData({'name': '$text'});
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(2.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Colors.lightBlue,
                            ),
                            onPressed: () {
                              _handle(ectrl.text);
                            }),
                      )
                    ],
                  ),
                )
              ]);
            }),
          drawer: Drawer(child: Column(children: <Widget>[Flexible(flex:1,child: headerImage(),),Flexible(flex:2,child: ListTile(title: Text('hi'),))],),),
          endDrawer: Drawer(child: Container(decoration: BoxDecoration(border: Border.all(width: 10.0,color: Colors.grey)),),),

        
      ),
    );
  }
}

class headerImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage=AssetImage('images/GettyImages-469939874.jpg');
    Image image= Image(image: assetImage,fit: BoxFit.fill,);
    return Container(child: image,);
    
  }
}
