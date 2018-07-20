import 'dart:math' as math;
import 'dart:math';
import 'package:corrida_urbana/util/timer_text_formater.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';



class ProgressPainter extends CustomPainter {
  ProgressPainter({
    @required this.animation,
    @required this.backgroundColor,
    @required this.color,
  }) : super(repaint: animation);

  /// Animation representing what we are painting
  final Animation<double> animation;

  /// The color in the background of the circle
  final Color backgroundColor;

  /// The foreground color used to indicate progress
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progressRadians = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(
      Offset.zero & size, pi * 1.5, -progressRadians, false, paint);
  }

  @override
  bool shouldRepaint(ProgressPainter other) {
    return animation.value != other.animation.value ||
      color != other.color ||
      backgroundColor != other.backgroundColor;
  }
}

class TimeWatcher extends StatefulWidget {
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<TimeWatcher> with TickerProviderStateMixin {
  List<IconData> icons = <IconData>[
    Icons.alarm, Icons.access_time, Icons.hourglass_empty, Icons.timer,
  ];

  AnimationController _controller;

  Stopwatch stopwatch = new Stopwatch();

  String get timeRemaining {
    return TimerTextFormatter.format(stopwatch.elapsedMilliseconds);
  }

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
    
      
    )
      ;
  }

  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return new Scaffold(
      body: new Padding(
        padding: const EdgeInsets.all(10.0),
        child:
        new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: icons.map((IconData iconData) {
                return new Container(
                  margin: new EdgeInsets.all(10.0),
                  child: new IconButton(
                    icon: new Icon(iconData), onPressed: () {
                    // TODO: Implement
                  }),
                );
              }).toList(),
            ),
            new Expanded(
              child: new Align(
                alignment: FractionalOffset.center,
                child: new AspectRatio(
                  aspectRatio: 1.0,
                  child: new Stack(
                    children: <Widget>[
                      new Positioned.fill(
                        child: new AnimatedBuilder(
                          animation: _controller,
                          builder: (BuildContext context, Widget child) {
                            return new CustomPaint(
                              painter: new ProgressPainter(
                                animation: _controller,
                                color: themeData.indicatorColor,
                                backgroundColor: Colors.white,
                              ),
                            );
                          }
                        ),
                      ),
                      new Align(
                        alignment: FractionalOffset.center,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              'Label', style: themeData.textTheme.subhead),
                            new AnimatedBuilder(
                              animation: _controller,
                              builder: (BuildContext context, Widget child) {
                                return new Text(
                                  timeRemaining,
                                  style: themeData.textTheme.display4,
                                );
                              }
                            ),
                         
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            new Container(
              margin: new EdgeInsets.all(10.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new IconButton(icon: new Icon(Icons.delete), onPressed: () {
                    // TODO: Implement delete
                  }),
                  new FloatingActionButton(
                    child: new AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget child) {
                        return new Icon(
                          _controller.isAnimating
                            ? Icons.pause
                            : Icons.play_arrow
                        );
                      },
                    ),
                    onPressed: () {

                   

                      if(this.stopwatch.isRunning){
                            this.stopwatch.stop();
                            _controller.stop();
                      }else{
                           this.stopwatch.start();
                           _controller.forward();
                         //_controller.value
                      }
                      /* if (_controller.isAnimating)
                        
                      else {
                        _controller.reverse(
                          from: _controller.value == 0.0 ? 1.0 : _controller
                            .value,
                        ); 
                      }*/
                    },
                  ),
                  new IconButton(
                    icon: new Icon(Icons.alarm_add), onPressed: () {
                    // TODO: Implement add time
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}