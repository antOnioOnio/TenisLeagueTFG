import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/Forum/Dialogs/AddPictureDialog.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';

import 'Dialogs/AddProPartidoDialog.dart';
import 'ForumViewModel.dart';

class AddPostHeader extends StatelessWidget {
  final ForumViewModel viewModel;

  const AddPostHeader({Key key, @required this.viewModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 20),
          child: Text(
            "TENIS 100",
            style: GoogleFonts.sairaExtraCondensed(color: Color(GlobalValues.mainGreen), fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: chatBgDecoration(0.5),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                    backgroundColor: Color(GlobalValues.mainGreen),
                    radius: 20,
                    child: customAvatar(viewModel.imageUser),
                  ),
                  SizedBox(
                    width: 70,
                  ),
                  Text(
                    "¿Qué quieres publicar?",
                    style: GoogleFonts.raleway(color: Color(GlobalValues.mainTextColorHint), fontWeight: FontWeight.normal, fontSize: 15),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: Container(
                  decoration: decorationTopBorder(),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            GestureDetector(
                              onTap: () => {
                                openDialogForProMatch(context, viewModel),
                              },
                              child: Text(
                                "Propuesta partido",
                                style: GoogleFonts.raleway(color: Color(GlobalValues.mainGreen), fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () => {
                            openDialogForCamera(context, viewModel),
                          },
                          child: Icon(
                            Icons.camera_enhance,
                            color: Color(GlobalValues.mainGreen),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Evento",
                              style: GoogleFonts.raleway(color: Color(GlobalValues.mainGreen), fontWeight: FontWeight.bold, fontSize: 12),
                             ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void openDialogForCamera(BuildContext context, ForumViewModel viewModel) {
    showDialog(
        context: context,
        builder: (_) {
          return AddPictureDialog(
            viewModel: viewModel,
          );
        });
  }

  void openDialogForProMatch(BuildContext context, ForumViewModel viewModel) {
    showDialog(
        context: context,
        builder: (_) {
          return AddProPartidoDialog(
            viewModel: viewModel,
          );
        });
  }
}
