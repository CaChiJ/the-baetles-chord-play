import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:the_baetles_chord_play/domain/model/sheet_element_size.dart';
import 'package:the_baetles_chord_play/domain/model/triad_type.dart';
import 'package:the_baetles_chord_play/presentation/performance/control_bar.dart';
import 'package:the_baetles_chord_play/presentation/performance/performance_app_bar.dart';
import 'package:the_baetles_chord_play/presentation/performance/performance_view_model.dart';

import '../../domain/model/chord.dart';
import '../../domain/model/note.dart';
import '../../domain/model/sheet_data.dart';
import '../../domain/model/sheet_info.dart';
import '../../domain/model/video.dart';
import '../../widget/atom/app_colors.dart';
import '../../widget/atom/app_font_families.dart';
import '../../widget/molecule/EllipseToggleButton.dart';
import '../../widget/molecule/chord_picker.dart';
import 'fragment/guitar_tab_view.dart';
import 'fragment/sheet_view.dart';

class PerformancePage extends StatefulWidget {
  const PerformancePage({Key? key}) : super(key: key);

  @override
  State<PerformancePage> createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  late PerformanceViewModel _performanceViewModel;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Map<String, dynamic> arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      Video video = arguments['video'] as Video;
      SheetInfo sheetInfo = arguments["sheetInfo"] as SheetInfo;
      SheetData sheetData = arguments['sheetData'] as SheetData;

      PerformanceViewModel viewModel = context.read<PerformanceViewModel>();

      viewModel.initViewModel(
        video: video,
        sheetInfo: sheetInfo,
        sheetData: sheetData,
      );
    });

    _performanceViewModel = context.read<PerformanceViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    PerformanceViewModel viewModel = context.read<PerformanceViewModel>();

    return Scaffold(
      backgroundColor: AppColors.grayF5,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: viewModel.currentPosition,
                    builder: (context, value, _) {
                      return ValueListenableBuilder(
                        valueListenable: viewModel.sheetState,
                        builder: (context, value, _) {
                          if (viewModel.sheetState.value?.sheetData == null) {
                            return Container();
                          }
                          return LayoutBuilder(builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return SheetView(
                              currentPosition: viewModel.currentPosition.value,
                              sheetData:
                                  (viewModel.sheetState.value?.sheetData)!,
                              correctIndexes: viewModel
                                  .feedbackState.correctIndexes
                                  .toList(),
                              wrongIndexes:
                                  viewModel.feedbackState.wrongIndexes.toList(),
                              onClick: (int tileIndex) {
                                viewModel.onTileClick(tileIndex);
                              },
                              onLongClick: (tileIndex) {
                                viewModel.onTileLongClick(tileIndex);
                              },
                              sheetElementSize: SheetElementSize.expand(
                                sheetHeight: constraints.maxHeight,
                                sheetWidth: constraints.maxWidth,
                                measureCount: 3,
                                spaceWidth: 3,
                                barWidth: 2,
                              ),
                            );
                          });
                        },
                      );
                    },
                  ),
                ),
                LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    color: Colors.white,
                    child: GuitarTabView(
                        width: 230, height: constraints.maxHeight),
                  );
                })
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder(
              valueListenable: viewModel.playOption,
              builder: (context, value, _) {
                return Visibility(
                  visible: !viewModel.playOption.value.isPlaying,
                  child: PerformanceAppBar(
                    viewModel: viewModel,
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 65,
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: viewModel.currentPosition,
                    builder: (context, value, _) {
                      log("${viewModel.currentPositionInPercentage ?? 0}");
                      return LinearProgressIndicator(
                        value: (viewModel.currentPositionInPercentage ?? 0) /
                            100.0,
                        color: AppColors.blue4E,
                        backgroundColor: Colors.transparent,
                        minHeight: 3,
                      );
                    },
                  ),
                  ControlBar(),
                ],
              ),
            ),
          ),
          Positioned.fill(
            left: 0,
            top: 0,
            child: ValueListenableBuilder(
              valueListenable: viewModel.editingPosition,
              builder: (context, value, _) {
                return Visibility(
                  visible: viewModel.isEditing,
                  child: GestureDetector(
                    onTap: () {
                      viewModel.editingPosition.value = null;
                    },
                    child: Container(
                      color: AppColors.shadow00,
                      alignment: Alignment.center,
                      child: Dialog(
                        child: Container(
                          width: 270,
                          height: 280,
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 190,
                                child: ChordPicker(
                                  onChangeChord: viewModel.onChangeChord,
                                  initRoot: viewModel.editedChord?.root,
                                  initTriadType:
                                      viewModel.editedChord?.triadType,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: 280,
                                height: 44,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: EllipseToggleButton(
                                        text: "취소",
                                        initState: false,
                                        onPressed: (_) =>
                                            viewModel.onCancleEdit(),
                                        textStyleOnActivated: TextStyle(
                                          fontFamily:
                                              AppFontFamilies.pretendard,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                        textStyleOnInActivated: TextStyle(
                                          fontFamily:
                                              AppFontFamilies.pretendard,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.black04,
                                          fontSize: 14,
                                        ),
                                        borderRadius: BorderRadius.circular(23),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: EllipseToggleButton(
                                        text: "확인",
                                        initState: true,
                                        onPressed: (_) =>
                                            viewModel.onApplyEdit(),
                                        textStyleOnActivated: TextStyle(
                                          fontFamily:
                                              AppFontFamilies.pretendard,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                        textStyleOnInActivated: TextStyle(
                                          fontFamily:
                                              AppFontFamilies.pretendard,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.black04,
                                          fontSize: 14,
                                        ),
                                        borderRadius: BorderRadius.circular(23),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _performanceViewModel = context.read<PerformanceViewModel>();
  }

  @override
  void dispose() {
    _performanceViewModel.reset();
    super.dispose();
  }
}
