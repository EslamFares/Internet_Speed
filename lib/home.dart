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

  testDownLoadandUpLoad(){
    internetSpeedTest.startDownloadTesting(
      onDone: (double transferRate, SpeedUnit unit) {
        print('the transfer rate $transferRate');
        setState(() {
          downloadRate = transferRate;
          unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
          downloadProgress = '100';
        });
      },
      onProgress:
          (double percent, double transferRate, SpeedUnit unit) {
        print(
            'the transfer rate $transferRate, the percent $percent');
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
    internetSpeedTest.startUploadTesting(
      onDone: (double transferRate, SpeedUnit unit) {
        print('the transfer rate $transferRate');
        setState(() {
          uploadRate = transferRate;
          unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
          uploadProgress = '100';
        });
      },
      onProgress:
          (double percent, double transferRate, SpeedUnit unit) {
        print(
            'the transfer rate $transferRate, the percent $percent');
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Container(
              margin: EdgeInsets.only(top: 50,bottom: 5),
              width: 400,
              height: 400,
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
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: testDownLoadandUpLoad,
              child: Container(
                margin: EdgeInsets.only(top: 0,bottom: 40),
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue,width: 5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text('Start',style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                ),)),

              ),
            ),
            Column(
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
                      'Progress $downloadProgress%',
                      style: TextStyle(fontSize: 18),
                    ),
                   
                  ],
                ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[

                   Text(
                     ' $downloadRate',
                     style: TextStyle(fontSize: 70,color: Color(0xffD2D2D2)),
                   ), Text(
                     ' $unitText',
                     style: TextStyle(fontSize: 20),
                   ),
                 ],
               ),
              ],
            ),
            RaisedButton(
              color: Colors.blue,
              child: Text(
                'start testing',
                style: TextStyle(fontSize: 25),
              ),
              onPressed: (){
                internetSpeedTest.startDownloadTesting(
                  onDone: (double transferRate, SpeedUnit unit) {
                    print('the transfer rate $transferRate');
                    setState(() {
                      downloadRate = transferRate;
                      unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                      downloadProgress = '100';
                    });
                  },
                  onProgress:
                      (double percent, double transferRate, SpeedUnit unit) {
                    print(
                        'the transfer rate $transferRate, the percent $percent');
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
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Upload rate ',
                      style: TextStyle(fontSize: 18),
                    ), Text(
                      'Progress $uploadProgress%',
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
                      style: TextStyle(fontSize: 70, color: Color(0xffD2D2D2)),
                    ),Text(
                      ' Kb/s',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
            RaisedButton(
              color: Colors.red,
              child: Text(
                'start testing',
                style: TextStyle(fontSize: 25),
              ),
              onPressed: (){
                internetSpeedTest.startUploadTesting(
                  onDone: (double transferRate, SpeedUnit unit) {
                    print('the transfer rate $transferRate');
                    setState(() {
                      uploadRate = transferRate;
                      unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                      uploadProgress = '100';
                    });
                  },
                  onProgress:
                      (double percent, double transferRate, SpeedUnit unit) {
                    print(
                        'the transfer rate $transferRate, the percent $percent');
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
