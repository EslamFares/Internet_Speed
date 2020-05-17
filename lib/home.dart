import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_speed_test/internet_speed_test.dart';
import 'package:internet_speed_test/callbacks_enum.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/foundation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final internetSpeedTest = InternetSpeedTest();
  double downloadRate = 0;
  double uploadRate = 0;
  String downloadProgress = '0';
  String uploadProgress = '0';
  String unitText = 'Mb/s';
  int click;
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  // ignore: non_constant_identifier_names
  Alert() {
    return scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 40),
                width: 140,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(50)),
                height: 35,
                child: Center(
                    child: Text(
                  "please,Wait..", //waiting upload
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ))),
          ],
        )));
  }
  Upload() {
    return internetSpeedTest.startUploadTesting(
      onDone: (double transferRate, SpeedUnit unit) {
        print('the transfer rate $transferRate');
        setState(() {
          uploadRate = transferRate;
          unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
          uploadProgress = '100';
        });
      },
      onProgress: (double percent, double transferRate, SpeedUnit unit) {
        print('the transfer rate $transferRate, the percent $percent');
        setState(() {
          uploadRate = transferRate;
          unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
          uploadProgress = percent.toStringAsFixed(2);
        });
      },
      onError: (String errorMessage, String speedTestError) {
        print(
            'the errorMessage $errorMessage, the speedTestError $speedTestError');
      },
    );
  }
  DownLoad() {
    return internetSpeedTest.startDownloadTesting(
      onDone: (double transferRate, SpeedUnit unit) {
        print('the transfer rate $transferRate');
        setState(() {
          downloadRate = transferRate;
          unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
          downloadProgress = '100';
        });
      },
      onProgress: (double percent, double transferRate, SpeedUnit unit) {
        print('the transfer rate $transferRate, the percent $percent');
        setState(() {
          downloadRate = transferRate;
          unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
          downloadProgress = percent.toStringAsFixed(2);
        });
      },
      onError: (String errorMessage, String speedTestError) {
        print(
            'the errorMessage $errorMessage, the speedTestError $speedTestError');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SpeedRate(context),
            downloadProgress == '100' || downloadProgress == '0'
                ? DownLoadButton(context)
                : DownloadAfterClick(context),
            DownLoadContainer(context),
            UpLoadContainer(context),
          ],
        ),
      )),
    );
  }

  Widget SpeedRate(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 5),
      width: 400,
      height: 320,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
              showAxisLine: false,
              minimum: 0,
              maximum: 50,
              ticksPosition: ElementsPosition.outside,
              labelsPosition: ElementsPosition.outside,
              radiusFactor: .9,
              needsRotateLabels: true,
              majorTickStyle: MajorTickStyle(
                length: 0.1,
                color: Colors.white,
                thickness: 1.5,
                lengthUnit: GaugeSizeUnit.factor,
              ),
              minorTickStyle: MinorTickStyle(
                length: 0.04,
                color: Colors.white60,
                thickness: 1.5,
                lengthUnit: GaugeSizeUnit.factor,
              ),
              minorTicksPerInterval: 4,
              interval: 5,
              labelOffset: 15,
              axisLabelStyle: GaugeTextStyle(fontSize: 15),
              useRangeColorForAxis: true,
              pointers: <GaugePointer>[
                NeedlePointer(
                    needleColor: Colors.white,
                    needleStartWidth: 1,
                    enableAnimation: true,
                    value: downloadRate,
                    tailStyle: TailStyle(
                        length: 0.2,
                        width: 5,
                        lengthUnit: GaugeSizeUnit.factor),
                    needleEndWidth: 5,
                    needleLength: 0.8,
                    lengthUnit: GaugeSizeUnit.factor,
                    knobStyle: KnobStyle(
                      color: Colors.white,
                      knobRadius: 0.08,
                      sizeUnit: GaugeSizeUnit.factor,
                    ))
              ],
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 10,
                    endValue: 50,
                    startWidth: kIsWeb ? 0.2 : 0.05,
                    gradient: kIsWeb
                        ? null
                        : const SweepGradient(colors: <Color>[
                            Colors.blue,
                            Colors.black
                          ], //Color(0xFF289AB1), Color(0xFF43E695)
                            stops: <double>[
                                0.25,
                                0.75
                              ]),
                    color: Colors.white, //Color(0xFF289AB1)
                    rangeOffset: 0.08,
                    endWidth: 0.2,
                    sizeUnit: GaugeSizeUnit.factor)
              ]),
        ],
      ),
    );
  }

  Widget DownLoadContainer(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Download rate ',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Time $downloadProgress%',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              ' $downloadRate',
              style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: downloadProgress == '100'
                      ? Colors.blue
                      : Color(0xffD2D2D2)),
            ),
            Text(
              ' $unitText',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }

  Widget UpLoadContainer(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        uploadProgress == '100' || uploadProgress == '0'
            ? UploadButton(context)
            : UpLoadAfterClick(context),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Upload rate ',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Time $uploadProgress%',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              ' $uploadRate ',
              style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color:
                      uploadProgress == '100' ? Colors.red : Color(0xffD2D2D2)),
            ),
            Text(
              ' $unitText',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }

  Widget DownLoadButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 0, bottom: 20),
        height: 50,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
            child: Text(
          'Start',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        )),
      ),
      onTap:
          uploadProgress == '100' || uploadProgress == '0' ? DownLoad : Alert,
    );
  }

  Widget UploadButton(BuildContext context) {
    return GestureDetector(
      onTap:
          downloadProgress == '100' || downloadProgress == '0' ? Upload : Alert,
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 30),
        height: 50,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
            child: Text(
          'Test Upload',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }

  Widget UpLoadAfterClick(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 30),
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(Icons.file_upload),
      ),
    );
  }

  Widget DownloadAfterClick(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 20),
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(Icons.file_download),
      ),
    );
  }
}
