import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/Dashboard.dart';
import 'package:tenisleague100/application/Forum/ForumViewModel.dart';
import 'package:tenisleague100/application/Forum/PostIndependent.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelPost.dart';

enum OptionDelete { post, comment }
const int POST = 0;
const int COMMENT = 0;

const Map<OptionDelete, int> optionsMap = {
  OptionDelete.comment: COMMENT,
  OptionDelete.post: POST,
};

Future<void> displaySafetyQuestionComment(ForumViewModel modelView, BuildContext context, String idPost, String idComment, int currentSize) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Confirma por favor"),
      content: Text("¿Quieres eliminar este comentario?"),
      actions: [
        TextButton(
          child: Text(
            "Si",
          ),
          onPressed: () => {
            modelView.deleteComment(idPost, idComment),
            Navigator.pop(context),
            currentSize == 1
                ? Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  )
                : DoNothingAction()
          },
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

Future<void> displaySafetyQuestionPost(ForumViewModel modelView, BuildContext context, String idPost) {
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
          onPressed: () => {
            modelView.deletePost(idPost),
            Navigator.pop(context),
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Dashboard()),
            )
          },
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

Widget rowCommentsAndDelete(ForumViewModel modelView, BuildContext context, ModelPost modelPost, bool comingFromIndependent) {
  return Row(
    mainAxisAlignment: modelView.user.id == modelPost.idUser ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () => {
          comingFromIndependent
              ? null
              : Navigator.of(context).push(
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
              onTap: () => displaySafetyQuestionPost(modelView, context, modelPost.id),
              child: Icon(
                Icons.delete,
                color: Color(GlobalValues.mainGreen),
              ),
            )
          : SizedBox.shrink(),
    ],
  );
}

Widget typingContainer(TextEditingController _messageController, Function function, BuildContext context) {
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
            onTap: () => {function(_messageController.text), FocusScope.of(context).unfocus(), _messageController.clear()},
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
