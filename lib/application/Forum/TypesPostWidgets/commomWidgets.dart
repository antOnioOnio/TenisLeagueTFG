import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/Forum/ForumViewModel.dart';
import 'package:tenisleague100/application/Forum/PostIndependent.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelComment.dart';
import 'package:tenisleague100/models/ModelPost.dart';

Future<void> displaySafetyQuestion(ForumViewModel modelview, BuildContext context, String idPost) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Confirma por favor"),
      content: Text("¿Quieres eliminar este post?"),
      actions: [
        TextButton(
          child: Text(
            "Si",
          ),
          onPressed: () => {modelview.deletePost(idPost), Navigator.pop(context)},
        ),
        TextButton(
          child: Text(
            "No",
          ),
          onPressed: () => {
            Navigator.pop(context),
          },
        )
      ],
    ),
  );
}

Widget rowCommentsAndDelete(ForumViewModel modelView, BuildContext context, ModelPost modelPost, bool showComments) {
  return Row(
    mainAxisAlignment: modelView.user.id == modelPost.idUser ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
    children: [
      showComments
          ? listComments(modelPost)
          : GestureDetector(
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PostIndependent(viewModel: modelView, modelPost: modelPost)),
                )
              },
              child: Icon(
                Icons.comment,
                color: Color(GlobalValues.mainGreen),
              ),
            ),
      modelView.user.id == modelPost.idUser
          ? GestureDetector(
              onTap: () => displaySafetyQuestion(modelView, context, modelPost.id),
              child: Icon(
                Icons.delete,
                color: Color(GlobalValues.mainGreen),
              ),
            )
          : SizedBox.shrink(),
    ],
  );
}

Widget listComments(ModelPost modelPost) {
  return modelPost.comments == null || modelPost.comments.isEmpty
      ? Center(
          child: Text(
            "No hay comentarios aún",
            style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 14),
          ),
        )
      : ListView.builder(
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: modelPost.comments.length,
          itemBuilder: (context, index) {
            return comment(modelPost.comments[index]);
          },
        );
}

Widget comment(ModelComment comment) {
  return Row(
    children: [
      Text(
        comment.comment,
        style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 14),
      )
    ],
  );
}

Widget typingContainer(TextEditingController _messageController /*, Function function*/) {
  return Material(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: 400,
        height: 40,
        alignment: Alignment.center,
        decoration: containerChatSelection(),
        child: ListTile(
          title: Row(
            children: [
              Expanded(
                child: TextFormField(
                  /*focusNode: _focusMsg,*/

                  controller: _messageController,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 14),
                  decoration: inputDecoration("Escribe algo"),
                ),
              ),
            ],
          ),
          trailing: GestureDetector(
            /* onTap: () => function(_messageController.text),*/
            onTap: () => print("callate"),
            child: Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Icon(
                Icons.send,
                color: Color(GlobalValues.mainGreen),
                size: 25,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
